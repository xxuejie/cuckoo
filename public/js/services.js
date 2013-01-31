'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cuckooApp.services', ['ngResource']).
  value('version', '0.1').
  factory('User', function($resource) {
    return $resource('api/user/:userId.json', {}, {});
  }).
  factory('FollowUtils', function($http) {
    return {
      "toggleFollow": function(user) {
        var new_follow_state = !user.followed;
        $http.post('api/follow.json',
                   {id: user.id,
                    follow: new_follow_state},
                   {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).
          success(function(data) {
            if (data.status === 'ok') {
              user.followed = data.data.followed;
              console.log(user);
            } else if (data.status === 'error') {
              console.log(data.error);
            }
          });
      },
      "getFollowText": function(user) {
        return user.followed ? "Followed" : "Follow";
      },
      "getFollowClass": function(user) {
        return user.followed ? "btn-primary" : "";
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
    return {
      title: function() {
        return "Cuckoo" + (currentView.length > 0 ? (" | " + currentView) : "");
      },
      isActiveItem: function (item) {
        return item === currentView;
      },
      setView: function(view) {
        currentView = view;
      }
    };
  });
