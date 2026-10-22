// Starts the Elm app with the language remembered in this browser (English when none).
(function () {
  var lang = 'en';
  try { lang = localStorage.getItem('wiki.lang') || 'en'; } catch (e) {}
  var app = Elm.Main.init({ flags: { lang: lang } });
  app.ports.saveLang.subscribe(function (l) {
    try { localStorage.setItem('wiki.lang', l); } catch (e) {}
    document.documentElement.lang = l;
  });
  document.documentElement.lang = lang;
})();
