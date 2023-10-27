var userAgent = navigator.userAgent || navigator.vendor || window.opera;
console.log("started");
if (/android/i.test(userAgent)) {
    // Redirect to Google Play Store
    console.log("play");
    window.location.href = "https://play.google.com/store/apps/details?id=com.orderOfTheCone.android.menu_app";
} else if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    // Redirect to Apple App Store
    console.log("apple");
    window.location.href = "https://apps.apple.com/us/app/ucsc-menu/id1670523487";
} else {
    // Redirect to website for other devices
    console.log("window");
    window.location.href = "https://www.google.com";
}


// script.js
var userAgent = navigator.userAgent || navigator.vendor || window.opera;

if (/android/i.test(userAgent)) {
    // Try to open the app using the custom URL scheme
    window.location.href = "yourapp://";

    // Redirect to Google Play Store after a timeout
    // if the app is not installed
    setTimeout(function() {
        window.location.href = "https://play.google.com/store/apps/details?id=com.orderOfTheCone.android.menu_app";
    }, 25);
} else if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
    // Try to open the app using the custom URL scheme
    window.location.href = "yourapp://";

    // Redirect to Apple App Store after a timeout
    // if the app is not installed
    setTimeout(function() {
        window.location.href = "https://apps.apple.com/us/app/ucsc-menu/id1670523487";
    }, 25);
} else {
    // Redirect to website for other devices
    window.location.href = "www.google.com";
}

  