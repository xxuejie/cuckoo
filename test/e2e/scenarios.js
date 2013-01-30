'use strict';

/* http://docs.angularjs.org/guide/dev_guide.e2e-testing */

describe('my app', function() {

  beforeEach(function() {
    browser().navigateTo('../../index.html');
  });


  it('should automatically redirect to /home when location hash/fragment is empty', function() {
    expect(browser().location().url()).toBe("/home");
  });


  describe('home', function() {

    beforeEach(function() {
      browser().navigateTo('#/home');
    });


    it('should render home when user navigates to /home', function() {
      // TODO: add this when we figure out a way to host static JSON files in testing mode
    });

  });


  describe('user', function() {

    beforeEach(function() {
      browser().navigateTo('#/user/1');
    });


    it('should render user when user navigates to /user', function() {
    });
  });
});
