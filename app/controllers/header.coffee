Spine = require('spine')
Slide    =  require('models/slide')
User     =  require('models/user')

class Header extends Spine.Controller
  className: 'header active'
  
  events:
    "click span" : "on_user_change"
  
  constructor: ->
    super
    @render()
    User.bind "current_change change" , @render

  render: =>
    @html require('/views/header')({user: User.current}) if User.current

  #This does not apply is just for testing
  on_user_change: (e) ->
    target = $(e.target)
    user = {Name: "John Admin" , Access: 3 , Username: "johnadmin@frebbe.com" , Access: 0} if target.hasClass "admin" 
    user = {Name: "John Super" , Access: 3 , Username: "johnsuper@frebbe.com" , Access: 1} if target.hasClass "super"
    user = {Name: "John Doe" , Access: 3 , Username: "johndoe@frebbe.com" , Access: 2} if target.hasClass "user"
    user = User.create user
    User.set_current user

module.exports = Header
