'use strict'

angular.module('lemonades')
  .controller('GroupCtrl', ['$scope', '$cookies','$cookieStore', '$http', '$rootScope','$routeParams','$location','ngToast','$window', ($scope, $cookies,$cookieStore, $http, $rootScope,$routeParams,$location,ngToast,$window) ->
    $scope.htmlReady();
    $scope.sessionKey = $cookieStore.get("lmnsskey")
    $scope.groupId = $routeParams.id;
    $scope.group = {}
    $scope.joining = false
    $scope.leaving = false
    $scope.shareText = "Buy electronic items in group with huge discounts #onlineshopping #GroupUP";
    $scope.timestamp = Date.now()

    $scope.updatePrice = ()->
      btn = $("#updatePrice").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/product/"+$scope.group.product.id+ "/update_price"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          console.log data
          if data.success
            $scope.group.product = data.product
            btn.button("reset")
            return
      ).error(
        (data)->
          btn.button("reset")

      )

    $scope.initHowItWorks = ()->
      $("#howItWorks").carousel({
        interval:5000,
      })
      $("#howItWorks").carousel('cycle')
      $("#howItWorks").carousel(0)


    $scope.login = ()->
      $location.path("/login")

    $scope.loginToJoin = ()->
      $location.path("/login").search({'join':$scope.groupId})

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


    $scope.joinGroup = (automatedJoin)->
      return if $scope.joining
      console.log "Joining the group"
      $scope.joining = true
      automatedJoin = typeof automatedJoin != 'undefined' ? automatedJoin : false;
      btn = $("#joinGroup").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId + "/join"
        headers:
          'Session-Key': $scope.sessionKey
      $http(req).success(
        (data)->
          btn.button("reset")
          $scope.joining = false
          if data.success
            $scope.timestamp = Date.now()
            $scope.group = data.group
            return
          if automatedJoin
            $location.search({})
            $scope.init()
      ).error(
        (data)->
          $scope.joining = false
          btn.button("reset")
          if automatedJoin
            $location.search({})
            $scope.init()
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
      $rootScope.path = 2;
      $rootScope.getUser()
      if $location.search()["join"]!= undefined
        $scope.joinGroup(true)
      else
        req =
          method: "GET"
          url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId
          headers:
            'Session-Key': $scope.sessionKey
        $http(req).success(
          (data)->
            if data.success
              $rootScope.title = "Buy " + data.group.product.name + " with me on GroupUP.in"
              $rootScope.image = data.group.product.product_image
              $rootScope.url = $location.absUrl()
              $rootScope.description = data.group.interested_users_count + " person is interested in buying " + data.group.product.name + ". Join him on GroupUP.in and get huge discount." if data.group.interested_users_count == 1
              $rootScope.description = data.group.interested_users_count + " people are interested in buying " + data.group.product.name + ". Join them on GroupUP.in and get huge discount." if data.group.interested_users_count > 1
              $scope.group = data.group
              $scope.shareText = "Buy " + data.group.product.name + " with me on GroupUP.in"
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
