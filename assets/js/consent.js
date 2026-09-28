---
layout: null
---
(function () {
    var STORAGE_KEY = 'analytics-consent';
    var ACCEPTED = 'accepted';
    var DECLINED = 'declined';

    function getStored() {
        try {
            return localStorage.getItem(STORAGE_KEY);
        } catch (e) {
            return null;
        }
    }

    function setStored(value) {
        try {
            localStorage.setItem(STORAGE_KEY, value);
        } catch (e) {}
    }

    function loadAnalytics() {
        if (!window.GA_MEASUREMENT_ID) return;
        if (document.getElementById('gtag-script')) return;

        if (window.ANALYTICS_DRY_RUN) {
            console.log('[consent] dry run: would load GA4 with id ' + window.GA_MEASUREMENT_ID);
            return;
        }

        var script = document.createElement('script');
        script.async = true;
        script.id = 'gtag-script';
        script.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(window.GA_MEASUREMENT_ID);
        document.head.appendChild(script);

        window.dataLayer = window.dataLayer || [];
        function gtag() { window.dataLayer.push(arguments); }
        window.gtag = gtag;
        gtag('js', new Date());
        gtag('config', window.GA_MEASUREMENT_ID);
    }

    var previousFocus = null;

    function onKeydown(e) {
        if (e.key === 'Escape' || e.keyCode === 27) {
            e.preventDefault();
            hideBanner();
        }
    }

    function showBanner() {
        var banner = document.getElementById('consent-banner');
        if (!banner) return;
        previousFocus = document.activeElement;
        banner.hidden = false;
        var declineBtn = banner.querySelector('.consent-decline');
        if (declineBtn && declineBtn.focus) declineBtn.focus();
        document.addEventListener('keydown', onKeydown);
    }

    function hideBanner() {
        var banner = document.getElementById('consent-banner');
        if (banner) banner.hidden = true;
        document.removeEventListener('keydown', onKeydown);
        if (previousFocus && previousFocus.focus) {
            try { previousFocus.focus(); } catch (e) {}
        }
        previousFocus = null;
    }

    function accept() {
        setStored(ACCEPTED);
        hideBanner();
        loadAnalytics();
    }

    function decline() {
        setStored(DECLINED);
        hideBanner();
    }

    function init() {
        if (!window.GA_MEASUREMENT_ID) return;

        var current = getStored();
        if (current === ACCEPTED) {
            loadAnalytics();
        } else if (current !== DECLINED) {
            showBanner();
        }

        var acceptBtn = document.querySelector('#consent-banner .consent-accept');
        var declineBtn = document.querySelector('#consent-banner .consent-decline');
        if (acceptBtn) acceptBtn.addEventListener('click', accept);
        if (declineBtn) declineBtn.addEventListener('click', decline);

        var prefLink = document.getElementById('cookie-preferences-link');
        if (prefLink) {
            prefLink.addEventListener('click', function (e) {
                e.preventDefault();
                showBanner();
            });
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
