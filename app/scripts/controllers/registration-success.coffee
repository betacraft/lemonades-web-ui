'use strict'

angular.module('lemonades')
  .controller 'RegisterSuccessCtrl', ($scope,$location) ->
    $scope.landing = ->
      $location.path("/")
    $scope.dashboard = ->
      $location.path("/dashboard")
