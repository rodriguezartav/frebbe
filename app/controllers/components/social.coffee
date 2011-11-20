Spine = require('spine')

class Social extends Spine.Controller
  className: 'social'

  constructor: ->
    super
    @render()

  render: =>
    @html '<h1>Social</h1>'

  set_height: (height) ->
    @el.height height

module.exports = Social
