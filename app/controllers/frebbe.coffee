Spine = require('spine')

Browser    = require('controllers/components/browser')
#Social    = require('controllers/components/social')

class Frebbe extends Spine.Controller
  className: 'frebbe'
  
  constructor: ->
    super
    @browser = new Browser
 #   @social = new Social
  #  @append @social  ,  @browser

  set_height: (height) ->
    @browser.set_height height
   # @social.set_height height

module.exports = Frebbe
