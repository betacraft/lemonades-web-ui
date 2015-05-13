'use strict'

describe 'Controller: TermsOfServiceCtrl', ->

  # load the controller's module
  beforeEach module 'lemonadesApp'

  TermsOfServiceCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TermsOfServiceCtrl = $controller 'TermsOfServiceCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
