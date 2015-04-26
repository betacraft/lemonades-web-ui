'use strict'

describe 'Controller: ResetPasswordCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  ResetPasswordCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ResetPasswordCtrl = $controller 'ResetPasswordCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
