Meteor.methods

  login2: (userId) ->
    @setUserId userId

  login3: (userId) ->
    @setUserId userId
    if Meteor.isClient
      Router.go('home')

