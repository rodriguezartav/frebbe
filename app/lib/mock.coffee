class Mock
  constructor: ->

  $.mockjax 
    url: '/users',
    type: 'GET',
    responseTime: 750,
    dataType: "JSON",
    response: (settings) ->
      owner = settings.data.owner
      @responseText =  JSON.stringify({Name: "name" , Username: owner , Icon: "any"})

  $.mockjax 
    url: '/medias',
    type: 'GET',
    responseTime: 750,
    dataType: "JSON",
    response: (settings) ->  
      type = settings.data.type
      medias = []
      
      medias.push {id: "media_1" , Title: type + "1" , Type: type, Content: "" }
      medias.push {id: "media_2" , Title: type + "2" , Type: type, Content: "" }
      medias.push {id: "media_3" , Title: type + "3" , Type: type, Content: "" }
      medias.push {id: "media_4" , Title: type + "4" , Type: type, Content: "" }
      medias.push {id: "media_5" , Title: type + "5" , Type: type, Content: "" }
      medias.push {id: "media_6" , Title: type + "6" , Type: type, Content: "" }
      @responseText =  JSON.stringify(medias)


    $.mockjax 
      url: '/slides',
      type: 'GET',
      responseTime: 750,
      dataType: "JSON",
      response: (settings) ->  
        id = settings.data.id
        name = settings.data.name
        owner = settings.data.owner
        slide1 = {id: id , Owner: owner ,Socials: [1,2,3]  , Created: true , Access: 2 , Title: name, Media: "#" , Width: 320 , Body: "The Social Network of Knowledge that helps you share your experiences." , Links: [] }
        @responseText =  JSON.stringify(slide1)

module?.exports = Mock