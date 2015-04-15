'use strict'

angular.module('lemonades')
.controller 'DashboardCtrl', ($scope, $cookies,$cookieStore, $http, $rootScope,$location) ->
  $scope.sessionKey = $cookieStore.get("lmnsskey")
  $scope.object = {}
  $scope.pageNo = 0;
  $scope.groups = {}
  $scope.init = ()->
    console.log($scope.sessionKey)
    $scope.getGroups()
  $scope.landing = ->
    $location.path("/")
  $scope.goToGroup = (groupId)->
    $location.path("/group/"+groupId)
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
          $scope.groups = data.groups
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
          $location.path("/group/"+data.group.id)
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

