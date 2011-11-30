Spine    =  require('spine')
Slide    =  require('models/slide')
User    =  require('models/user')

class Menu extends Spine.Controller
  className: 'menu'

  @width = 171

  elements:
    ".stats" : "stats"
    ".box_wrapper" : "wrapper"

  events:
     "click span.option" : "on_option_click"
     "click span.link" : "on_menu_link_click"
     "click span.del" : "on_menu_del_click"
     "click .stats" : "on_stats_click"
     "change input" : "on_input"

  constructor: ->
    super

  render: (slide) =>
    renderObj = {slide: slide , editable: @editable , configurable: @configurable}
    @html require('views/viewport.item.menu')(renderObj)
    @wrapper.prepend require('views/viewport.item.menu.stats')


  on_option_click: (e) =>
     target = $(e.target)
     current_user = User.current
     option = target.attr "data-option"
     @trigger "change" , option

   #click on a menu item
   on_menu_link_click: (e) =>
     target = $(e.target).parent()
     @trigger "click" , target.attr "data-id"

   #click on a menu item
   on_menu_del_click: (e) =>
     target = $(e.target).parent()
     @trigger "delete" , target.attr "data-id"

   #change to menu input, which creates a new item/slide
   #binds this item to fetch_success of new item
   on_input: (e) =>
     target = $(e.target)
     @trigger "create" , target.val()

  on_stats_click: (e) =>
    if @stats.hasClass "open"
      @stats.removeClass 'open' 
    else
      @stats.addClass 'open' 


module.exports = Menu
