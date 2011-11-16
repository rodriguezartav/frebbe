class Slide extends Spine.Model
  @configure "Slide" ,  "Title" , "Body" , "Width" , "Media" , "Links" , "Tags" , "Home"
  @extend Spine.Model.Ajax.Methods

  save: ->
    super
    #@ajax().update()

  @create_template: (title) ->
    Slide.create 
      Title: title
      Media: "#" 
      Width: 320
      Body: "Type something"
      Links: []

  @fetch: (id, name) ->
    slide = Slide.exists(id)
    if slide and id != null
      Slide.trigger "fetch_success" , slide
    else
      @do_ajax id , name
      
  @do_ajax: (id , name) ->
    $.ajax
      url        :  '/slides'
      type       :  "GET"
      dataType   :  'JSON'
      data       :  {id: id , name: name}
      success    :  @on_fetch_success
      error      :  @on_fetch_error

  @on_fetch_success: (results) =>
    slide = Slide.create results
    Slide.trigger "fetch_success" , slide
  
  @on_fetch_error: ->
    console.log arguments

module.exports = Slide
