---
layout: null
---
document.addEventListener("DOMContentLoaded", function () {
    var burger = document.getElementById("nav-toggle");
    if (!burger) {
        return;
    }
    var target = document.getElementById(burger.dataset.target);
    burger.addEventListener("click", function () {
        burger.classList.toggle("is-active");
        if (target) {
            target.classList.toggle("is-active");
        }
        burger.setAttribute(
            "aria-expanded",
            burger.classList.contains("is-active") ? "true" : "false"
        );
    });
});
