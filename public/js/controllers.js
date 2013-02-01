'use strict';

/* Controllers */

var CuckooHomeCtrl = ['$scope', '$http', '$filter', 'TimeUtils', 'Page', function($scope, $http, $filter, TimeUtils, Page) {
  var loadingMe = true, loadingTweets = true;

  function checkLoading() {
    // When network error happens, the loading flag is already removed in
    // http inteceptor
    if (!Page.loading()) {
      return;
    }

    Page.setLoading(loadingMe || loadingTweets);
  }

  Page.setView('Home');

  $http.get('api/me.json').success(function(data) {
    $scope.me = data;

    loadingMe = false;
    checkLoading();
  });

  $http.get('api/tweets.json').success(function(data) {
    $scope.tweets = data;

    loadingTweets = false;
    checkLoading();
  });

  $scope.newTweet = "";

  $scope.submit = function(newTweet) {
    $http.post('api/tweets.json',
               {content: $scope.newTweet}).
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

var CuckooUserCtrl = ['$scope', '$routeParams', '$http',
                      'FollowUtils', 'TimeUtils', 'Page',
                      function($scope, $routeParams, $http,
                               FollowUtils, TimeUtils, Page) {
  $http.get('api/user/' + $routeParams.name + '.json').success(function(data) {
    Page.setLoading(false);

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
    Page.setLoading(false);

    $scope.users = data;
  });

  $scope.followUtils = FollowUtils;
}];

var CuckooEditCtrl = ['$scope', '$http', 'Page', function($scope, $http, Page) {
  Page.setView("Me");

  $http.get('api/me.json').success(function(data) {
    Page.setLoading(false);

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

    $http.post('api/me.json', changes).
      success(function(data) {
        if (data) {
          $scope.me = data;
          $scope.origin_avatar = data.avatar;
          Page.setSuccess("Update succeeded!");
        }
      });
  }
}];

var CuckooSigninCtrl = ['$scope', '$http', '$location', 'Page',
                        function($scope, $http, $location, Page) {
  Page.setView('Signin');
  Page.setLoading(false);

  $scope.submit = function() {
    if (!($scope.login_name && $scope.password)) {
      Page.setError("Login name/Password cannot be empty!");
    } else {
      $http.post('api/signin.json',
                 {login_name: $scope.login_name, password: $scope.password}).
        success(function(data) {
          if (data) {
            $location.path('/');
          }
        });
    }
  }
}];

var CuckooSignupCtrl = ['$scope', '$http', '$location', 'Page',
                        function($scope, $http, $location, Page) {
  Page.setView('Signup');
  Page.setLoading(false);

  $scope.submit = function() {
    if (!($scope.login_name && $scope.password)) {
      Page.setError("Login name/Password cannot be empty!");
    } else {
      $http.post('api/signup.json',
                 {login_name: $scope.login_name,
                  password: $scope.password,
                  avatar: $scope.avatar,
                  description: $scope.description}).
        success(function(data) {
          if (data) {
            $location.path('/');
          }
        });
    }
  }
}];

// Page controller, changes title and active item in navigation
// bar according to current view
var CuckooPageCtrl = function($scope, Page, $http, $location) {
  $scope.page = Page;
  $scope.$on('$routeChangeSuccess', function(scope, next, current) {
    Page.setError("");
    Page.setLoading(true);
  });

  $scope.getNavItemClass = function(item) {
    return Page.isActiveItem(item) ? "active" : "";
  }

  $scope.signout = function() {
    $http.get('api/signout.json').success(function(data) {
      if (data) {
        $location.path('/signin');
      }
    });
  }
};
CuckooPageCtrl.$inject = ['$scope', 'Page', '$http', '$location'];
