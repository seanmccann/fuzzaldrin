filter = require '../src/filter'

describe "filtering", ->
  it "returns an array of the most accurate results", ->
    candidates = ['Gruntfile','filter', 'bile', null, '', undefined]
    expect(filter(candidates, 'file')).toEqual ['filter', 'Gruntfile']

  describe "when the maxResults option is set", ->
    it "limits the results to the result size", ->
      candidates = ['Gruntfile','filter', 'bile']
      expect(filter(candidates, 'file', maxResults: 1)).toEqual ['filter']

  describe "when the entries contains slashes", ->
    it "weighs basename matches higher", ->
      candidates = ['/bar/foo', '/foo/bar']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual ['/foo/bar']

      candidates = ['/bar/foo/qux', '/foo/bar/qux/baz']
      expect(filter(candidates, 'br baz', maxResults: 1)).toEqual ['/foo/bar/qux/baz']

      candidates = ['/bar/foo', '/foo/bar/////////']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual ['/foo/bar/////////']

      candidates = ['/bar/foo', '/foo/bar', 'bar']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual ['bar']

      candidates = ['/bar/foo', '/foo/bar', '/bar']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual ['/bar']

      candidates = ['/bar/foo', 'bar/////////']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual ['bar/////////']

  describe "when the candidate is all slashes", ->
    it "does not throw an exception", ->
      candidates = ['/']
      expect(filter(candidates, 'bar', maxResults: 1)).toEqual []
