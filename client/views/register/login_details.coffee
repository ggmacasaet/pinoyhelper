Template.register_login.events
    'click .btn-login-with-fb': (e) ->
        e.preventDefault()
        Session.set("signupWithFacebook", true)
        Meteor.loginWithFacebook
                requestPermissions: [
                    "publish_actions",
                    "email",
                    "user_birthday",
                    "user_friends"
                ]
            , (err) ->
                if err
                    $(".err-message").html(err.reason).removeClass "hidden"
                else
                    if Meteor.user()?
                        if Meteor.user().services?
                            if Meteor.user().services.password?
                                Session.set("signupWithFacebook", false)	
                    if Meteor.user().profile.newuser
                        #Meteor.call "sendVerificationEmail", Meteor.user().username
                        Router.go '/register/profile'
                    else
                        Router.go '/dashboard'

Template.register_login.rendered = ->
    Session.set("signupWithFacebook", false)
    errMsg = $('.err-message')

    Regulate.register_login.onSubmit (err, data) ->
        if not err
            name = $('#register_firstname').val() + " " + $('#register_lastname').val()
            username = $('#register_firstname').val().toLowerCase() + $('#register_lastname').val().toLowerCase()	
            Meteor.call "getUsername", username, (err, result) ->
                languageLocation = Session.get "locationLanguageDetail"
                options =
                    username: result
                    password: $('#register_password').val()
                    email: $('#register_email').val()
                    profile:
                        firstName: $('#register_firstname').val()
                        lastName: $('#register_lastname').val()
                        name: name
                        newuser: true
                        skills: []
                        interests: []
                        gallery:
                            default: []
                        language: []
                        location: {}
                        employer: {}
                email = $('#register_email').val()
                Accounts.createUser options, (err) ->
                    if not err
                        ###
                        Meteor.call "sendVerificationEmail", email, (err) ->
                            unless err?
                                Session.set 'accounts-status', 'email-verification-sent'
                        ###
                        Router.go("/register/profile")
                    else
                        errMsg.text(err.reason).removeClass "hidden"
        else
            errMsg.text(err.register_password).removeClass "hidden"
            errMsg.text(err.register_email).removeClass "hidden"
            errMsg.text(err.register_lastname).removeClass "hidden"
            errMsg.text(err.register_firstname).removeClass "hidden"
