Meteor.startup () ->
  #Facebook signup/login configuration
  ###
  Accounts.loginServiceConfiguration.remove
    service: "facebook"
  Accounts.loginServiceConfiguration.insert
    service: "facebook"
    appId: Meteor.settings.private.facebook.applicationId
    secret: Meteor.settings.private.facebook.applicationSecret
  ###
  Accounts.onCreateUser (options, user) ->
    # add profile
    user.roles = []
    user.profile = {}
    if options.profile?
        user.profile = options.profile

    user.profile.newuser = false
    user.profile.completeness = 0

    #check if user registered via an oath service
    if user.services?
        service = _.keys(user.services)[0]

        #check if any existing account already has the email associated with the service
        email = user.services[service].email
        if email?
            oldUser = Meteor.users.findOne({"emails.address": email})

            #make sure the old account has the required services object
            if oldUser?
                #check if existing user's email is verified
                isVerified = _.first(Meteor.users.findOne({"emails.address": email}).emails).verified
                if isVerified
                  oldUser.services ?= {}
                  if service == "facebook"
                      #merge the new service key into the old user, delete old user from the database, then return it again to create it again directly
                      oldUser.services[service] = user.services[service]
                      Meteor.users.remove(oldUser._id)
                      user = oldUser

                      #Get facebook profile picture and upload in filepicker.io
                      inkblob =
                        url: "https://graph.facebook.com/" + user.services.facebook.username + "/picture?type=large"
                        isWriteable: false

                      img_data = Meteor.http.post("https://www.filepicker.io/api/store/S3?key=A1YiU6vkSq5Dzm0wm1wOQz",
                          params: inkblob
                      )

                      #Save image link from filepicker.io to user collection
                      user.profile.photo = img_data.data
                      user
                else
                    throw new Meteor.Error(403, "You need to verify your account first before you can log in with Facebook.")
            else
                if service == "facebook"
                  if user.services[service].email?
                    user.emails = [
                        address: user.services[service].email,
                        verified: true
                    ]
                  else
                    throw new Meteor.Error(500, "#{service} account has no email attached")

                  #Assign user information to the user collection for Facebook
                  username = user.services.facebook.first_name.toLowerCase() + user.services.facebook.last_name.toLowerCase()
                  user.profile.firstName = user.services.facebook.first_name
                  user.profile.lastName = user.services.facebook.last_name
                  gender = user.services.facebook.gender
                  user.profile.gender = gender.charAt(0).toUpperCase() + gender.slice(1)
                  user.profile.birthday = user.services.facebook.birthday
                  user.profile.newuser = true

                  Meteor.call "getUsername", username, (err, result) ->
                    user.username = result

                  #Get facebook profile picture and upload in filepicker.io
                  inkblob =
                    url: "https://graph.facebook.com/" + user.services.facebook.username + "/picture?type=large"
                    isWriteable: false

                  img_data = Meteor.http.post("https://www.filepicker.io/api/store/S3?key=A1YiU6vkSq5Dzm0wm1wOQz",
                      params: inkblob
                  )

                  #Save image link from filepicker.io to user collection
                  user.profile.photo = img_data.data
                  user.profile.completeness = 30

    user.roles.push "Helper"
    user.profile.gallery =
        default: []
    user.profile.language = []
    user.profile.newuser = true
    user.profile.interests = []
    user
