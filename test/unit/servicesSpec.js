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
