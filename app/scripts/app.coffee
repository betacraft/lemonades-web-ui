'use strict';

angular
  .module('lemonades', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'angulartics',
    'angulartics.google.analytics'
  ])
  .run(($rootScope,$location,$http,$cookieStore)->
    $rootScope.baseUrl = "http://localhost:3000"
    $rootScope.loading = false;

    $rootScope.getUser = ->
      console.log("getting user")
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/user"
        headers:
          'Session-Key': $cookieStore.get("lmnsskey")
      $http(req).success(
        ()->

      ).error(
        ()->
      )

    $rootScope.goToLogin = ->
      $location.path("/login")

  )
  .factory('myHttpInterceptor', ($q, $window, $rootScope,$location,$cookieStore) ->
    return{
    # optional method
    'request': (config) ->
      console.log("requesting",config);
      $rootScope.loading = true if !config.ignoreLoadingFlag
      return config
    'requestError': (rejection) ->
      $rootScope.loading = false
      # do something on error
      return responseOrNewPromise if canRecover(rejection)
      return $q.reject(rejection)
    # optional method
    'response': (response) ->
      $rootScope.loading = false;
      # do something on success
      return response
    # optional method
    'responseError': (rejection) ->
      $rootScope.loading = false;
      status = rejection.status;
      if (status == 401)
        console.log($location.pathname)
        $cookieStore.remove("lmnsskey")
      return $q.reject(rejection)
    }
  )
  .config(($httpProvider)->
    $httpProvider.interceptors.push('myHttpInterceptor');
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
    $httpProvider.defaults.useXDomain = true;
  )
  .config(($routeProvider,$locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/register',
        templateUrl: 'views/register.html'
        controller: 'RegisterCtrl'
      .when '/dashboard',
        templateUrl: 'views/dashboard.html'
        controller: 'DashboardCtrl'
      .when '/register/success',
        templateUrl: 'views/register/success.html'
        controller: 'RegisterSuccessCtrl'
      .when '/group/:id',
        templateUrl: 'views/group.html'
        controller: 'GroupCtrl'
      .when '/my-groups',
        templateUrl: 'views/my-groups.html'
        controller: 'MyGroupsCtrl'
      .otherwise
        redirectTo: '/'
#   $locationProvider.html5Mode({enabled:true,requireBase:true}).hashPrefix();
    $locationProvider.html5Mode({enabled:false,requireBase:true}).hashPrefix();
  )
