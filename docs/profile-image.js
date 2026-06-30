(function () {
  const selector = ".quarto-about-trestles .about-image";
  const images = [
    {
      src: "files/lennart_oelschlaeger.jpg",
      alt: ""
    },
    {
      src: "files/lennart_schach.jpeg",
      alt: ""
    },
    {
      src: "files/lennart_fliegen.jpeg",
      alt: ""
    }
  ];

  function normalizedPath(src) {
    return new URL(src, window.location.href).pathname;
  }

  function currentIndex(image) {
    const currentPath = normalizedPath(image.getAttribute("src"));
    const index = images.findIndex(function (entry) {
      return normalizedPath(entry.src) === currentPath;
    });
    return index === -1 ? 0 : index;
  }

  function showImage(image, index) {
    const entry = images[index];
    image.src = entry.src;
    image.alt = entry.alt;
  }

  function showNextImage(image) {
    const nextIndex = (currentIndex(image) + 1) % images.length;
    showImage(image, nextIndex);
  }

  function initProfileImageCycle() {
    const image = document.querySelector(selector);
    if (!image || image.dataset.profileImageCycle === "true") {
      return;
    }

    image.dataset.profileImageCycle = "true";
    image.classList.add("profile-image-cycle");
    image.tabIndex = 0;
    image.setAttribute("role", "button");
    image.setAttribute("aria-label", "Click to switch profile image");
    image.setAttribute("title", "Click to switch profile image");

    image.addEventListener("click", function () {
      showNextImage(image);
    });

    image.addEventListener("keydown", function (event) {
      if (event.key !== "Enter" && event.key !== " ") {
        return;
      }

      event.preventDefault();
      showNextImage(image);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initProfileImageCycle);
  } else {
    initProfileImageCycle();
  }
})();
