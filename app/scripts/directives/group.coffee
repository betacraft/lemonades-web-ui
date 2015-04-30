'use strict'

angular.module('lemonades')
  .directive('group', ->
    templateUrl: 'views/directives/group.html'
    restrict: 'E'
    controller: ['$scope','$location',($scope,$location)->
      $scope.goToGroup = (groupId)->
         $location.path("/group/" + groupId)
    ]
    link: (scope, element, attrs) ->
  )
