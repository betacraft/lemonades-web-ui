'use strict'

describe 'Controller: GroupCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  GroupCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    GroupCtrl = $controller 'GroupCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
