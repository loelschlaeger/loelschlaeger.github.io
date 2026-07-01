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

  function showPreviousImage(image) {
    const previousIndex = (currentIndex(image) - 1 + images.length) % images.length;
    showImage(image, previousIndex);
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
    image.setAttribute("aria-label", "Click the left half for the previous profile image or the right half for the next profile image");
    image.setAttribute("title", "Left half: previous image, right half: next image");

    image.addEventListener("click", function (event) {
      const bounds = image.getBoundingClientRect();
      if (event.clientX - bounds.left < bounds.width / 2) {
        showPreviousImage(image);
        return;
      }

      showNextImage(image);
    });

    image.addEventListener("keydown", function (event) {
      if (event.key === "ArrowLeft") {
        event.preventDefault();
        showPreviousImage(image);
        return;
      }

      if (event.key !== "Enter" && event.key !== " " && event.key !== "ArrowRight") {
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
