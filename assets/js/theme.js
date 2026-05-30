---
layout: null
---
(function () {
    var STORAGE_KEY = "theme";
    var THEMES = ["light", "dark", "system"];
    var ICONS = {
        light: "fa-sun-o",
        dark: "fa-moon-o",
        system: "fa-desktop"
    };

    function getStoredTheme() {
        try {
            var stored = localStorage.getItem(STORAGE_KEY);
            return THEMES.indexOf(stored) >= 0 ? stored : "system";
        } catch (e) {
            return "system";
        }
    }

    function applyTheme(theme) {
        if (theme === "system") {
            var prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
            if (prefersDark) {
                document.documentElement.setAttribute("data-theme", "dark");
            } else {
                document.documentElement.removeAttribute("data-theme");
            }
        } else {
            document.documentElement.setAttribute("data-theme", theme);
        }
    }

    function updateButtons(theme) {
        var buttons = document.querySelectorAll(".theme-toggle");
        for (var i = 0; i < buttons.length; i++) {
            var icon = buttons[i].querySelector(".fa");
            if (icon) {
                icon.className = "fa " + ICONS[theme];
            }
            buttons[i].setAttribute("aria-label", "Theme: " + theme + " (click to change)");
            buttons[i].setAttribute("title", "Theme: " + theme + " (click to change)");
        }
    }

    function cycleTheme() {
        var current = getStoredTheme();
        var next = THEMES[(THEMES.indexOf(current) + 1) % THEMES.length];
        try {
            localStorage.setItem(STORAGE_KEY, next);
        } catch (e) {}
        applyTheme(next);
        updateButtons(next);
    }

    function init() {
        var current = getStoredTheme();
        updateButtons(current);

        var buttons = document.querySelectorAll(".theme-toggle");
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener("click", function (e) {
                e.preventDefault();
                cycleTheme();
            });
        }

        if (window.matchMedia) {
            var mql = window.matchMedia("(prefers-color-scheme: dark)");
            var onChange = function () {
                if (getStoredTheme() === "system") {
                    applyTheme("system");
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
