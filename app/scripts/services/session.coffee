'use strict'

angular.module('lemonades')
  .factory 'session', ->
    user = null
    # Public API here
    {
      store: (user)->
        this.user = user
      get: ->
        return user
    }
