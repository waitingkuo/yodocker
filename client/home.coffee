Template.registerHelper 'username', ->
  Meteor.user()?.username

Template.home.helpers
  username: -> Meteor.user()?.username
  repos: -> Repos.find()
  
AutoForm.hooks
  insertRepo:
    onSuccess: (op, result) ->
      Router.go 'editRepo', {_id: result}
