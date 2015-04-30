'use strict';
angular.module('lemonades')
.controller('RegisterCtrl',
  ['$scope', '$cookieStore', '$http', '$rootScope', '$location', 'session', '$facebook', 'ngToast', 'GooglePlus',
    ($scope, $cookieStore, $http, $rootScope, $location, session, $facebook, ngToast, GooglePlus) ->
      $scope.user = {};
      $scope.landing = ->
        $location.path("/")
      $scope.login = ->
        $location.path("/login")
      $scope.register = ()->
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
                if data.success
                  session.store(data.user)
                  $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
                  $location.path("/dashboard")
              )
              .error((data)->
                ngToast.create({
                  className: 'danger',
                  content: 'There was some error in logging in with Facebook. Please try again',
                })
              )
            return
          return

      $scope.loginWithGooglePlus = ->
        GooglePlus.login().then ((authResult) ->
          console.log authResult
          GooglePlus.getUser().then (user) ->
            gplusUserRequest = {
              email: user.email,
              name: user.name,
              gender: user.gender,
              profile_pic: user.picture,
              gplus_user_id: user.id,
              gplus_token: authResult.access_token,
              is_gplus: true
            }
            $http.post($rootScope.baseUrl + '/api/v1/user/gplus_login', gplusUserRequest)
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
        ), (err) ->
          ngToast.create({
            className: 'danger',
            content: 'There was some error in logging in with Google Plus. Please try again',
          })

  ])
