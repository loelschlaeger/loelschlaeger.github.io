(function () {
  const colorSchemeParam = "color-scheme";

  function currentColorScheme() {
    return document.body.classList.contains("quarto-dark") ? "alternate" : "default";
  }

  function withCurrentColorScheme(href) {
    const url = new URL(href, window.location.href);
    url.searchParams.set(colorSchemeParam, currentColorScheme());
    return url.href;
  }

  function requestedColorScheme() {
    const url = new URL(window.location.href);
    const scheme = url.searchParams.get(colorSchemeParam);
    return scheme === "alternate" || scheme === "default" ? scheme : null;
  }

  function removeColorSchemeParam() {
    const url = new URL(window.location.href);
    if (!url.searchParams.has(colorSchemeParam) || !window.history.replaceState) {
      return;
    }

    url.searchParams.delete(colorSchemeParam);
    window.history.replaceState({}, "", url.href);
  }

  function enableStylesheet(sheet) {
    if (sheet.rel !== "stylesheet") {
      sheet.rel = "stylesheet";
    }
  }

  function disableStylesheet(sheet) {
    sheet.rel = "disabled-stylesheet";
  }

  function applyColorScheme(scheme) {
    const useDark = scheme === "alternate";
    const isDark = document.body.classList.contains("quarto-dark");

    if (useDark !== isDark && typeof window.quartoToggleColorScheme === "function") {
      window.quartoToggleColorScheme();
      return;
    }

    if (useDark === isDark) {
      return;
    }

    const primarySheets = document.querySelectorAll("link.quarto-color-scheme:not(.quarto-color-alternate)");
    const alternateSheets = document.querySelectorAll("link.quarto-color-scheme.quarto-color-alternate");

    primarySheets.forEach(enableStylesheet);
    alternateSheets.forEach(useDark ? enableStylesheet : disableStylesheet);

    document.body.classList.toggle("quarto-dark", useDark);
    document.body.classList.toggle("quarto-light", !useDark);

    document.querySelectorAll(".quarto-color-scheme-toggle").forEach(function (toggle) {
      toggle.classList.toggle("alternate", useDark);
    });
  }

  function restoreRequestedColorScheme() {
    const scheme = requestedColorScheme();
    if (!scheme) {
      return;
    }

    applyColorScheme(scheme);
    removeColorSchemeParam();
  }

  function addLanguageSwitch() {
    if (document.querySelector(".language-switch")) {
      return;
    }

    const isEnglish = document.documentElement.lang.toLowerCase().startsWith("en");
    const switcher = document.createElement("nav");
    switcher.className = "language-switch top-right";
    switcher.setAttribute(
      "aria-label",
      isEnglish ? "Language selection" : "Sprachauswahl"
    );

    const languages = [
      {
        code: "de",
        label: "DE",
        href: "de.html",
        title: "Zur deutschen Version wechseln"
      },
      {
        code: "en",
        label: "EN",
        href: "index.html",
        title: "Switch to the English version"
      }
    ];

    languages.forEach(function (language) {
      const link = document.createElement("a");
      link.href = language.href;
      link.hreflang = language.code;
      link.textContent = language.label;
      link.title = language.title;
      link.setAttribute("aria-label", language.title);
      if ((isEnglish && language.code === "en") || (!isEnglish && language.code === "de")) {
        link.classList.add("active");
        link.setAttribute("aria-current", "page");
      }
      link.addEventListener("click", function (event) {
        event.preventDefault();
        window.location.href = withCurrentColorScheme(link.href);
      });
      switcher.appendChild(link);
    });

    document.body.appendChild(switcher);
  }

  function initLanguageSwitch() {
    window.setTimeout(function () {
      restoreRequestedColorScheme();
      addLanguageSwitch();
    }, 0);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initLanguageSwitch);
  } else {
    initLanguageSwitch();
  }
})();
