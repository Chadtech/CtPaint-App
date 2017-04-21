assert = require "assert"

hash = require "../server/hash"


describe "Password", ->
  describe "Salt", ->
    it "should be unique", ->
      assert.notEqual hash.salt(), hash.salt()
    
    it "should be 32 characters long", ->
      assert.equal hash.salt().length, 32 

  describe "Hash", ->
    it "should have the same output, with same input", ->
      salt = hash.salt()
      assert.equal (hash.get salt), (hash.get salt)
    
    it "should have different outputs with different input", ->
      assert.notEqual (hash.get hash.salt()), (hash.get hash.salt())

    it "should have a length of 64", ->
      assert.equal (hash.get hash.salt()).length, 64 