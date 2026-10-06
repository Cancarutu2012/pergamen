package app.pergamen.students

import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import app.pergamen.students.live_activity.LiveLessonNotificationManager
import app.pergamen.students.wear.WearSyncManager

class MainActivity : FlutterActivity(), MessageClient.OnMessageReceivedListener {

    private val LIVE_ACTIVITY_CHANNEL = "app.pergamen.students/android_live_activity"
    private val WEAR_CHANNEL = "app.pergamen.students/wear_sync"
    private val TAG = "PergamenPhone.MainActivity"

    private var wearSync: WearSyncManager? = null

    companion object {
        var wearChannel: MethodChannel? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val manager = LiveLessonNotificationManager(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LIVE_ACTIVITY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showOrUpdateNative" -> {
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val subText = call.argument<String>("subText")
                        manager.showOrUpdateNative(title, body, subText)
                        result.success(null)
                    }
                    "showOrUpdateHyperOs" -> {
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val subText = call.argument<String>("subText")
                        val remainingSeconds = call.argument<Int>("remainingSeconds") ?: 0
                        manager.showOrUpdateHyperOs(title, body, subText, remainingSeconds)
                        result.success(null)
                    }
                    "cancel" -> {
                        manager.cancel()
                        result.success(null)
                    }
                    "getCookies" -> {
                        val url = call.argument<String>("url") ?: ""
                        val cookieManager = android.webkit.CookieManager.getInstance()
                        val cookies = cookieManager.getCookie(url) ?: ""
                        result.success(cookies)
                    }
                    else -> result.notImplemented()
                }
            }

        // ── Dynamic App Icon Channel ──────────────────────────────────────
        val iconChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "app.pergamen.students/app_icon"
        )
        iconChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setAppIcon" -> {
                    val iconName = call.argument<String>("iconName")
                    val success = switchAppIcon(iconName)
                    result.success(success)
                }
                "getCurrentIcon" -> {
                    result.success(getCurrentAppIcon())
                }
                else -> result.notImplemented()
            }
        }

        // ── Wear OS sync channel ──────────────────────────────────────────
        val wearMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            WEAR_CHANNEL
        )
        wearChannel = wearMethodChannel
        val sync = WearSyncManager(this, wearMethodChannel)
        wearSync = sync

        wearMethodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "sendTimetable" -> {
                    val json = call.argument<String>("json") ?: ""
                    sync.sendTimetable(json)
                    result.success(null)
                }
                "sendNotifications" -> {
                    val json = call.argument<String>("json") ?: ""
                    sync.sendNotifications(json)
                    result.success(null)
                }
                "isWatchConnected" -> {
                    sync.checkConnection()
                    result.success(sync.isConnected())
                }
                "scheduleMorningSync" -> {
                    sync.scheduleMorningSync()
                    result.success(null)
                }
                "getSyncEnabled" -> {
                    result.success(sync.getSyncEnabled())
                }
                "setSyncEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    sync.setSyncEnabled(enabled)
                    result.success(null)
                }
                "sendCachedToWatch" -> {
                    sync.sendCachedData()
                    result.success(null)
                }
                "sendPairConfirm" -> {
                    val code = call.argument<String>("code") ?: ""
                    sync.sendPairConfirm(code)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        sync.checkConnection()
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume: registering MessageClient listener")
        Wearable.getMessageClient(this).addListener(this)
            .addOnSuccessListener { Log.d(TAG, "MessageClient listener registered OK") }
            .addOnFailureListener { e -> Log.e(TAG, "MessageClient addListener FAILED: ${e.message}", e) }
    }

    override fun onPause() {
        Log.d(TAG, "onPause: unregistering MessageClient listener")
        Wearable.getMessageClient(this).removeListener(this)
        super.onPause()
    }

    // Receives messages from the watch when the phone app is in the foreground.
    // Complements PhoneWearListenerService which handles background delivery.
    override fun onMessageReceived(messageEvent: MessageEvent) {
        val path = messageEvent.path
        Log.d(TAG, "onMessageReceived: path=$path from=${messageEvent.sourceNodeId}")
        when (path) {
            "/folio/sync-request", "/pergamen/sync-request" -> {
                Log.d(TAG, "sync-request: pushing cached data to watch")
                wearSync?.sendCachedData()
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    wearChannel?.invokeMethod("onSyncRequested", null)
                }
            }
            "/folio/pair-request", "/pergamen/pair-request" -> {
                val code = messageEvent.data.toString(Charsets.UTF_8)
                Log.d(TAG, "pair-request from watch: code=$code")
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    wearChannel?.invokeMethod("onPairRequest", code)
                }
            }
        }
    }

    private val ALL_ICON_ALIASES = listOf(
        "MainActivityDefault",
        "MainActivity_dark",
        "MainActivity_light",
        "MainActivity_ocean",
        "MainActivity_emerald",
        "MainActivity_mint",
        "MainActivity_ruby",
        "MainActivity_coral",
        "MainActivity_sunset",
        "MainActivity_amber",
        "MainActivity_purple",
        "MainActivity_indigo",
        "MainActivity_pink",
        "MainActivity_cyan",
        "MainActivity_amoled",
        "MainActivity_cyberpunk",
        "MainActivity_matrix",
        "MainActivity_retrowave",
        "MainActivity_aurora",
        "MainActivity_frost",
        "MainActivity_royal"
    )

    private fun switchAppIcon(iconName: String?): Boolean {
        val pm = packageManager
        val pkg = packageName
        val targetAlias = if (iconName.isNullOrEmpty() || iconName == "default") {
            "MainActivityDefault"
        } else {
            "MainActivity_$iconName"
        }

        return try {
            for (alias in ALL_ICON_ALIASES) {
                val comp = android.content.ComponentName(pkg, "$pkg.$alias")
                val targetState = if (alias == targetAlias) {
                    android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                } else {
                    android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                }
                if (pm.getComponentEnabledSetting(comp) != targetState) {
                    pm.setComponentEnabledSetting(
                        comp,
                        targetState,
                        android.content.pm.PackageManager.DONT_KILL_APP
                    )
                }
            }
            true
        } catch (e: Exception) {
            Log.e(TAG, "Error switching app icon to $iconName", e)
            false
        }
    }

    private fun getCurrentAppIcon(): String {
        val pm = packageManager
        val pkg = packageName
        for (alias in ALL_ICON_ALIASES) {
            val comp = android.content.ComponentName(pkg, "$pkg.$alias")
            if (pm.getComponentEnabledSetting(comp) == android.content.pm.PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return if (alias == "MainActivityDefault") "default" else alias.removePrefix("MainActivity_")
            }
        }
        return "default"
    }

    override fun onDestroy() {
        wearChannel = null
        wearSync = null
        super.onDestroy()
    }
}
