Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'notFound'
    loadingTemplate: 'loading'
    yieldTemplates:
        header:
            to: 'header'
        footer:
            to: 'footer'
    before: ->
        $('meta[name^="description"]').remove()
