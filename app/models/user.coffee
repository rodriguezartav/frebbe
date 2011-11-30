class User extends Spine.Model
  @configure "User" ,  "Name" , "Username" , "Password" , "Access" , "Icon"
  @extend Spine.Model.Ajax.Methods

  @current = null

  convert_to_user: =>
    @Name= "User"
    @Access = 2
    @save()
    
  @find_or_fetch_owner: (owner) ->
    user = User.findByAttribute("Username" , owner)
    User.fetch owner if !user
    return user
    
  @set_current: (user) ->
    @current = user
    User.trigger "current_change"

  @create_anonymous: ->
    User.create
      Name: "a13 (anonymous)"
      Username: "anonymous" + Math.random() + "@frebbe.com"
      Password: ""
      Icon: "stock"
      Access: 3

  @fetch: (owner) ->
   params = 
     data: {owner: owner}
     processData: true

   @ajax().fetch(params)


module.exports = User
