@Repos = new Meteor.Collection 'repos'

Repos.attachSchema new SimpleSchema

  dockerHubAccount:
    type: String
    autoValue: ->
      @value.toLowerCase()

  dockerHubRepo:
    type: String
    autoValue: ->
      @value.toLowerCase()

  userId:
    type: String
    autoValue: -> @userId

  username:
    type: String
    autoValue: ->
      Meteor.user().username
  

Repos.allow
  insert: (userId, doc) -> userId?
  update: (userId, doc) -> userId is doc.userId


  
