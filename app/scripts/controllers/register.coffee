'use strict';
angular.module('lemonades')
.controller('RegisterCtrl',
  ['$scope', '$cookieStore', '$http', '$rootScope', '$location', 'session', 'ngToast', 'GooglePlus',
    ($scope, $cookieStore, $http, $rootScope, $location, session, ngToast, GooglePlus) ->
      $scope.user = {}
      $scope.captchaResponse = ""
      $scope.captchaInvalid = false

      $scope.init = ->
        $rootScope.path = 6

      $scope.isCaptchaValid = ()->
        console.log "calling is captcha valid"
        return $scope.captchaResponse != ""

      $scope.landing = ->
        $location.path("/")

      $scope.login = ->
        $location.path("/login")

      $scope.register = ()->
        if !$scope.isCaptchaValid()
          $scope.captchaInvalid = true
          return
        $scope.captchaInvalid = false
        btn = $("#signUpButton").button("loading")
        console.log("registering")
        $scope.user["captcha"] = $scope.captchaResponse
        console.log "Sending ",$scope.user
        $http.post($rootScope.baseUrl + "/api/v1/user", $scope.user).success(
          (data)->
            btn.button("reset")
            $scope.status = {}
            if data.success
              session.store(data.user)
              ngToast.create({
                className: 'info',
                content: 'We have sent you a confirmation email on provided email address. Please click on the link in that email to validate the same.',
                timeout:20000,
                dismissOnTimeout:true,
                dismissButton:true
              })
              $cookieStore.put("lmnsskey", data.user.session_key, {expires: 1, path: "/"})
              $rootScope.sessionKey = data.user.session_key
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
