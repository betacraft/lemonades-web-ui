'use strict'

angular.module('lemonades')
  .controller('MyGroupsCtrl', ['$scope', '$cookies', '$cookieStore', '$http', '$rootScope', '$location',($scope, $cookies, $cookieStore, $http, $rootScope, $location) ->
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.object = {}
    $scope.pageNo = 0;
    $scope.joinedGroupPageNo = 0;
    $scope.createdGroups = []
    $scope.joinedGroups = []
    $scope.fetchingGroups = false
    $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
    $rootScope.image = ""
    $rootScope.url = "http://www.lemonades.in"
    $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."

    $scope.init = ()->
      $rootScope.path=4;
      $rootScope.getUser()
      if($scope.sessionKey == "")
        $location.path("/dashboard")
        return
      $scope.getCreatedGroups()
      $scope.getJoinedGroups()

    $scope.landing = ->
      $location.path("/")

    $scope.allGroups = ->
      $location.path("/dashboard")

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
            $location.path("/dashboard")
            $scope.sessionKey = null
            return
      ).error(
        (data)->
          #doing nothing
      )

    $scope.getCreatedGroups = ->
      $scope.fetchingGroups = true
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/user/groups/created?page=" + $scope.pageNo
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          $scope.fetchingGroups = false
          if data.success
            if data.created_groups == null
              $scope.pageNo = -1
              return
            if $scope.pageNo == 0
              $scope.createdGroups = data.created_groups
            else
              $scope.createdGroups = $scope.groups.concat(data.created_groups)
            if(data.created_groups.length < 9)
              $scope.pageNo = -1
            else
              $scope.pageNo += 1
            return
      ).error(
        (data)->
          $scope.fetchingGroups = false
          #doing nothing
      )

    $scope.getJoinedGroups = ->
      $scope.fetchingGroups = true
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/user/groups/joined?page=" + $scope.joinedGroupPageNo
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          $scope.fetchingGroups = false
          if data.success
            if data.joined_groups == null
              $scope.joinedGroupPageNo = -1
              return
            if $scope.joinedGroupPageNo == 0
              $scope.joinedGroups = data.joined_groups
            else
              $scope.joinedGroups = $scope.groups.concat(data.joined_groups)
            if(data.joined_groups.length < 9)
              $scope.joinedGroupPageNo = -1
            else
              $scope.joinedGroupPageNo += 1
            return
      ).error(
        (data)->
          $scope.fetchingGroups = false
          #doing nothing
      )

])

