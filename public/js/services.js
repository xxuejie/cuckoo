'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cuckooApp.services', ['ngResource']).
  value('version', '0.1').
  factory('User', function($resource) {
    return $resource('api/user/:name.json', {}, {});
  }).
  factory('FollowUtils', function($http, Page) {
    return {
      "toggleFollow": function(user) {
        if (!user) {
          return;
        }
        var new_follow_state = !user.followed;
        $http.post('api/follow.json',
                   {id: user.id,
                    follow: new_follow_state},
                   {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).
          success(function(data) {
            if (data.status === 'ok') {
              user.followed = data.data.followed;
            } else if (data.status === 'error') {
              Page.setError(data.error);
            }
          });
      },
      "getFollowText": function(user) {
        return (user && user.followed) ? "Followed" : "Follow";
      },
      "getFollowClass": function(user) {
        return (user && user.followed) ? "btn-primary" : "";
      }
    };
  }).
  factory('TimeUtils', function() {
    return {
      // t is a string value of Date.now()
      "formatTime": function(t) {
        return moment(new Date(parseInt(t))).fromNow();
      }
    };
  }).
  factory('Page', function() {
    var currentView = "";
    var alertText = "";
    var alertError = false;

    return {
      title: function() {
        return "Cuckoo" + (currentView.length > 0 ? (" | " + currentView) : "");
      },
      isActiveItem: function (item) {
        return item === currentView;
      },
      setView: function(view) {
        currentView = view;
      },
      alert: function() {
        return alertText;
      },
      alertClass: function() {
        return alertError ? "alert-error" : "alert-success";
      },
      setError: function(errorText) {
        alertText = errorText;
        alertError = true;
      },
      setSuccess: function(successText) {
        alertText = successText;
        alertError = false;
      }
    };
  });
