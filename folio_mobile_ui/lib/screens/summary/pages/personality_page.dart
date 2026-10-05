import 'dart:io';

import 'package:folio/api/providers/user_provider.dart';
import 'package:folio/theme/colors/colors.dart';
import 'package:folio_mobile_ui/common/personality_card/empty_card.dart';
import 'package:folio_mobile_ui/common/personality_card/personality_card.dart';
import 'package:folio_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class PersonalityBody extends StatefulWidget {
  const PersonalityBody({super.key});

  @override
  PersonalityBodyState createState() => PersonalityBodyState();
}

class PersonalityBodyState extends State<PersonalityBody> {
  late UserProvider user;

  bool isRevealed = false;

  ScreenshotController screenshotController = ScreenshotController();

  sharePersonality() async {
    await screenshotController.capture().then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        if (await File('${directory.path}/folio_personality.png').exists()) {
          await File('${directory.path}/folio_personality.png').delete();
        }
        final imagePath =
            await File('${directory.path}/folio_personality.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    }).catchError((err) {
      throw err;
    });
  }

  savePersonality() async {
    await screenshotController.capture().then((image) async {
      if (image != null) {
        await ImageGallerySaverPlus.saveImage(image, name: 'folio_personality');
      }
    }).catchError((err) {
      throw err;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);

    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
      children: [
        Text(
          'title_personality'.i18n,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            color: AppColors.of(context).text,
          ),
        ),
        const SizedBox(height: 16.0),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 1000),
          sizeCurve: Curves.easeInToLinear,
          firstChild: Screenshot(
            controller: screenshotController,
            child: PersonalityCard(user: user),
          ),
          secondChild: GestureDetector(
            onTap: () => setState(() {
              isRevealed = true;
            }),
            child: EmptyCard(text: 'click_reveal'.i18n),
          ),
          crossFadeState:
              isRevealed ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
        const SizedBox(height: 24),
        if (isRevealed)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () async {
                    await sharePersonality();
                  },
                  icon: const Icon(Icons.share_rounded, size: 30),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton.filledTonal(
                  onPressed: () async {
                    await savePersonality();
                  },
                  icon: const Icon(Icons.bookmark_rounded, size: 30),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
