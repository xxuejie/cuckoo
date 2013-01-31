// Simple JS file used for signin/signup page
"use strict";

(function(document, window) {
  var errorText;

  // Taken from http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values
  function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.search);
    if(results == null)
      return "";
    else
      return decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  errorText = getParameterByName("error");
  if (errorText.length > 0) {
    var e = document.getElementById("error-field");
    if (e) {
      e.style.display = "block";
      e.innerText = errorText;
    }
  }
} (document, window));
