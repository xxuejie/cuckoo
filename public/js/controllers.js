'use strict';

/* Controllers */
var CuckooHomeCtrl = ['$scope', function($scope) {
}];

var CuckooUserCtrl = ['$scope', '$routeParams', 'User', function($scope, $routeParams, User) {
  $scope.user = User.get({userId: $routeParams.id}, function(user) {
  });

  $scope.toggleFollow = function(user) {
    // implement a http request call here
    console.log("Toogle follow status for user: " + user.login_name);

    user.followed = !user.followed;
  };

  $scope.getFollowText = function(followed) {
    return followed ? "Followed" : "Follow";
  }

  $scope.getFollowClass = function(followed) {
    return followed ? "btn-primary" : "";
  }

  $scope.formatTime = function(t) {
    return moment(new Date(parseInt(t))).fromNow();
  }
}];

var CuckooUserListCtrl = [ '$scope', '$http', function($scope, $http) {
  $http.get('api/users.json').success(function(data) {
    $scope.users = data;
  });

  $scope.toggleFollow = function(user) {
    // implement a http request call here
    console.log("Toogle follow status for user: " + user.login_name);

    user.followed = !user.followed;
  };

  $scope.getFollowText = function(followed) {
    return followed ? "Followed" : "Follow";
  }

  $scope.getFollowClass = function(followed) {
    return followed ? "btn-primary" : "";
  }
}];
