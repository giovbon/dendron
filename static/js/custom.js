const MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
const watchTarget = document.getElementById("app-container");

const throttle = (func, limit) => {
  let inThrottle;
  return (...args) => {
    if (!inThrottle) {
      requestAnimationFrame(() => func(...args));
      inThrottle = setTimeout(() => (inThrottle = false), limit);
    }
  };
};

function hideNamespace() {
  document
    .querySelectorAll('a.page-ref[data-ref*="/"]:not(.hidden-namespace)')
    .forEach((el) => {
      const text = el.textContent;
      if (text.includes("/")) {
        el.innerHTML =
          "<span style='color:rgb(133, 211, 81)'>..</span>" +
          text.substring(text.lastIndexOf("/"));
        el.classList.add("hidden-namespace");
      }
    });
}

const updateHideNamespace = throttle(hideNamespace, 1000);
const obsNamespace = new MutationObserver(updateHideNamespace);
obsNamespace.observe(watchTarget, {
  subtree: true,
  childList: true,
});

