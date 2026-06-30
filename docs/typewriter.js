(function () {
  const selector = "#hi-im-lennart > h3.typewriter-on-load";
  const delay = 160;
  const speed = 55;

  function getGraphemes(text) {
    if (typeof Intl !== "undefined" && typeof Intl.Segmenter === "function") {
      const segmenter = new Intl.Segmenter(document.documentElement.lang || "en", {
        granularity: "grapheme"
      });
      return Array.from(segmenter.segment(text), function (part) {
        return part.segment;
      });
    }

    return Array.from(text);
  }

  function prefersReducedMotion() {
    return window.matchMedia &&
      window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  }

  function runTypewriter() {
    const heading = document.querySelector(selector);
    if (!heading || heading.dataset.typewriterInitialized === "true") {
      return;
    }

    const text = heading.textContent.replace(/\s+/g, " ").trim();
    if (!text) {
      return;
    }

    heading.dataset.typewriterInitialized = "true";

    if (prefersReducedMotion()) {
      heading.textContent = text;
      return;
    }

    const textNode = document.createElement("span");
    textNode.className = "typewriter-text";
    textNode.setAttribute("aria-hidden", "true");

    const cursor = document.createElement("span");
    cursor.className = "typewriter-cursor";
    cursor.setAttribute("aria-hidden", "true");

    heading.setAttribute("aria-label", text);
    heading.textContent = "";
    heading.append(textNode, cursor);

    const characters = getGraphemes(text);
    let index = 0;

    function tick() {
      textNode.textContent = characters.slice(0, index).join("");

      if (index < characters.length) {
        index += 1;
        window.setTimeout(tick, speed);
        return;
      }

      heading.textContent = text;
      heading.removeAttribute("aria-label");
    }

    window.setTimeout(tick, delay);
  }

  function init() {
    window.setTimeout(runTypewriter, 0);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
