'use strict';
angular.module('lemonades')
.controller('MainCtrl',
  ['$scope', '$location', '$rootScope', '$cookieStore', '$http', ($scope, $location, $rootScope, $cookieStore, $http) ->
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.deals = {}

    $scope.dashboard = ->
      $location.path("/dashboard")

    $scope.init = ->
      $rootScope.getUser()
      $scope.getGroups()

    $scope.goToGroup = (groupId)->
      $location.path("/group/" + groupId)

    $scope.getGroups = ->
      console.log "Getting groups"
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/groups"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          console.log "Got groups"
          if data.success
            console.log(data)
            $scope.groups = data.groups.slice(0, 6) if(data.groups.length > 6)
            $scope.groups = data.groups if(data.groups.length <= 6)
            return
      ).error(
        (data)->
          #doing nothing
          $scope.groups = []
      )

    $scope.login = ()->
      $location.path("/login");

    $scope.register = ()->
      $location.path("/register");

    $scope.dashboard = ->
      $location.path("/dashboard")
  ])
