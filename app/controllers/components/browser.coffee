Spine    =  require('spine')
Page    =  require('models/page')
User    =  require('models/user')


class Browser extends Spine.Controller
  className: 'browser_canvas'

  elements:
    ".list" : "list"

  constructor: ->
    super
    @html require('views/browser')()
    
    @active ->
      Page.fetch()
      Page.bind "refresh" , @render
  
  render: =>
    items = Page.all()
    @list.html require('views/browser.item')(items)
    @list.prepend require('views/browser.item.new')(items) if User.current?.super_user
    
  set_height: (height) ->
    @el.height height
    
module.exports = Browser
