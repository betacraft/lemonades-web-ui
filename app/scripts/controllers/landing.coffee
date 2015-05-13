'use strict';
angular.module('lemonades')
.controller('LandingCtrl',
  ['$scope', '$location', '$rootScope', '$cookieStore', '$http', ($scope, $location, $rootScope, $cookieStore, $http) ->
    $scope.htmlReady();
    $scope.deals = {}
    $scope.dropdownStatus = {
      isopen: false
    };

    $scope.logout = ->
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/user/logout"
        headers:
          'Session-Key': $rootScope.sessionKey
      $http(req).success(
        (data)->
          if data.success
            $cookieStore.remove("lmnsskey")
            $rootScope.sessionKey=null
            return
      ).error(
        (data)->
          #doing nothing
      )

    $scope.createGroup = ->
      btn = $("#createGroup").button("loading")
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/group"
        headers:
          'Session-Key': $rootScope.sessionKey
        data: $scope.object
      $http(req).success(
        (data)->
          $("#createGroupModal").modal("hide")
          btn.button("reset")
          if data.success
            $location.path("/group/" + data.group.id)
            return
          $scope.status =
            message: data.message
            success: false
      ).error(
        (data)->
          btn.button("reset")
          $scope.status =
            message: data.message
            success: false
      )

    $scope.landing = ->
      $location.path("/")

    $scope.dashboard = ->
      $location.path("/dashboard")

    $scope.init = ->
      $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
      $rootScope.image = ""
      $rootScope.url = "http://www.lemonades.in"
      $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."
      $rootScope.getUser()

    $scope.login = ()->
      $location.search({"next":$location.path()})
      $location.path("/login");


    $scope.myGroups = ->
      $location.path("/my-groups")

    $scope.register = ()->
      $location.path("/register");

    $scope.toggled = (open) ->
      console.log('Dropdown is now: ', open);

    $scope.toggleDropdown = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.dropdownStatus.isopen = !$scope.dropdownStatus.isopen


  ])
