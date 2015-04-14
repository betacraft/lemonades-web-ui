'use strict';

angular.module('lemonades')
  .controller('MainCtrl', ($scope,$location) ->
    $scope.login = ()->
      $location.path('/login');
    $scope.register = ()->
      $location.path('/register');
)
