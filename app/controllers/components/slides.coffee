Spine    =  require('spine')
Slide    =  require('models/slide')
User    =  require('models/user')
Social = require('controllers/components/social')
Menu = require('controllers/components/menu')
Content = require('controllers/components/content')


class Item extends Spine.Controller
  className: 'item heightable'

  parent_item = null
  child_item = null

  constructor: ->
    super
    
    @menu = new Menu
    @menu.bind "change" ,  @on_menu_change
    @menu.bind "click"   ,  @on_menu_click
    @menu.bind "delete"   ,  @on_menu_delete
    @menu.bind "create"   ,  @on_menu_create

    @content = new Content
    @content.bind "change" , @on_content_change
    @content.bind "change_media" , @on_media_change

    @social = new Social
    @social.bind "re_render" , @on_social_change

    @html require('views/viewport.item')

    Slide.bind "reload" , @render

    @release =>
      Slide.unbind "reload" , @render
      @content.release()
      @menu.release()
      @social.release()

  #fetches from model and sets binding
  fetch: ->
    Slide.bind "fetch_success" , @fetch_success
    Slide.fetch @name

  #resets binding and receives data from model ( formated as slide)
  #it also triggers the item_rendered event so that parent can adjust widths
  fetch_success: (slide) =>
    @html @social
    @append @content , @menu
    Slide.unbind "fetch_success" , @fetch_success
    @slide = slide
    @slide.set_parent @parent_item.slide if @parent_item and !@slide.Parent
    @set_access(slide)
    @render()
    @trigger "item_rendered"

  set_access: (slide) =>
    user = User.current
    
    #For public slides
    if slide.Access > 2 and user?.Username != slide.Owner
      @menu.editable = true
    
    #For owner slides
    else if user?.Username == slide.Owner
     @menu.editable = true
     @menu.configurable = true
     @content.editable = true

    #for admins and super user
    else if user?.Access <= slide.Access 
      @menu.editable = true
    
  render: =>
    if @slide
      @menu.render @slide
      @content.render @slide
      @social.render @slide

  on_menu_change: (option) =>
    current_user = User.current  
    @slide.rotate_width() if option == "width"
    @slide.rotate_access(current_user.Access) if option == "access"
    @render()
    @trigger "item_rendered" if option == "width"
    
  on_menu_click: (name) =>
    @trigger "create_new_item" , @ , name

  on_menu_delete: (name) =>
    @remove_link name

  on_menu_create: (name) =>
    Slide.bind "fetch_success" , @after_item_created
    @trigger "create_new_item" , @ , name

  #sets the link to the just created item
  #resets the binding
  after_item_created: (new_slide) =>
    Slide.unbind "fetch_success" , @on_new_created
    @slide.Links.push { id: new_slide.id , name: new_slide.Title }
    @slide.save()
    @render()

  on_content_change: (json) =>
    @slide[json.type] = json.value
    @slide.save()
    @parent_item.update_link(@slide.id , json.value) if json.type == "Title" and @parent_item

  update_link: (id,name) =>
    for link in @slide.Links
      link.name = name if link.id == id
    @render()

  remove_link: (id) =>
    count = 0
    index = 0
    for link in @slide.Links
      index = count if link.id == id
      count++
    @slide.Links = @slide.Links.splice index
    @slide.save()
    @render()
    Spine.trigger "go_to_item" , @

  on_media_change: (media) =>
    @slide.Media = media
    @slide.save()

  on_social_change: =>
    @social.render(@slide)

class Viewport extends Spine.Controller
  className: 'viewport '

  constructor: ->
    super
    @items = []
    @current_item = null
    Spine.bind "reset_view" , @remove_sections_before_last
    Spine.bind "go_to_item" , @go_to_item

  set_height: (height) ->
    @height = height
    for item in @items
      item.el.height height

  go_to_item: (item) =>
    #removes all items after clicked item
    index = @items.indexOf( item )
    @remove_sections_after index

  create_new_item: ( parent_item= null , name = null) =>
    #Create items , must recycle at some point
    #binding is done on instance
    item = new Item( name: name )
    item.el.height @height
    item.bind "create_new_item" , @create_new_item
    item.bind "item_rendered" , @adjust_width
    parent_item.child_item = item if parent_item
    item.parent_item = parent_item

    #removes all items after clicked item
    current_index = @items.indexOf( parent_item )
    if @items.length != current_index
      @remove_sections_after current_index

    @append item
    @items.push item

    #add width temporalily, while loading
    @el.width( @el.width() + 480 )

    #tells controller to load data
    item.fetch()

  #Adjusts the viewport size according to recorded size of each item
  adjust_width: =>
    new_width = 0
    for item in @items
      width = 0
      width = item.slide.Width + Menu.width + Social.width
      new_width += width
      last_width = item.el.width()
    canvas_width = @el.parent().width()
    final_width = canvas_width - last_width - 200
    new_width +=  final_width if final_width > 0
    
    @el.width new_width
    @adjust_scroll()

  adjust_scroll: =>
    @el.animate({ scrollLeft: "-=3000" }, "slow");

  remove_sections_after: (count) =>
    index =  @items.length - 1
    while index > count
      item = @items[index]
      item.release()
      @items.pop()
      index--

  remove_sections_before_last: =>
    @items.reverse()
    index =  @items.length - 1
    while index > 0
      item = @items[index]
      item.release()
      @items.pop()
      index--

class Slides extends Spine.Controller
  className: 'slides_canvas heightable'

  constructor: ->
    super
    @viewport = new Viewport
    @append @viewport
    Spine.bind "resize" , =>
      @viewport.adjust_width()

  show_slide: (id) ->
    @viewport.create_new_item null , id

  #sets height of view port and canvas element
  #items uses height of 100%
  set_height: (height) ->
    @el.height height
    @viewport.set_height height - 7
    
module.exports = Slides
