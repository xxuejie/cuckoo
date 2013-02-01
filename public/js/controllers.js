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
          if (data) {
            $scope.tweets.unshift(data);
            $scope.me.tweet_count++;
            $scope.newTweet = "";
          }
        });
  }

  $scope.invalid = function(newTweet) {
    if (!newTweet) {
      // undefined and empty string
      return true;
    }

    if (newTweet.length > 140) {
      return true;
    }

    return false;
  }

  $scope.formatTime = TimeUtils.formatTime;
}];

var CuckooUserCtrl = ['$scope', '$routeParams', 'User',
                      'FollowUtils', 'TimeUtils', 'Page',
                      function($scope, $routeParams, User,
                               FollowUtils, TimeUtils, Page) {
  User.get({name: $routeParams.name}, function(data) {
    if (data) {
      var i;

      var user = $scope.user = data;
      if (user.tweets) {
        for (i = 0; i < user.tweets.length; i++) {
          user.tweets[i].user_id = user.id;
          user.tweets[i].user_name = user.login_name;
        }
      }

      Page.setView(user.login_name);
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

    $scope.password = $scope.password_again = "";
  })

  $scope.submit = function() {
    var changes = {login_name: $scope.me.login_name,
               avatar: $scope.me.avatar,
               description: $scope.me.description};

    if ($scope.password || $scope.password_again) {
      if ($scope.password !== $scope.password_again) {
        Page.setError("Password does not match!");
        return;
      }
      changes.password = $scope.password;
    }

    $http.post('api/me.json', changes,
               {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).
      success(function(data) {
        if (data) {
          $scope.me = data.data;
          $scope.origin_avatar = data.data.avatar;
          Page.setSuccess("Update succeeded!");
        }
      });
  }
}];

// Page controller, changes title and active item in navigation
// bar according to current view
var CuckooPageCtrl = function($scope, Page) {
  $scope.page = Page;
  $scope.$on('$routeChangeSuccess', function(scope, next, current) {
    Page.setError("");
  });

  $scope.getNavItemClass = function(item) {
    return Page.isActiveItem(item) ? "active" : "";
  }
};
CuckooPageCtrl.$inject = ['$scope', 'Page'];
