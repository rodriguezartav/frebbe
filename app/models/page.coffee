class Page extends Spine.Model
  @configure "Page" ,  "Title" , "Owner" , "Access"
  @extend Spine.Model.Ajax.Methods


  @fetch: ->
   params = 
     data: {tags: ""}
     processData: true

   @ajax().fetch(params)


module.exports = Page
