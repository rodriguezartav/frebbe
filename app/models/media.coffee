class Media extends Spine.Model
  @configure "Media" ,  "Title" , "Type" , "Content"
  @extend Spine.Model.Ajax.Methods

  @fetch: (type) ->
   params = 
     data: {type: type}
     processData: true

   @ajax().fetch(params)


module.exports = Media
