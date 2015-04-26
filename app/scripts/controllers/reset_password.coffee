'use strict'

angular.module('lemonades')
  .controller 'ResetPasswordCtrl', ['$scope','$http','$rootScope','$routeParams','$location','ngToast',($scope,$http,$rootScope,$routeParams,$location,ngToast) ->
    $scope.user = {}
    $scope.status= {}
    authKey = $routeParams.auth_key
    $scope.resetPassword = () ->
      if $scope.user.password == undefined || $scope.user.password == "" || $scope.user.password != $scope.user.confirm_password || $scope.user.password.length < 8
        $scope.status = {
          success:false,
          message:"Please provide a valid password"
        }
        return
      $http.post($rootScope.baseUrl + '/api/v1/user/'+authKey+'/update_password',$scope.user)
      .success((data)->
        if data.success
          $location.path('/login')
          return
        ngToast.create({
          className: 'danger',
          content: data.message,
        })
      )
      .error((data)->
        ngToast.create({
          className: 'danger',
          content: data.message,
        })
      )
  ]

