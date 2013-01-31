'use strict';

/* jasmine specs for controllers go here */

describe('Cuckoo controllers', function() {

  beforeEach(module('cuckooApp.services'));

  describe('CuckooHomeCtrl', function(){
    var homeCtrl, scope, $httpBackend;

    beforeEach(inject(function($controller, $rootScope, _$httpBackend_) {
      $httpBackend = _$httpBackend_;
      $httpBackend.expectGET('api/me.json').
        respond({"id": 1, "login_name": "defmacro"});
      $httpBackend.expectGET('api/tweets.json').
        respond([{"content": "test tweet"}]);
      scope = $rootScope.$new();
      homeCtrl = $controller(CuckooHomeCtrl, {$scope: scope});
    }));


    it('should ....', function() {
      //spec body
    });
  });


  describe('CuckooUserCtrl', function(){
    var userCtrl, scope, routeParams, $httpBackend;

    beforeEach(inject(function($controller, $rootScope, _$httpBackend_) {
      scope = $rootScope.$new();
      routeParams = {"id": 1};
      $httpBackend = _$httpBackend_;
      $httpBackend.expectGET('api/user/1.json').
        respond({"id": 1,
                 "login_name": "aaa",
                 "tweets": [
                   {"content": "test_content"}
                 ]});
      userCtrl = $controller(CuckooUserCtrl, {$scope: scope,
                                              $routeParams: routeParams});
    }));

    it('should contains one user with id', function() {
      $httpBackend.flush();

      expect(scope.user.id).toBe(1);
    });

    it('should add user_id and user_name to tweets', function() {
      $httpBackend.flush();

      expect(scope.user.tweets[0].user_id).toBe(1);
      expect(scope.user.tweets[0].user_name).toEqual("aaa");
    });

    it('should be able to format time', function() {
      expect(scope.formatTime(Date.now())).not.toBe(null);
    });
  });

  describe('CuckooUserListCtrl', function() {
    var scope, ctrl, $httpBackend;

    beforeEach(inject(function(_$httpBackend_, $rootScope, $controller) {
      $httpBackend = _$httpBackend_;
      $httpBackend.expectGET('api/users.json').
        respond([{"login_name": "test_user",
                  "avatar": "http://www.gravatar.com/avatar/00000000000000000000000000000000",
                  "description": "I'm just an evil test account-_-",
                  "followed": false}]);


      scope = $rootScope.$new();
      ctrl = $controller(CuckooUserListCtrl, {$scope: scope});
    }));

    it('should have one user', function() {
      $httpBackend.flush();

      expect(scope.users.length).toBe(1);
    });
  });
});
