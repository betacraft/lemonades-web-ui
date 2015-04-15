'use strict'

angular.module('lemonades')
  .controller 'GroupCtrl', ($scope, $cookies,$cookieStore, $http, $rootScope,$routeParams,$location) ->
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.groupId = $routeParams.id;
    $scope.group = {}
    $scope.shareText = "Buy electronic items in group with huge discounts #onlineshopping #lemonades";
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
          btn.button("reset")
          $("#createGroupModal").modal("hide")
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
    $scope.dashboard = ->
      $location.path("/dashboard")
    $scope.init = ->
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          if data.success
            console.log(data)
            $scope.group = data.group
            $scope.shareText = "Buy " + data.group.product.name + " with " + data.group.interested_users_count + " on lemonades.in"
            return
          $scope.status =
            message: data.message
            success: false
      ).error(
        (data)->
          $scope.status =
            message: data.message
            success: false
      )
