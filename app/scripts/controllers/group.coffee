'use strict'

angular.module('lemonades')
  .controller('GroupCtrl', ['$scope', '$cookies','$cookieStore', '$http', '$rootScope','$routeParams','$location','ngToast','$window','$filter', ($scope, $cookies,$cookieStore, $http, $rootScope,$routeParams,$location,ngToast,$window,$filter) ->
    $scope.htmlReady();
    $scope.groupId = $routeParams.id;
    $scope.group = {}
    $scope.joining = false
    $scope.leaving = false
    $scope.shareText = "Buy electronic items in group with huge discounts #onlineshopping #GroupUP";
    $scope.timestamp = Date.now()
    $scope.labels = []
    $scope.series = []
    $scope.cdata = []

    $scope.updatePrice = ()->
      btn = $("#updatePrice").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/product/"+$scope.group.product.id+ "/update_price"
        headers:
          'Session-Key': $rootScope.sessionKey
      $http(req).success(
        (data)->
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
          'Session-Key': $rootScope.sessionKey
      $http(req).success(
        (data)->
          $scope.leaving = false
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
      $scope.joining = true
      automatedJoin = typeof automatedJoin != 'undefined' ? automatedJoin : false;
      btn = $("#joinGroup").button('loading')
      req =
        method: "POST"
        url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId + "/join"
        headers:
          'Session-Key': $rootScope.sessionKey
      $http(req).success(
        (data)->
          btn.button("reset")
          $scope.joining = false
          if data.success
            $('#shareGroupModal').modal('show')
            $scope.timestamp = Date.now()
            $scope.group = data.group
          if !data.success
            ngToast.create({
              className: 'danger',
              content: data.message,
            })
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

    $scope.dashboard = ->
      $location.path("/dashboard")

    $scope.init = ->
      $rootScope.path = 2;
      $rootScope.getUser()
      if $location.search()["join"]!= undefined && $location.search()["join"] == $scope.groupId
        $scope.joinGroup(true)
      else
        req =
          method: "GET"
          url: $rootScope.baseUrl + "/api/v1/group/"+$scope.groupId
          headers:
            'Session-Key': $rootScope.sessionKey
        $http(req).success(
          (data)->
            if data.success
              $rootScope.title = "Buy " + data.group.product.name + " with me on GroupUP.in"
              $rootScope.image = data.group.product.product_image
              $rootScope.url = $location.absUrl()
              $rootScope.description = data.group.interested_users_count + " person is interested in buying " + data.group.product.name + ". Join him on GroupUP.in and get huge discount." if data.group.interested_users_count == 1
              $rootScope.description = data.group.interested_users_count + " people are interested in buying " + data.group.product.name + ". Join them on GroupUP.in and get huge discount." if data.group.interested_users_count > 1
              $scope.group = data.group
              $scope.series.push("Price History (Rs)")
              seriesData = []
              for price in data.group.product.price_history
                console.log price
                $scope.labels.push($filter('date')(price.date, 'd/M', null))
                seriesData.push(price.price_value)
              $scope.cdata.push(seriesData)

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
