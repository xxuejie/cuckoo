'use strict';

/* Controllers */
var CuckooHomeCtrl = ['$scope', function($scope) {
}];

var CuckooUserCtrl = ['$scope', '$routeParams', 'User', 'FollowUtils', function($scope, $routeParams, User, FollowUtils) {
  $scope.user = User.get({userId: $routeParams.id}, function(user) {
  });

  $scope.followUtils = FollowUtils;

  $scope.formatTime = function(t) {
    return moment(new Date(parseInt(t))).fromNow();
  }
}];

var CuckooUserListCtrl = [ '$scope', '$http', 'FollowUtils', function($scope, $http, FollowUtils) {
  $http.get('api/users.json').success(function(data) {
    $scope.users = data;
  });

  $scope.followUtils = FollowUtils;
}];

var CuckooEditCtrl = ['$scope', '$http', function($scope, $http) {
  $http.get('api/me.json').success(function(data) {
    $scope.me = data;
    $scope.origin_avatar = data.avatar;
  })

  $scope.submit = function() {
    console.log("Submitting user: " + JSON.stringify($scope.me));
  }
}];
