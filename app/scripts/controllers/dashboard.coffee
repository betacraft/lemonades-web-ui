'use strict'
angular.module('lemonades')
.controller('DashboardCtrl', ['$scope', '$cookies', '$cookieStore', '$http', '$rootScope', '$location', ($scope, $cookies, $cookieStore, $http, $rootScope, $location) ->
  $scope.sessionKey = $cookieStore.get("lmnsskey")
  $scope.object = {}
  $scope.pageNo = 0;
  $scope.groups = {}
  $scope.searchTerm = ""
  $scope.fetchingGroups =false;
  $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
  $rootScope.image = ""
  $rootScope.url = "http://www.lemonades.in"
  $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."

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

  $scope.init = ()->
    $rootScope.path = 1;
    $rootScope.getUser()
    $scope.getGroups()

  $scope.landing = ->
    $location.path("/")

  $scope.myGroups = ->
    $location.path("/my-groups")

  $scope.goToGroup = (groupId)->
    $location.path("/group/" + groupId)


  $scope.initHowItWorks = ()->
    $("#howItWorks").carousel({
      interval:5000
    })
    $("#howItWorks").carousel('cycle')
    $("#howItWorks").carousel(0)

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
          $scope.sessionKey = null
          return
    ).error(
      (data)->
        #doing nothing
    )

  $scope.getGroupsForSearch = ->
    console.log "CAlling get groups for search"
    $scope.getGroups(true)


  $scope.getGroups = (forSearch)->
    forSearch = typeof forSearch  != 'undefined' ? forSearch  : false;
    return if $scope.fetchingGroups
    $scope.fetchingGroups = true
    if forSearch
      $scope.pageNo = 0
      $scope.groups = []
    if $scope.pageNo == -1
      $scope.fetchingGroups = false
      return
    req =
      method: "GET"
      url: $rootScope.baseUrl + "/api/v1/groups"
      params: {page:$scope.pageNo,search:$scope.searchTerm}
      headers:
        'Session-Key': $scope.sessionKey
    $http(req).success(
      (data)->
        console.log data
        if data.success
          if data.groups == null
            $scope.pageNo = -1
            $scope.fetchingGroups = false
            return
          if $scope.pageNo == 0
            $scope.groups = data.groups
          else
            $scope.groups = $scope.groups.concat(data.groups)
          if(data.groups.length < 9)
            $scope.pageNo = -1
          else
            $scope.pageNo += 1
          $scope.fetchingGroups = false
          return
    ).error(
      (data)->
        $scope.fetchingGroups = false
        #doing nothing
    )
])

