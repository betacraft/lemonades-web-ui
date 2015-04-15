'use strict';

angular.module('lemonades')
  .controller('MainCtrl', ($scope,$location,$rootScope,$http) ->
    $scope.deals = {}
    $scope.init = ->
      $scope.getGroups()
    $scope.goToGroup = (groupId)->
      $location.path("/group/"+groupId)
    $scope.getGroups = ->
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/groups"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          if data.success
            console.log(data)
            $scope.groups = data.groups.slice(0,5) if(data.groups.length > 6)
            $scope.groups = data.groups if(data.groups.length < 6)
            return
      ).error(
        (data)->
          #doing nothing
      )

    $scope.login = ()->
      $location.path("/login");
    $scope.register = ()->
      $location.path("/register");
    $scope.dashboard = ->
      $location.path("/dashboard")
)
