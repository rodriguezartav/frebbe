require('lib/setup')
Manager = require('spine/lib/manager')

Spine = require('spine')
Frebbe    = require('controllers/frebbe')
Pages    = require('controllers/pages')
Header    = require('controllers/header')
Info    = require('controllers/info')


Slide    = require('models/slide')
User    = require('models/user')
Mock = require('lib/mock')

Slide_Hook    = require('hooks/slide_hook')
User_Hook    = require('hooks/user_hook')


class App extends Spine.Controller

  constructor: ->
    super
    new Mock() if @test
  
    User.set_current @user or User.create_anonymous()

    @header = new Header
    @info = new Info
    @pages = new Pages
    @frebbe = new Frebbe
  
    @manager = new Manager(@frebbe, @pages)
    @append @header , @info , @frebbe , @pages
    
    @routes
      '/browse': (params) -> 
        @frebbe.active(params)
      
      '/page/:name': (params) ->
        @pages.active(params.name)

    $(window).resize =>
      @on_resize()

    @on_resize()

    @navigate '/page/' + @start.id

    @register_hooks()

  register_hooks: =>
    @slide_hook = new Slide_Hook
    @user_hook = new User_Hook

  on_resize: =>    
    height = $(window).height()
    height -= 60
    @pages.set_height height
    @frebbe.set_height height


module.exports = App
    