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
