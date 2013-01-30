'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('cuckooApp.services', ['ngResource']).
  value('version', '0.1').
  factory('User', function($resource) {
    return $resource('api/user/:userId.json', {}, {});
  });
