'use strict';


// Declare app level module which depends on filters, and services
angular.module('cuckooApp', ['cuckooApp.filters', 'cuckooApp.services', 'cuckooApp.directives']).
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/home', {templateUrl: 'partials/home.html', controller: CuckooHomeCtrl});
    $routeProvider.when('/users', {templateUrl: 'partials/users.html', controller: CuckooUserListCtrl});
    $routeProvider.when('/user/:id', {templateUrl: 'partials/user.html', controller: CuckooUserCtrl});
    $routeProvider.otherwise({redirectTo: '/home'});
  }]);
