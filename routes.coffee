Router.map ->

    @route 'home',
        path: '/'
        template: 'home'
        layoutTemplate: 'layout_full'

    @route 'dashboard',
        path: '/dashboard'
    ###
    @route 'notFound',
        path: '*'
        where: 'server'
        action: ->
          @response.statusCode = 404
          @response.end Handlebars.templates['404']()
    ###

    ###
    #Routes for helpers
    ###
    @route 'helpers-listing',
        path: '/helpers'
