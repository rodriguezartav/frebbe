class Mock
  constructor: ->
  
    $.mockjax 
      url: '/slides',
      type: 'GET',
      responseTime: 750,
      dataType: "JSON",
      response: (settings) ->  
        id = settings.data.id
        name = settings.data.name
        owner = settings.data.owner
        slide1 = {id: id , Owner: owner , Created: true , Access: 2 , Title: name, Media: "#" , Width: 320 , Body: "The Social Network of Knowledge that helps you share your experiences." , Links: [] }
        @responseText =  JSON.stringify(slide1)

module?.exports = Mock