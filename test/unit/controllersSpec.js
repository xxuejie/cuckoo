'use strict';

/* jasmine specs for controllers go here */

describe('CuckooHomeCtrl', function(){
  var homeCtrl, scope;

  beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    homeCtrl = $controller(CuckooHomeCtrl, {$scope: scope});
  }));


  it('should ....', function() {
    //spec body
  });
});


describe('CuckooUserCtrl', function(){
  var userCtrl, scope;

  beforeEach(inject(function($controller, $rootScope) {
    scope = $rootScope.$new();
    userCtrl = $controller(CuckooUserCtrl, {$scope: scope});
  }));

  it('should ....', function() {
    //spec body
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
