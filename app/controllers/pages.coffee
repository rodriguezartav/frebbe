Spine = require('spine')

Slides    = require('controllers/components/slides')
Social    = require('controllers/components/social')

class Pages extends Spine.Controller
  className: 'pages'
  
  constructor: ->
    super
    @slides = new Slides
    @social = new Social

    @append  @slides
    
    @active (id) ->
      @slides.show_slide id
        
  set_height: (height) ->
    @slides.set_height height
    @social.set_height height

module.exports = Pages
