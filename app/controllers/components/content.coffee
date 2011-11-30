Spine    =  require('spine')
Slide    =  require('models/slide')
User    =  require('models/user')

class Content extends Spine.Controller
  className: 'content'

  elements:
     "textarea" : "textarea"
     ".media_wrapper" : "media"

  events:
    "click .editable" : "on_editable_click"
    "change .editable" : "on_editable_change"
    "blur .editable" : "on_editable_blur"
    "click .prompt>span"  :  "on_plus_click"

  constructor: ->
    super

  render: (slide) =>
    @el.width slide.Width
    renderObj = {slide: slide , editable: @editable}
    @html require('views/viewport.item.content')(renderObj)
    @render_media(slide.Media) if slide.Media
  
  render_media: (media) =>
    @media.html require('views/viewport.item.content.media.image')(media) if media?.Type == "image"

  on_plus_click: (e) =>
    Spine.trigger "show_popup" , "gallery"
    Spine.bind "popup_response" , @on_gallery_response

  on_gallery_response: (response) =>
    if response.action == true
      @trigger "change_media" , response.object
      @render_media(response.object)
    
  #triggers editing
  on_editable_click: (e) ->
    if @editable 
      target = $(e.target)
      parent = target.parent()
      parent.addClass "editing"
      parent.last().select()

  #triggers save
  on_editable_change: (e) ->
    if @editable
      target = $(e.target)
      parent = target.parent()
      type = parent.attr('data-field')
      value = target.val()
      parent.find(':first-child').html value
      @trigger "change" , {type: type , value: value }
    target.blur()

  #resets state when change or exit input/textarea
  on_editable_blur: (e) ->
    target = $(e.target)
    parent = target.parent()
    parent.removeClass "editing"

module.exports = Content
