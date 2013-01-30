'use strict';

/* jasmine specs for services go here */

describe('service', function() {
  beforeEach(module('cuckooApp.services'));

  describe('version', function() {
    it('should return current version', inject(function(version) {
      expect(version).toEqual('0.1');
    }));
  });
});

describe('FollowUtils', function() {
  var followUtils;

  beforeEach(module('cuckooApp.services'));
  beforeEach(inject(function(FollowUtils) {
    followUtils = FollowUtils;
  }));

  it('should get follow text', function() {
    expect(followUtils.getFollowText({"followed": true})).toEqual('Followed');
  });
});

describe('Page', function() {
  var page;

  beforeEach(module('cuckooApp.services'));
  beforeEach(inject(function(Page) {
    page = Page;
  }));

  it('should have default title', function() {
    expect(page.title()).toEqual("Cuckoo");
  });

  it('should check active item', function() {
    page.setView("Home");

    expect(page.isActiveItem("Home")).toBe(true);
    expect(page.isActiveItem("Me")).toBe(false);
    expect(page.isActiveItem("Users")).toBe(false);
  });

  it('should change title when view is changed', function() {
    page.setView("Me");

    expect(page.title()).toEqual("Cuckoo | Me");
  });
});
