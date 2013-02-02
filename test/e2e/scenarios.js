'use strict';

/* http://docs.angularjs.org/guide/dev_guide.e2e-testing */

describe('my app', function() {

  beforeEach(function() {
    // clear data
    browser().navigateTo('../../reset');
    browser().navigateTo('../../index.html');
    element('a.signout-link').click();
  });

  it('should automatically redirect to /signin if we are not already logged in', function() {
    expect(browser().location().url()).toBe("/signin");
  });

  function signin() {
    input('login_name').enter('user1');
    input('password').enter('pass1');

    element('button.btn-primary').click();
  }

  describe('authentication', function() {
    it('should login after entering correct login name/password', function() {
      signin();
      expect(browser().location().url()).toBe('/home');
    });

    it('should not be able to login if the password is wrong', function() {
      input('login_name').enter('user1');
      input('password').enter('wrongpassword');

      element('button.btn-primary').click();

      expect(browser().location().url()).toBe('/signin');
    });

    it('should go to signin page after signout', function() {
      signin();
      element('a.signout-link').click();

      expect(browser().location().url()).toBe('/signin');
    });

    it('should be able to signup', function() {
      element('a.signup-link').click();
      input('login_name').enter('user3');
      input('password').enter('pass3');
      element('button.btn-primary').click();
      expect(browser().location().url()).toBe('/home');

      // try logging out and re-log in
      element('a.signout-link').click();
      expect(browser().location().url()).toBe('/signin');

      input('login_name').enter('user3');
      input('password').enter('pass3');
      element('button.btn-primary').click();
      expect(browser().location().url()).toBe('/home');
    });
  });

  describe('feature test', function() {
    beforeEach(function() {
      signin();
    });

    it('should have user info and tweet list on the home page', function() {
      expect(browser().location().url()).toBe('/home');

      expect(element('h4.home-name').text()).toEqual('user1');
      expect(element('div.tweet-line').count()).toBe(2);

      expect(binding('me.tweet_count')).toEqual("2");
      expect(binding('me.followers')).toEqual("0");
    });
  });
});
