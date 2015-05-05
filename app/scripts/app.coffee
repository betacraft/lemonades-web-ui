'use strict';

angular
  .module('lemonades', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'googleplus',
    'ezfb',
    'angulartics',
    'ngToast',
    'lemonades.config',
    'seo',
    'angulartics.google.analytics'])
  .run(['$rootScope','$location','$http','$cookieStore','config',($rootScope,$location,$http,$cookieStore,config)->
    $rootScope.baseUrl = config.baseUrl
    $rootScope.loading = false
    $rootScope.title = "Lemonades.in : Next Generation of Group Buying";
    $rootScope.image = ""
    $rootScope.user = {}
    $rootScope.url = "http://www.lemonades.in"
    $rootScope.description = "Select product -> Create Groups -> Get huge bulk discounts."
    $rootScope.getUser = ->
      req =
        method: "GET"
        url: $rootScope.baseUrl + "/api/v1/user"
        headers:
          'Session-Key': $cookieStore.get("lmnsskey")
      $http(req).success(
        (data)->
          if data.success
            $rootScope.user = data.user
            return
          $cookieStore.remove("lmnsskey")
      ).error(
        ()->
          $cookieStore.remove("lmnsskey")
      )

    $rootScope.hasError  = (obj)->
      return obj.$invalid && obj.$touched


    $rootScope.goToLogin = ->
      $location.path("/login")

  ])
  .factory('myHttpInterceptor', ['$q','$window','$rootScope','$location','$cookieStore',($q,$window, $rootScope,$location,$cookieStore) ->
    return{
    # optional method
    'request': (config) ->
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
        $cookieStore.remove("lmnsskey")
      return $q.reject(rejection)
    }
  ])
  .config(['ngToastProvider',(ngToastProvider)->
    ngToastProvider.configure({
      animation:"slide",
      horizontalPosition:"center",
      additionalClasses:"toastClass"
    })
  ])
  .config(['$httpProvider',($httpProvider)->
    $httpProvider.interceptors.push('myHttpInterceptor');
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
    $httpProvider.defaults.useXDomain = true;
  ])
  .config(['ezfbProvider','config',(ezfbProvider,config)->
    ezfbProvider.setInitParams({
      appId: config.fbAppId,
      version:'v2.3'
    })
  ])
  .config(['GooglePlusProvider', (GooglePlusProvider) ->
    GooglePlusProvider.init({
        clientId: '277507848931-4jccaqqqi3jllpam40n7j1jrq2kup01i.apps.googleusercontent.com',
        apiKey: 'AIzaSyA3F3vE_vglkKVeMq-U6mnSkg4h1vhQHPM'
      });
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
      .when '/user/:auth_key/reset_password',
        templateUrl: 'views/reset_password.html'
        controller: 'ResetPasswordCtrl'
      .when '/user/:auth_key/confirm_email',
        templateUrl: 'views/confirm_email.html'
        controller: 'ConfirmEmailCtrl'
      .otherwise
        redirectTo: '/'
#   $locationProvider.html5Mode({enabled:true,requireBase:true}).hashPrefix();
    $locationProvider.html5Mode({enabled:false,requireBase:true}).hashPrefix('!');
  ])
