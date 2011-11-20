Spine  =  require('spine')

Slide  =  require('models/slide')
User  =  require('models/user')

class User_Hook extends Spine.Controller
  
  constructor: ->
    super
    User.bind "current_change" , @on_current_user_change

  on_current_user_change: =>
    Slide.trigger "reload"
    

module.exports = User_Hook


