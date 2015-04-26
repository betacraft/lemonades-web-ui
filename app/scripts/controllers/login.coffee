'use strict';

angular.module('lemonades')
.controller('LoginCtrl',
  ['$scope', '$cookieStore', '$http', '$rootScope', '$location', 'session', '$facebook', 'ngToast','GooglePlus',
    ($scope, $cookieStore, $http, $rootScope, $location, session, $facebook, ngToast,GooglePlus) ->
      $scope.user = {}
      $scope.fbUser = {}
      $scope.fbStatus = null

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
              $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
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

      $scope.loginWithFacebook = ->
        console.log("Logging in with facebook", $facebook.isConnected())
        if $facebook.isConnected() == null || $facebook.isConnected() == false
          ngToast.create({
            className: 'danger',
            content: 'There was some error in logging in with facebook !!\nRefresh Page and Try again',
          })
          return
        $scope.fbStatus = $facebook.isConnected()
        if $scope.fbStatus
          $facebook.api('/me').then (user) ->
            console.log(user)
            $scope.fbUser = user
            $facebook.api('/' + user.id + '/picture').then (data) ->
              console.log(data)
              fbUserReq = {
                email: user.email,
                name: user.first_name + " " + user.last_name,
                profile_pic: data.data.url,
                fb_user_id: user.id,
                fb_token: $facebook.getAuthResponse().accessToken,
                is_fb: true,
                gender: user.gender
              }
              console.log("Sending ", fbUserReq)
              $http.post($rootScope.baseUrl + '/api/v1/user/fb_login', fbUserReq)
              .success((data) ->
                console.log(data)
                if data.success
                  session.store(data.user)
                  $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
                  $location.path("/dashboard")
              )
              .error((data)->
                ngToast.create({
                  className: 'danger',
                  content: 'There was some error in logging in with facebook. Please try again',
                })
              )
            return
          return

      $scope.loginWithGooglePlus = ->
        GooglePlus.login().then ((authResult) ->
          console.log authResult
          GooglePlus.getUser().then (user) ->
            console.log user
            gplusUserRequest = {
              email:user.email,
              name:user.name,
              gender:user.gender,
              profile_pic:user.picture,
              gplus_user_id:user.id,
              gplus_token:authResult.access_token,
              is_gplus:true
            }
            console.log "Sending",gplusUserRequest
            $http.post($rootScope.baseUrl + '/api/v1/user/gplus_login',gplusUserRequest)
            .success((data)->
              if data.success
                session.store(data.user)
                $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
                $location.path("/dashboard")
            )
            .error((data)->
              console.log data
            )
            return
          return
          ),(err) ->
            console.log err
  ])
