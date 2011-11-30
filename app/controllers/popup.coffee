Spine = require('spine')
Gallery    = require('controllers/components/gallery')

class Popup extends Spine.Controller
  className: 'popup_canvas active'

  constructor: ->
    super
    Spine.bind "show_popup" , @on_show_popup
    Spine.bind "popup_response" , @on_popup_response

  on_show_popup: (type) =>
    @el.show()
    if type == "gallery"
      @current = new Gallery
      @html @current

  on_popup_response: =>
    @el.hide()
    @current?.release()

module.exports = Popup