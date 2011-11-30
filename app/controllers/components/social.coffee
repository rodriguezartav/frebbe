Spine    =  require('spine')
Slide    =  require('models/slide')
User    =  require('models/user')

class Social extends Spine.Controller
  className: 'social'

  @width= 40

  constructor: ->
    super
     
  render: (slide) =>
    owner = User.find_or_fetch_owner slide.Owner || false
    @html require('views/viewport.item.social')({slide: slide, owner: owner})
    User.bind( "refresh" , @on_owner_response ) if !owner
  
  on_owner_response: () =>
    User.unbind( "refresh" , @on_owner_response )
    @trigger "re_render"

module.exports = Social
