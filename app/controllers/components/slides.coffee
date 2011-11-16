Spine    =  require('spine')
Slide    =  require('models/slide')

class Item extends Spine.Controller
  className: 'item heightable'

  events:
    "click span" : "on_menu_click"
    "change .menu>.box_wrapper>input." : "on_input"
    "click .editable" : "on_editable_click"
    "change .editable" : "on_editable_change"
    "blur .editable" : "on_editable_blur"

  constructor: ->
    super
    @html require('views/viewport.item.loading')()
    @parent_item = null
    @child_item = null
  
  #fetches from server and takes sets binding
  fetch: ->
    Slide.bind "fetch_success" , @fetch_success
    Slide.fetch @id , @name

  #resets binding nd receives data from server ( formated as model)
  #it also triggers the item_rendered event so that parent can adjust widths
  fetch_success: (slide) =>
    Slide.unbind "fetch_success" , @fetch_success
    @slide = slide
    @render()
    @trigger "item_rendered"

  render: () =>
    @html require('views/viewport.item')(@slide)

  #triggers editing
  on_editable_click: (e) ->
    target = $(e.target)
    parent = target.parent()
    parent.addClass "editing"
    parent.last().select()

  #triggers save
  on_editable_change: (e) ->
    target = $(e.target)
    parent = target.parent()
    type = parent.attr('data-field')
    value = target.val()
    @slide[type] = value
    @slide.save()
    parent.find(':first-child').html value
    @parent_item.update_link(@slide.id , value) if type == "Title" and @parent_item
    target.blur()

  #resets state when change or exit input/textarea
  on_editable_blur: (e) ->
    target = $(e.target)
    parent = target.parent()
    parent.removeClass "editing"

  #click on a menu item
  on_menu_click: (e) =>
    target = $(e.target)
    @trigger "go_to_item" , @ , target.attr "data-id"

  #change to menu input, which creates a new item/slide
  #binds this item to fetch_success of new item
  on_input: (e) =>
    target = $(e.target)
    Slide.bind "fetch_success" , @on_new_created
    @trigger "go_to_item" , @ , null , target.val() 
  
  #sets the link to the just created item
  #resets the binding
  on_new_created: (new_slide) =>
    Slide.unbind "fetch_success" , @on_new_created
    @slide.Links.push { id: new_slide.id , name: new_slide.Title }
    @slide.save()
    @render()

  update_link: (id,name) =>
    for link in @slide.Links
      link.name = name if link.id == id
    @render()

class Viewport extends Spine.Controller
  className: 'viewport '

  constructor: ->
    super
    @items = []
    @current_item = null
    @go_to_item(null , "any_id" , "Hola Pongame un Titulo")
    
  set_height: (height) ->
    @height = height
    for item in @items
      item.el.height height

  go_to_item: ( parent_item= null , id = null , name = null) =>
    
    #removes all items after clicked item
    current_index = @items.indexOf( parent_item )
    if @items.length != current_index
      @remove_sections_after current_index

    #Create items , must recycle at some point
    #binding is done on instance
    item = new Item( id: id , name: name)
    item.el.height @height
    item.bind "go_to_item" , @go_to_item
    item.bind "item_rendered" , @adjust_width
    
    #sets references for future use
    parent_item.child_item = item if parent_item
    item.parent_item = parent_item

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
      width = item.slide.Width + 261
      new_width += width
    @el.width new_width

  remove_sections_after: (count) =>
    index =  @items.length - 1
    while index > count
      item = @items[index]
      item.el.detach()
      @items.pop()
      index--

class Slides extends Spine.Controller
  className: 'slides_canvas heightable'

  constructor: ->
    super
    @viewport = new Viewport
    @append @viewport
    
  #sets height of view port and canvas element
  #items uses height of 100%
  set_height: (height) ->
    @el.height height
    @viewport.set_height height
    
module.exports = Slides
