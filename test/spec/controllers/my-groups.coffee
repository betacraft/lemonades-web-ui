'use strict'

describe 'Controller: MyGroupsCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  MyGroupsCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MyGroupsCtrl = $controller 'MyGroupsCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
