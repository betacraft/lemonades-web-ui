'use strict';
angular.module('lemonades')
.controller('LandingCtrl',
  ['$scope', '$location', '$rootScope', '$cookieStore', '$http','ngToast', ($scope, $location, $rootScope, $cookieStore, $http,ngToast) ->
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

    $scope.initCreateGroup = ->
      console.log "Init Create Group"
      $("#createGroup").button("reset")
      $scope.object = null
      $scope.status = {}

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
          $scope.object = null
          if data.success
            $location.path("/group/" + data.group.id)
            return
          $scope.status =
            message: data.message
            success: false
      ).error(
        (data)->
          $scope.object = null
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
      ngToast.create({
        className: 'info',
        content: 'We are currently running a final demo run on the production environment. All the data will be flushed on Monday and We will be LIVE on 19th May 2015 :)',
        dismissOnTimeout:false,
        dismissButton:true
      })
      $rootScope.getUser()

    $scope.login = ()->
      $location.search({"next":$location.path()})
      $location.path("/login");


    $scope.myGroups = ->
      $location.path("/my-groups")

    $scope.register = ()->
      $location.search({"next":$location.path()})
      $location.path("/register");

    $scope.toggled = (open) ->
      console.log('Dropdown is now: ', open);

    $scope.toggleDropdown = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.dropdownStatus.isopen = !$scope.dropdownStatus.isopen


  ])
