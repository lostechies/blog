---
layout: null
---
(function () {
    var STORAGE_KEY = "theme";
    var ICONS = {
        light: "fa-sun-o",
        dark: "fa-moon-o"
    };

    function getStoredTheme() {
        try {
            var stored = localStorage.getItem(STORAGE_KEY);
            return (stored === "light" || stored === "dark") ? stored : null;
        } catch (e) {
            return null;
        }
    }

    function getCurrentTheme() {
        var stored = getStoredTheme();
        if (stored) {
            return stored;
        }
        var prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
        return prefersDark ? "dark" : "light";
    }

    function applyTheme(theme) {
        document.documentElement.setAttribute("data-theme", theme);
    }

    function updateButtons(theme) {
        var nextLabel = theme === "dark" ? "Switch to light theme" : "Switch to dark theme";
        var buttons = document.querySelectorAll(".theme-toggle");
        for (var i = 0; i < buttons.length; i++) {
            var icon = buttons[i].querySelector(".fa");
            if (icon) {
                icon.className = "fa " + ICONS[theme];
            }
            buttons[i].setAttribute("aria-label", nextLabel);
            buttons[i].setAttribute("title", nextLabel);
        }
    }

    function toggleTheme() {
        var next = getCurrentTheme() === "dark" ? "light" : "dark";
        try {
            localStorage.setItem(STORAGE_KEY, next);
        } catch (e) {}
        applyTheme(next);
        updateButtons(next);
    }

    function init() {
        updateButtons(getCurrentTheme());

        var buttons = document.querySelectorAll(".theme-toggle");
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener("click", function (e) {
                e.preventDefault();
                toggleTheme();
            });
        }

        if (window.matchMedia) {
            var mql = window.matchMedia("(prefers-color-scheme: dark)");
            var onChange = function () {
                if (getStoredTheme() === null) {
                    var sys = mql.matches ? "dark" : "light";
                    applyTheme(sys);
                    updateButtons(sys);
                }
            };
            if (mql.addEventListener) {
                mql.addEventListener("change", onChange);
            } else if (mql.addListener) {
                mql.addListener(onChange);
            }
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", init);
    } else {
        init();
    }
})();
