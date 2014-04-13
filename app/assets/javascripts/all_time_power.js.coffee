$(document).ready -> 

  turn_into_array = (data_string) ->
    i = 0
    while i < data_string.length
      data_string[i] = parseFloat(data_string[i], 10)
      i++
      


  lifetime_unix_time = $("#power_all_time").data("lifetime-time") 
  if jQuery.type($("#power_all_time").data("all-time-data")) is "string"
    lifetime_data = $("#power_all_time").data("all-time-data").split(" ")
    turn_into_array(lifetime_data)
  else
    lifetime_data = $("#power_all_time").data("all-time-data")
 

  new Highcharts.Chart(
    chart:
      borderRadius: 0
      # width: $(".bottom-row").width()
      height: ($(window).height() * (1 / 2))
      # height: $(".bottom-row").height()
      renderTo: "power_all_time"
      backgroundColor: "#1E1E20"
      plotBackgroundColor: null
      type: "areaspline"
      style:
        color: "#990000"
        fontSize: "2em"
        title:
          style:
            color: "#cc0000"
            fontWeight: "bold"

    legend:
      enabled: false

    xAxis:
      type: "datetime"
      tickColor: "#dac092"
      labels:
        style:
          color: "#cc0000"

    title:
      text: "Energy Production Per Day"
      style:
        color: "#cc0000"
        fontWeight: "bold"
        fontSize: "25px"
        fontFamily: "'orbitron-light', sans-serif"

    yAxis:
      title:
        text: "Watt-Hours"
        lineColor: "#dac092"
        style:
          color: "#cc0000"

      labels:
        style:
          color: "#cc0000"

    plotOptions:
      series:
        fillColor:
          linearGradient: [0, 0, 0, 300]
          stops: [[0, "#00FF64"], [1, "rgba(0, 20, 10, 0.7)"]]

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
      name: "Watts Produced"
      pointInterval: 86400000
      pointStart: lifetime_unix_time 
      data: lifetime_data
    ]
  )