'use strict'

describe 'Controller: PrivacyCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  PrivacyCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrivacyCtrl = $controller 'PrivacyCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
