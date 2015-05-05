'use strict';

angular.module('lemonades')
.controller('LoginCtrl',
  ['$scope', '$cookieStore', '$http', '$rootScope', '$location', 'session', 'ngToast','GooglePlus',
    ($scope, $cookieStore, $http, $rootScope, $location, session, ngToast,GooglePlus) ->
      $scope.user = {}
      $scope.fbUser = {}
      $scope.fbStatus = null
      $scope.object = {}
      $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
      $rootScope.image = ""
      $rootScope.url = "http://www.lemonades.in"
      $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."

      $scope.landing = ->
        $location.path("/")

      $scope.register = ->
        $location.path("/register")

      $scope.login = ->
        btn = $("#loginButton").button("loading")
        $http.post($rootScope.baseUrl + "/api/v1/user/login", $scope.user).success(
          (data)->
            btn.button("reset")
            if data.success
              session.store(data.user)
              $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
              if $location.search()["join"]!= undefined
                groupId = $location.search()["join"]
                $location.path("/group/"+groupId).search({"join":"true"})
                return
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

      $scope.loginWithGooglePlus = ->
        GooglePlus.login().then ((authResult) ->
          GooglePlus.getUser().then (user) ->
            gplusUserRequest = {
              email:user.email,
              name:user.name,
              gender:user.gender,
              profile_pic:user.picture,
              gplus_user_id:user.id,
              gplus_token:authResult.access_token,
              is_gplus:true
            }
            $http.post($rootScope.baseUrl + '/api/v1/user/gplus_login',gplusUserRequest)
            .success((data)->
              if data.success
                session.store(data.user)
                $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
                $location.path("/dashboard")
            )
            .error((data)->
              ngToast.create({
                className: 'danger',
                content: 'There was some error in logging in with Google Plus. Please try again',
              })
            )
            return
          return
          ),(err) ->
            ngToast.create({
              className: 'danger',
              content: 'There was some error in logging in with Google Plus. Please try again',
            })

      $scope.forgotPassword = ->
        $scope.fg_status = {}
        if $scope.object.email == undefined ||$scope.object.email == ""
          $scope.fg_status = {
            message: "Please provide a valid email address",
            success: false
          }
          return
        $http.post($rootScope.baseUrl + '/api/v1/user/forgot_password',$scope.object)
        .success((data)->
          if data.success
            $('#forgotPasswordModal').modal('hide')
            ngToast.create({
              className: 'success',
              content: data.message,
            })
            return
          ngToast.create({
            className: 'danger',
            content: data.message,
          })
        )
        .error((data)->
          ngToast.create({
            className: 'danger',
            content: 'There was some error while resetting the password, Please try again !',
          })
        )
  ])
