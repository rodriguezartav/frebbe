Spine  =  require('spine')

Slide  =  require('models/slide')
User  =  require('models/user')

class Slide_Hook extends Spine.Controller
  
  constructor: ->
    super
    Slide.bind "create" , @on_slide_created
    Slide.bind "parent_changed" , @on_slide_parent_changed

  on_slide_created: (slide) =>
    user = User.current
    user.convert_to_user() if user.Access == 3
    
  on_slide_parent_changed: (slide) ->
    user = User.current
    Spine.trigger "prompt_login" if slide.Parent.Access == 3
    Spine.trigger "reset_view" if slide.Parent.Access == 3

    

module.exports = Slide_Hook
