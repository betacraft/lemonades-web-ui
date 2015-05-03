'use strict'

angular.module('lemonades')
  .controller('GroupCtrl', ['$scope', '$cookies','$cookieStore', '$http', '$rootScope','$routeParams','$location','$intercom', ($scope, $cookies,$cookieStore, $http, $rootScope,$routeParams,$location,$intercom) ->
    $scope.htmlReady();
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.groupId = $routeParams.id;
    $scope.group = {}
    $scope.joining = false
    $scope.leaving = false
    $scope.shareText = "Buy electronic items in group with huge discounts #onlineshopping #lemonades";

    $scope.init = ()->
      $rootScope.getUser()

    $scope.initHowItWorks = ()->
      $("#howItWorks").carousel({
        interval:5000,
      })
      $("#howItWorks").carousel('cycle')
      $("#howItWorks").carousel(0)


    $scope.login = ()->
      $location.path("/login")


    $scope.leaveGroup = ->
      return if $scope.leaving
      $scope.leaving = true
      btn = $("#joinGroup").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId + "/leave"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          $scope.leaving = false
          console.log data
          if data.success
            $scope.group = data.group
            btn.button("reset")
            return
      ).error(
        (data)->
          $scope.leaving = false
          btn.button("reset")

      )

    $scope.joinGroup = ->
      return if $scope.joining
      $scope.joining = true
      btn = $("#joinGroup").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId + "/join"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          $scope.joining = false
          if data.success
            $scope.group = data.group
            btn.button("reset")
            return
      ).error(
        (data)->
          $scope.joining = false
          btn.button("reset")
      )

    $scope.logout = ->
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/user/logout"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          if data.success
            $intercom.shutdown();
            $cookieStore.remove("lmnsskey")
            $scope.sessionKey=null
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
          btn.button("reset")
          $("#createGroupModal").modal("hide")
          if data.success
            $location.path("/group/"+data.group.id)
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
            $rootScope.title = "Buy " + data.group.product.name + " with me on lemonades.in"
            $rootScope.image = data.group.product.product_image
            $rootScope.url = $location.absUrl()
            $rootScope.description = data.group.interested_users_count + " person is interested in buying " + data.group.product.name + ". Join him on lemonades and get huge discount." if data.group.interested_users_count == 1
            $rootScope.description = data.group.interested_users_count + " people are interested in buying " + data.group.product.name + ". Join them on lemonades and get huge discount." if data.group.interested_users_count > 1
            $scope.group = data.group
            $scope.shareText = "Buy " + data.group.product.name + " with me on lemonades.in"
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
])
