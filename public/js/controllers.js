'use strict';

/* Controllers */

var CuckooHomeCtrl = ['$scope', '$http', '$filter', 'TimeUtils', 'Page', function($scope, $http, $filter, TimeUtils, Page) {
  Page.setView('Home');

  $http.get('api/me.json').success(function(data) {
    $scope.me = data;
  });

  $http.get('api/tweets.json').success(function(data) {
    $scope.tweets = data;
  });

  $scope.newTweet = "";

  $scope.submit = function(newTweet) {
    $http.post('api/tweets.json',
               {content: $scope.newTweet},
               {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).
      success(
        function(data) {
          if (data.status === 'ok') {
            $scope.tweets.unshift(data.data);
            $scope.me.tweet_count++;
            $scope.newTweet = "";
          } else if (data.status === 'error') {
            Page.setError(data.error);
          }
        });
  }

  $scope.formatTime = TimeUtils.formatTime;
}];

var CuckooUserCtrl = ['$scope', '$routeParams', 'User',
                      'FollowUtils', 'TimeUtils', 'Page',
                      function($scope, $routeParams, User,
                               FollowUtils, TimeUtils, Page) {
  User.get({name: $routeParams.name}, function(data) {
    if (data.status === 'ok') {
      var i;

      var user = $scope.user = data.data;
      if (user.tweets) {
        for (i = 0; i < user.tweets.length; i++) {
          user.tweets[i].user_id = user.id;
          user.tweets[i].user_name = user.login_name;
        }
      }

      Page.setView(user.login_name);
    } else if (data.status === 'error') {
      Page.setError(data.error);
    }
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
    $http.post('api/me.json',
               {login_name: $scope.me.login_name,
                avatar: $scope.me.avatar,
                description: $scope.me.description},
               {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).
      success(function(data) {
        if (data.status === 'ok') {
          $scope.me = data.data;
          $scope.origin_avatar = data.data.avatar;
          Page.setSuccess("Update succeeded!");
        } else if (data.status === 'error') {
          Page.setError(data.error);
        }
      });
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
