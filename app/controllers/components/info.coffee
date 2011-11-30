Spine = require('spine')
Slide    =  require('models/slide')
User     =  require('models/user')

class Info extends Spine.Controller
  className: 'info'
  
  elements:
    'p' : "text"
  
  events:
    "click span" : "on_user_change"

  constructor: ->
    super
    Spine.bind "prompt_login" , @prompt_login

  prompt_login: =>
    @el.addClass 'active'
    @html require ('views/info/prompt_login_anonymous')
    @auto_hide()

  auto_hide: (time= 5000) ->
    setTimeout(@hide, time);
    
  hide: =>
    @el.removeClass "active"

module.exports = Info
