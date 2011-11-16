require('lib/setup')

Spine = require('spine')
Pages    = require('controllers/pages')
Slide    = require('models/slide')
Mock = require('lib/mock')


class App extends Spine.Controller

  constructor: ->
    super
    new Mock() if @test
    @pages = new Pages
    @append @pages
    
module.exports = App
    