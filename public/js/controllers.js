'use strict';

/* Controllers */
var CuckooHomeCtrl = ['$scope', '$http', 'TimeUtils', function($scope, $http, TimeUtils) {
  $http.get('api/me.json').success(function(data) {
    $scope.me = data;
  });

  $http.get('api/statuses.json').success(function(data) {
    $scope.statuses = data;
  });

  $scope.newTweet = "";

  $scope.submit = function(newTweet) {
    console.log("Post new tweet: " + newTweet);
  }

  $scope.formatTime = TimeUtils.formatTime;
}];

var CuckooUserCtrl = ['$scope', '$routeParams', 'User', 'FollowUtils', 'TimeUtils', function($scope, $routeParams, User, FollowUtils, TimeUtils) {
  User.get({userId: $routeParams.id}, function(user) {
    var i;

    $scope.user = user;
    for (i = 0; i < user.tweets.length; i++) {
      user.tweets[i].user_id = user.id;
      user.tweets[i].user_name = user.login_name;
    }
  });

  $scope.followUtils = FollowUtils;

  $scope.formatTime = TimeUtils.formatTime;
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
