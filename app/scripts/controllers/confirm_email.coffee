'use strict'

angular.module('lemonades')
  .controller 'ConfirmEmailCtrl', ['$scope','$http','$rootScope','$routeParams','$location','ngToast',($scope,$http,$rootScope,$routeParams,$location,ngToast) ->
    authKey = $routeParams.auth_key
    $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
    $rootScope.image = ""
    $rootScope.url = "http://www.lemonades.in"
    $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."
    $scope.validate = ()->
      $http.post($rootScope.baseUrl + '/api/v1/user/'+authKey+'/confirm_email',null)
      .success((data)->
        if data.success
          ngToast.create({
            className: 'success',
            content: data.message,
          })
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
