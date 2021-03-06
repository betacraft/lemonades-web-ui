'use strict';
angular.module('lemonades')
.controller('MainCtrl',
  ['$scope', '$location', '$rootScope', '$cookieStore', '$http', ($scope, $location, $rootScope, $cookieStore, $http) ->
    $scope.htmlReady();
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.deals = {}

    $scope.dashboard = ->
      $location.path("/dashboard")

    $scope.init = ->
      $location.search({})
      $rootScope.path = 0;
      $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
      $rootScope.image = ""
      $rootScope.url = "http://www.lemonades.in"
      $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."
      $rootScope.getUser()
      $scope.getGroups()


    $scope.dismissMyModal = ()->
      $("#myModal").modal('hide')

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
          if data.success
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

    $scope.privacy = ()->
      $location.path("/privacy");

    $scope.termsOfService = ()->
      $location.path("/terms-of-service");

    $scope.register = ()->
      $location.path("/register");

    $scope.dashboard = ->
      $location.path("/dashboard")
  ])
