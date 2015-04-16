'use strict';

angular.module('lemonades')
.controller('RegisterCtrl', ($scope, $location, $http, $rootScope) ->
  $scope.user = {};
  $scope.landing = ->
    $location.path("/")
  $scope.login = ->
    $location.path("/login")
  $scope.register = ()->
    if $scope.user.password == undefined
      $scope.status =
        message : "Min length of password must be 8 characters"
        success:false
      return
    if $scope.user.password != $scope.user.confirm_password
      $scope.status =
        message : "Passwords are not matching"
        success:false
      return
    btn = $("#signUpButton").button("loading")
    console.log("registering")
    $http.post($rootScope.baseUrl + "/api/v1/user", $scope.user).success(
      (data)->
        btn.button("reset")
        $scope.status = {}
        if data.success
          $location.path("/register/success")
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
)
