Spine = require('spine')
Slide    =  require('models/slide')
User     =  require('models/user')

class Panel extends Spine.Controller
  className: 'panel_wrapper'
  
  elements:
    ".panel" : "panel"
  
  constructor: ->
    super
    @html require('views/panel')

  set_height: (height) =>
    @panel.height height

module.exports = Panel
