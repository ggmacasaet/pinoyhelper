class @RegisterController extends RouteController
    template: "register"
    before: ->
        if @params.step is "profile"
        else if @params.step is "profile" and Meteor.user()
            @yieldTemplates["register_profile"] =
                    to: 'register_content'
        else
            @yieldTemplates["register_login"] =
                    to: 'register_content'
    data: ->
        user = Meteor.user()
        self = @
        register_content: self.register_content
