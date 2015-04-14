'use strict'

angular.module('lemonades')
  .controller 'DashboardCtrl', ($scope,$cookies) ->
    $scope.sessionKey = $cookies.get("lmn_session_key")
    $scope.init = ()->
      console.log($scope.sessionKey)

