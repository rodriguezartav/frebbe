Spine = require('spine')

Slides    = require('controllers/components/slides')
Social    = require('controllers/components/social')

class Pages extends Spine.Controller
  className: 'pages'
  
  constructor: ->
    super
    @slides = new Slides
    @social = new Social

    @append @social , @slides
        
    $(window).resize =>
      @on_resize()
    
    @on_resize()
      
  on_resize: =>    
    height = $(window).height()
    height -= 60
    @slides.set_height height  

module.exports = Pages
