// ==========================================================================
// Pergamen Web Landing Page Script
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {
  // Tab Switcher for Downloads
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.tab;

      // Update button state
      tabBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      // Update tab pane state
      tabContents.forEach(content => {
        if (content.id === `tab-${target}`) {
          content.classList.add('active');
        } else {
          content.classList.remove('active');
        }
      });
    });
  });

  // OS Detection to auto-select tab
  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    const iosTab = document.querySelector('.tab-btn[data-tab="ios"]');
    if (iosTab) iosTab.click();
  } else if (/android/i.test(userAgent)) {
    const androidTab = document.querySelector('.tab-btn[data-tab="android"]');
    if (androidTab) androidTab.click();
  }

  // Smooth scroll for internal links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#') return;
      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        e.preventDefault();
        targetElement.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
});
