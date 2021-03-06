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
      backgroundColor: "#ffffff"
      plotBackgroundColor: null
      type: "areaspline"
      style:
        color: "#990000"
        fontSize: "2em"
        fontFamily: "'opensans', sans-serif"                    

    legend:
      enabled: false

    xAxis:
      type: "datetime"
      tickColor: "#dac092"
      labels:
        style:
          color: "#DC3522"

    title:
      text: "All-time Production"
      style:
        color: "#DC3522"
        fontSize: "25px"


    yAxis:
      title:
        text: "Watt-Hours"
        lineColor: "#dac092"
        style:
          color: "#DC3522"

      labels:
        style:
          color: "#DC3522"

    plotOptions:
      series:
        shadow: true
        offsetX: "3px"
        offsetY: "3px"
        opacity: "0.6"
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