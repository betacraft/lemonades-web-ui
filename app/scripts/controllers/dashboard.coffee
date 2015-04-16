'use strict'

angular.module('lemonades')
.controller 'DashboardCtrl', ($scope, $cookies, $cookieStore, $http, $rootScope, $location) ->
  $scope.sessionKey = $cookieStore.get("lmnsskey")
  $scope.object = {}
  $scope.pageNo = 0;
  $scope.groups = {}

  $scope.init = ()->
    console.log($scope.sessionKey)
    $rootScope.getUser()
    $scope.getGroups()

  $scope.landing = ->
    $location.path("/")

  $scope.myGroups = ->
    $location.path("/my-groups")

  $scope.goToGroup = (groupId)->
    $location.path("/group/" + groupId)

  $scope.logout = ->
    req =
      method: "POST"
      url: $rootScope.baseUrl + "/api/v1/user/logout"
      headers:
        'Session-Key': $scope.sessionKey
    $http(req).success(
      (data)->
        if data.success
          $cookieStore.remove("lmnsskey")
          console.log(data)
          $scope.sessionKey = null
          return
    ).error(
      (data)->
        #doing nothing
    )

  $scope.getGroups = ->
    req =
      method: "GET"
      url: $rootScope.baseUrl + "/api/v1/groups?page=" + $scope.pageNo
      headers:
        'Session-Key': $scope.sessionKey
    $http(req).success(
      (data)->
        if data.success
          console.log(data)
          if data.groups == null
            $scope.pageNo = -1
            return
          if $scope.pageNo == 0
            $scope.groups = data.groups
          else
            $scope.groups = $scope.groups.concat(data.groups)
          if(data.groups.length < 9)
            $scope.pageNo = -1
          else
            $scope.pageNo += 1
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
        'Session-Key': $scope.sessionKey
      data: $scope.object
    $http(req).success(
      (data)->
        $("#createGroupModal").modal("hide")
        btn.button("reset")
        if data.success
          $location.path("/group/" + data.group.id)
          console.log(data)
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

