'use strict'

describe 'Controller: CheckoutCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  CheckoutCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CheckoutCtrl = $controller 'CheckoutCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
