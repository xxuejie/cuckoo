'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cuckooApp.services', ['ngResource']).
  value('version', '0.1').
  factory('User', function($resource) {
    return $resource('api/user/:userId.json', {}, {});
  }).
  factory('FollowUtils', function() {
    return {
      "toggleFollow": function(user) {
        // implement a http request call here
        console.log("Toogle follow status for user: " + user.login_name);

        user.followed = !user.followed;
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
  });
