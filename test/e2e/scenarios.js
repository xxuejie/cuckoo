'use strict';

/* http://docs.angularjs.org/guide/dev_guide.e2e-testing */

describe('my app', function() {

  beforeEach(function() {
    // clear data
    browser().navigateTo('../../reset');
    browser().navigateTo('../../index.html');
  });

  afterEach(function() {
    signout();
  });

  function signin() {
    input('login_name').enter('user1');
    input('password').enter('pass1');
    element('button.btn-primary').click();
  }

  function signout() {
    element('a.signout-link').click();
  }

  it('should automatically redirect to /signin if we are not already logged in', function() {
    expect(browser().location().url()).toBe("/signin");
  });

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
    it('should have user info and tweet list on the home page', function() {
      signin();

      expect(browser().location().url()).toBe('/home');

      expect(element('h4.home-name').text()).toEqual('user1');
      expect(element('div.tweet-line').count()).toBe(2);

      expect(binding('me.tweet_count')).toEqual("2");
      expect(binding('me.followers')).toEqual("0");

      // NOTE: This is kind of wired: whatever configurations
      // I use, the POST request submitted here always result
      // in 403. Maybe testacular does not play well with something
      // in Rack? Not a clue now, I will come back later maybe.

      // var str = "A new tweet created in e2e test!";
      // input('newTweet').enter(str);
      // element('button.btn-primary').click();

      // expect(element('div.tweet-line').count()).toBe(3);
      // signout();
    });

    it('should be able to see users page and single user page', function() {
      signin();

      element('a[href="#/users"]').click();
      expect(element('div.user-line').count()).toBe(2);

      // This is suffering from the same problem
      // element('button.btn').click();
      element('a[href="#/user/user2"]').click();
      expect(element('div.user-info > h3 > a').text()).toEqual("user2");
      expect(element('div.tweet-line').count()).toBe(2);
    });

    it('should be able to open the me page', function() {
      signin();

      element('a[href="#/me"]').click();
      expect(element('legend').text()).toEqual("View and edit your information here");
      expect(element('input[type="text"]')[0].text()).toEqual("user1");

      element('button.btn-primary').click();
    });
  });
});
