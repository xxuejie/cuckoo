'use strict';

/* Controllers */
var CuckooHomeCtrl = ['$scope', '$http', 'TimeUtils', 'Page', function($scope, $http, TimeUtils, Page) {
  Page.setView('Home');

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

var CuckooUserCtrl = ['$scope', '$routeParams', 'User',
                      'FollowUtils', 'TimeUtils', 'Page',
                      function($scope, $routeParams, User,
                               FollowUtils, TimeUtils, Page) {
  User.get({userId: $routeParams.id}, function(user) {
    var i;

    $scope.user = user;
    if (user.tweets) {
      for (i = 0; i < user.tweets.length; i++) {
        user.tweets[i].user_id = user.id;
        user.tweets[i].user_name = user.login_name;
      }
    }

    Page.setView(user.login_name);
  });

  $scope.followUtils = FollowUtils;

  $scope.formatTime = TimeUtils.formatTime;
}];

var CuckooUserListCtrl = ['$scope', '$http', 'FollowUtils', 'Page',
                          function($scope, $http, FollowUtils, Page) {
  Page.setView("Users");

  $http.get('api/users.json').success(function(data) {
    $scope.users = data;
  });

  $scope.followUtils = FollowUtils;
}];

var CuckooEditCtrl = ['$scope', '$http', 'Page', function($scope, $http, Page) {
  Page.setView("Me");

  $http.get('api/me.json').success(function(data) {
    $scope.me = data;
    $scope.origin_avatar = data.avatar;
  })

  $scope.submit = function() {
    console.log("Submitting user: " + JSON.stringify($scope.me));
  }
}];

// Page controller, changes title and active item in navigation
// bar according to current view
var CuckooPageCtrl = function($scope, Page) {
  $scope.page = Page;

  $scope.getNavItemClass = function(item) {
    return Page.isActiveItem(item) ? "active" : "";
  }
};
CuckooPageCtrl.$inject = ['$scope', 'Page'];
