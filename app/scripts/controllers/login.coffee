'use strict';

angular.module('lemonades')
  .controller('LoginCtrl',['$scope','$cookieStore','$http','$rootScope','$location','session',($scope,$cookieStore,$http,$rootScope,$location,session) ->
    $scope.user = {};
    $scope.landing = ->
      $location.path("/")
    $scope.register = ->
      $location.path("/register")
    $scope.login = ->
      console.log("login")
      btn = $("#loginButton").button("loading")
      console.log("registering")
      $http.post($rootScope.baseUrl + "/api/v1/user/login", $scope.user).success(
        (data)->
          btn.button("reset")
          if data.success
            console.log(data)
            session.store(data.user)
            $cookieStore.put("lmnsskey",data.user.session_key,{expires:1,path:"/"})
            $location.path("/dashboard")
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
])
