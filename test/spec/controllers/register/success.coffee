'use strict'

describe 'Controller: RegisterSuccessCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  RegisterSuccessCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    RegisterSuccessCtrl = $controller 'RegisterSuccessCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
