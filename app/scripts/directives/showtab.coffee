'use strict'

angular.module('lemonades')
  .directive('showtab', ->
    { link: (scope, element, attrs) ->
      element.click (e) ->
        e.preventDefault()
        $(element).tab 'show'
        return
      return
    }
)
