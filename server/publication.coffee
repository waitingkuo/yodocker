Meteor.publish 'repos', ->
  Repos.find userId: @userId

