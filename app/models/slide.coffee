#TODO: REMOVE AFTER API IN PLACE
User = require('models/user')


class Slide extends Spine.Model
  @configure "Slide" ,  "Title" , "Body" , "Width" , "Media" , "Links" , "Tags" , "Socials" ,"Owner", "Access" , "Created" , "Parent"
  @extend Spine.Model.Ajax.Methods

  save: ->
    super
    #@ajax().update()

  set_parent: (parent) =>
    @Parent = parent
    @trigger "parent_changed"

  rotate_width: ->
    @Width += 260
    @Width = 320 if @Width > 920
    @save()

  rotate_access: (min_access = 0) ->
   @Access += 1
   @Access = min_access if @Access > 3
   @save()

  Access_Name: ->
    name = @Access
    name = "Public" if @Access == 3
    name = "Private" if @Access == 2
    name = "Super" if @Access == 1
    name = "Admin" if @Access == 0
    return name
    

  @generate_slug: (title) -> 
    temp_slug = title.toLowerCase()
    temp_slug = temp_slug.replace(/[^a-z0-9]+/g, '-')
    temp_slug = temp_slug.replace(/^-|-$/g, '')
    temp_slug

  @fetch: (name ) ->
    #ONLY FOR MOCK, IN PRODUCTIN USES COOKIE
    owner =  User.current.Username
    id = @generate_slug name
    slide = Slide.exists(id)
    if slide and id != null
      Slide.trigger "fetch_success" , slide
    else
      @do_ajax id , name , owner
      
  @do_ajax: (id , name , owner) ->
    $.ajax
      url        :  '/slides'
      type       :  "GET"
      dataType   :  'JSON'
      data       :  {id: id , name: name , owner: owner}
      success    :  @on_fetch_success
      error      :  @on_fetch_error

  @on_fetch_success: (results) =>
    slide = Slide.create results
    Slide.trigger "slide_created" if slide.Created
    Slide.trigger "fetch_success" , slide
  
  @on_fetch_error: ->
    console.log arguments

module.exports = Slide
