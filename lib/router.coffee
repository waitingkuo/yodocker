Router.configure
  waitOn: ->
    Meteor.subscribe 'repos'


if Meteor.isServer
  Router.route '/callback', ( ->

    req = @request
    res = @response

    username = req.query.username

    user = Meteor.users.findOne username: username
    if user?
      userId = user._id
    else
      userId = Accounts.createUser username: username

    HTTP.post 'https://api.justyo.co/yo/',
      data:
        username: username
        api_token: 'e52430b8-68cb-409d-92a1-6cc18dc3a153'
        link: Meteor.absoluteUrl 'login?u=' + userId

    res.end 'ok'

  ), {where: 'server', name: 'callback'}

  Router.route '/webhook/:dockerHubAccount/:dockerHubRepo', ( ->

    req = @request
    res = @response
    dockerHubAccount = @params.dockerHubAccount
    dockerHubRepo = @params.dockerHubRepo

    repo = Repos.findOne
      dockerHubAccount: dockerHubAccount
      dockerHubRepo: dockerHubRepo

    if repo?
      link = Meteor.absoluteUrl 'success/' + dockerHubAccount + '/' + dockerHubRepo
      HTTP.post 'https://api.justyo.co/yo/',
        data:
          username: repo.username
          api_token: 'e52430b8-68cb-409d-92a1-6cc18dc3a153'
          link: link

    res = @response
    res.end 'ok'


  ), {where: 'server', name: 'webhook'}

Router.onBeforeAction ( ->
  if not Meteor.userId()
    Router.go 'error'
    @render 'error'
  else
    @next()
), {only: ['home', 'editRepo', 'newRepo']}


Router.route '/error',
  name: 'error'
  template: 'error'

Router.route 'success/:dockerHubAccount/:dockerHubRepo',
  name: 'success'
  template: 'success'
  data: ->
    return {
      dockerHubAccount: @params.dockerHubAccount
      dockerHubRepo: @params.dockerHubRepo
    }

Router.route '/login',
  action: ->
    userId = @params.query.u
    Meteor.call 'login2', userId
    Router.go 'home'
    
Router.route '/home',
  name: 'home'
  template: 'home'

Router.route '/new-repo',
  name: 'newRepo'
  template: 'newRepo'

Router.route '/edit-repo/:_id',
  name: 'editRepo'
  template: 'editRepo'
  data: ->
    doc = Repos.findOne @params._id
