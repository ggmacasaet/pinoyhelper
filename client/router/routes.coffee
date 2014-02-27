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
    #Routers for registration
    ###
    @route 'register',
        controller: RegisterController
        path: '/register'
        layoutTemplate: 'layout_clean'

    @route 'register-profile',
        controller: RegisterController
        path: '/register/:step'
        layoutTemplate: 'layout_clean'

    ###
    #Routes for helpers
    ###
    @route 'helpers-listing',
        path: '/helpers'
