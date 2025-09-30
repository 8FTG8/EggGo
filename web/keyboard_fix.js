window.addEventListener('load', function(ev) {
  // Fix for keyboard opening resizing the window
  if (window.visualViewport) {
    window.visualViewport.addEventListener('resize', () => {
      window.dispatchEvent(new Event('resize'));
    });
  }
});