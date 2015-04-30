'use strict'

describe 'Directive: fbComments', ->

  # load the directive's module
  beforeEach module 'lemonadesApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<fb-comments></fb-comments>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the fbComments directive'
