(function () {
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
      switcher.appendChild(link);
    });

    document.body.appendChild(switcher);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", addLanguageSwitch);
  } else {
    addLanguageSwitch();
  }
})();
