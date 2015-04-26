'use strict';

angular
  .module('lemonades', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'googleplus',
    'ngFacebook',
    'angulartics',
    'ngToast',
    'angulartics.google.analytics'])
  .run(['$rootScope','$location','$http','$cookieStore',($rootScope,$location,$http,$cookieStore)->
    $rootScope.baseUrl = "http://localhost:3000"
    $rootScope.loading = false;
    $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
    $rootScope.image = ""
    $rootScope.url = "http://www.lemonades.in"
    $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."
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

  ])
  .factory('myHttpInterceptor', ['$q','$window','$rootScope','$location','$cookieStore',($q,$window, $rootScope,$location,$cookieStore) ->
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
  ])
  .config(['ngToastProvider',(ngToastProvider)->
    ngToastProvider.configure({
      animation:"slide"
    })
  ])
  .config(['$httpProvider',($httpProvider)->
    $httpProvider.interceptors.push('myHttpInterceptor');
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
    $httpProvider.defaults.useXDomain = true;
  ])
  .config(($facebookProvider )->
    $facebookProvider.setAppId('1614694728745231').setPermissions(['email']);
  )
  .config(['GooglePlusProvider', (GooglePlusProvider) ->
    GooglePlusProvider.init({
        clientId: '277507848931-4jccaqqqi3jllpam40n7j1jrq2kup01i.apps.googleusercontent.com',
        apiKey: 'AIzaSyA3F3vE_vglkKVeMq-U6mnSkg4h1vhQHPM'
      });
  ])
  .run(['$rootScope', '$window', ($rootScope, $window) ->
    ((d, s, id) ->
      fjs = d.getElementsByTagName(s)[0];
      return if (d.getElementById(id))
      js = d.createElement(s);
      js.id = id;
      js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=1614694728745231&version=v2.3";
      fjs.parentNode.insertBefore(js, fjs);
      ) document, 'script', 'facebook-jssdk'
    $rootScope.$on 'fb.load', ->
      console.log("fb loaded")
      $window.dispatchEvent new Event('fb.load')
      return
  ])
  .config(['$routeProvider','$locationProvider',($routeProvider,$locationProvider) ->
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
  ])
