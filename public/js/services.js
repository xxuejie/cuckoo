'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cuckooApp.services', ['ngResource']).
  value('version', '0.1').
  config(function ($httpProvider) {
    $httpProvider.responseInterceptors.push('cuckooApiInterceptor');
    $httpProvider.defaults.headers.post['Content-Type'] =
      'application/x-www-form-urlencoded';
  }).
  factory('cuckooApiInterceptor', function($q, Page, $location) {
    function success(response) {
      if (response.data.status === 'ok') {
        response.data = response.data.data;
      } else if (response.data.status === 'error') {
        Page.setError(response.data.error);
        response.data = undefined;
      }
      return response;
    }
    function error(response) {
      Page.setLoading(false);
      if (response.status === 403) {
        // login error, redirect to signin page directly
        $location.path("/signin");
      } else {
        Page.setError("Network error occurs! Status code: " + response.status);
      }
      return $q.reject(response);
    }
    return function(promise) {
      return promise.then(success, error);
    }
  }).
  factory('FollowUtils', function($http) {
    return {
      "toggleFollow": function(user) {
        if (!user) {
          return;
        }
        var new_follow_state = !user.followed;
        $http.post('/api/follow.json',
                   {id: user.id,
                    follow: new_follow_state}).
          success(function(data) {
            if (data) {
              user.followed = data.followed;
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
    var isLoading = true;

    return {
      title: function() {
        return "Cuckoo" + ((currentView && (currentView.length > 0)) ? (" | " + currentView) : "");
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
      },
      loading: function() {
        return isLoading;
      },
      setLoading: function(newLoading) {
        isLoading = newLoading;
      }
    };
  });
