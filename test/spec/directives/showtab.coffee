'use strict'

describe 'Directive: showtab', ->

  # load the directive's module
  beforeEach module 'lemonadesApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<showtab></showtab>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the showtab directive'
