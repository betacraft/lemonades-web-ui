'use strict';

angular.module('lemonades')
  .controller('RegisterCtrl', ($scope,$location) ->
    $scope.user = {};
    $scope.register = ()->
      console.log("registering")
)
