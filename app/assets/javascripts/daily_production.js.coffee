$(document).ready ->

  # cookie ----------------------------------------------------------------------
  $.cookie('last_loaded', new Date())
  
  cookie_time = new Date($.cookie('last_loaded')).getDay()


  # set data and time vars for chart --------------------------------------------
  daily_data = $("#daily_production").data("daily-data").split(" ")
  i = 0
  while i < daily_data.length
    daily_data[i] = parseInt(daily_data[i], 10)
    i++
  daily_time = $("#daily_production").data("daily-time")

  # draw chart -------------------------------------------------------------------
  daily_production = new Highcharts.Chart(
    chart:
      height: ($(window).height() * (1 / 2))
      borderRadius: 0
      renderTo: "daily_production"
      type: "areaspline"
      backgroundColor: "#fff"
      plotBackgroundColor: null
      animation:
        easing: "linear"
        duration: 3000
      events:
        load: ->
          setInterval (->
            $.get("/requests/current_watts.json").success (response) ->
              # data starts as a string, set it first to turn it into an array ------------
              if jQuery.type($("#daily_production").data("daily-data")) is "string"
                $("#daily_production").data "daily-data", response
                console.log("data was a string")
              else
                if response.length > $("#daily_production").data("daily-data").length
                  $("#daily_production").data "daily-data", response
                  daily_production.series[0].setData $("#daily_production").data("daily-data")
                  console.log "chart redrawn"
                else
                  console.log "no new data, array length: " + $("#daily_production").data("daily-data").length
                while cookie_time != (new Date().getDay()) 
                  $.removeCookie('last_loaded')
                  window.refresh()
                  console.log('window reloaded')
          ), 500000
      title:
        text: "Energy Produced today, by the Hour"
        style:
          color: "#cc0000"
          fontWeight: "bold"
          fontSize: "25px"
          fontFamily: "'orbitron-light', sans-serif"
      legend:
        enabled: false

    xAxis:
      type: "datetime"
      tickColor: "#dac092"
      labels:
        style:
          color: "#cc0000"

    yAxis:
      title:
        text: "Watt-Hours"
        style:
          color: "#cc0000"

      labels:
        style:
          color: "#cc0000"

    plotOptions:
      series:
        fillColor:
          linearGradient: [ 0, 0, 0, 300 ]
          stops: [ [ 0, "#00FF64" ], [ 1, "rgba(0, 20, 10, 0.7)" ] ]
        shadow: true
        offsetX: "3px"
        offsetY: "3px"
        opacity: "0.6"
        lineColor: "#00FF64"
        marker:
          enabled: false
    navigation:
      buttonOptions:
        enabled: false
    series: [
      name: "Today's Production"
      pointInterval: 300000
      pointStart: daily_time
      data: daily_data
      animation:
        easing: "linear"
        duration: "3000"
     ]
  )

