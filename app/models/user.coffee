class User extends Spine.Model
  @configure "User" ,  "Name" , "Username" , "Password" , "Access"
  @extend Spine.Model.Ajax.Methods

  @current = null

  convert_to_user: =>
    @Name= "Active Anonymous User"
    @Access = 2
    @save()
    
  @set_current: (user) ->
    @current = user
    User.trigger "current_change"

  @create_anonymous: ->
    User.create
      Name: "Anonymous User"
      Username: "anonymous" + Math.random() + "@frebbe.com"
      Password: ""
      Access: 3

  @fetch: ->
   params = 
     data: {tags: ""}
     processData: true

   @ajax().fetch(params)


module.exports = User
