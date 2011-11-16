class Mock
  constructor: ->
  
    $.mockjax 
      url: '/slide/*',
      type: 'PUT',
      responseTime: 750,
      dataType: "JSON",
      responseText: "{}"
  
    $.mockjax 
      url: '/slides',
      type: 'GET',
      responseTime: 750,
      dataType: "JSON",
      response: (settings) ->  
        id = settings.data.id
        name = settings.data.name
        slide1 = {id: Math.random() + "NEW" , Title: name, Media: "#" , Width: 320 , Body: "Esto es una muestra, puede cambiar el titulo, este texto y agregar categorias en la seccion del menu. Para agregar a la seccion del menu escriba el nombre de la categoria y listo!" , Links: [] }
        @responseText =  JSON.stringify(slide1)

module?.exports = Mock