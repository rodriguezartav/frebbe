Spine = require('spine')

Slides    = require('controllers/components/slides')
Panel    = require('controllers/components/panel')

class Pages extends Spine.Controller
  className: 'pages'
  
  constructor: ->
    super
    @slides = new Slides
    @panel = new Panel

    @append  @panel , @slides
    
    @active (id) ->
      @slides.show_slide id
        
  set_height: (height) ->
    @slides.set_height height
    @panel.set_height height

module.exports = Pages
