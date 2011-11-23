Spine = require('spine')
Media = require('models/media')

class Gallery extends Spine.Controller
  className: 'popup gallery'

  elements:
    ".list" : "list"  
    
  events:
    "click .type>span" : "on_type_click"
    "click .list>.item" : "on_item_click"

  constructor: ->
    super
    @render()
    Media.bind "refresh" , @render_media
    @on_type_click()

  render: =>
    @html require('views/popup.gallery')
    
  render_media: (items) =>
    @list.html require('views/popup.gallery.item')(items)
    @list.prepend require('views/popup.gallery.item.new')
    
  on_type_click: (e) =>
    type = $(e.target).attr "data-type" if e
    type ="image" if !e
    Media.fetch type
    @list.html require('views/popup.gallery.item.loading')()
  
  on_item_click: (e) ->
    target = $(e.target).parent()
    media_id =  target.attr "data-id"
    media = Media.find media_id
    response = {action: true , object: media , type: media.Type ,options: {}}
    Spine.trigger "popup_response"  , response

module.exports = Gallery
