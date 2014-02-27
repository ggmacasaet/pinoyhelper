Template.register_profile.events
    "submit form.register-form": (e) ->
        e.preventDefault()
        self = $(e.target)
        errMsg = self.parent().find(".err-message")
        errMsg.addClass("hidden")
        summary = $("[id='body']").val()
        interests = self.find("#select-interests").select2('val')
        completeness = Meteor.user().profile.completeness
        #add completeness for birthday
        completeness+=10
        birthday = new Date(self.find("[id='birthday']").val())
        #add completeness for gender
        gender = self.find("[id='gender']").val()
        completeness+=10

        unless summary
            errMsg.text("Please fill-out your description").removeClass("hidden")
        else
            #add the description percentage
            completeness+=20

            #Check if there is an input for the interests
            if interests.length > 0
                completeness+=30

            Meteor.users.update
                _id: Meteor.userId()
            ,
                $set:
                    'profile.gender': gender
                    'profile.body': summary
                    'profile.summary': summary
                    'profile.interests': interests
                    'profile.birthday': birthday
                    'profile.newuser': false
                    'profile.completeness': completeness
            Router.go "/language-partners"

    "keyup textarea[name='profile.body']": (e,template) ->
        # keep track of the number of characters in the profile body text area
        # update hint message below the box

        characters = $(e.target).val().length
        charactersLeft = Meteor.settings.public.profile.body.maxCharacters - characters
        $(e.target).next(".help-block").html(charactersLeft + " characters left")

Template.register_profile.rendered = ->
    $('#birthday').datepicker
        startView: 2
        autoclose: true

Template.register_profile.helpers
    isMale: ->
        if Meteor.user().profile.gender is "Male"
            true
        else
            false
            
    isFemale: ->
        if Meteor.user().profile.gender is "Female"
            true
        else
            false
