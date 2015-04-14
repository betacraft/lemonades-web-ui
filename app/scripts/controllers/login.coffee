'use strict';

angular.module('lemonades')
  .controller('LoginCtrl', ($scope) ->
    $scope.login = ()->
      console.log("login")
)
