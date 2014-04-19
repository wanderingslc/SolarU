$(document).ready -> 

  last_seven_day_time = $("#power_and_weather").data("seven-day-time")
  last_seven_day_data = $("#power_and_weather").data("seven-day-data").split(" ")
  temperature_data = $("#power_and_weather").data("temperature-data").split(" ")
  cloud_cover_data = $("#power_and_weather").data("cloud-data").split(" ")

  turn_into_array = (data_string) ->
    i = 0
    while i < data_string.length
      data_string[i] = parseFloat(data_string[i], 10)
      i++

  turn_into_array(last_seven_day_data)
  turn_into_array(temperature_data)
  turn_into_array(cloud_cover_data)

  new Highcharts.Chart(
    chart:
      borderRadius: 0
      height: ($('body').height() * (1 / 2))
      renderTo: "power_and_weather"
      backgroundColor: "#FCFFF5"
      plotBackgroundColor: null
      style:
        color: "#990000"
        fontSize: "2em"
        title:
          style:
            color: "#cc0000"
            fontWeight: "bold"

    legend:
      enabled: true

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

    yAxis: [
      min: 0
      title:
        text: "Watts"
        lineColor: "#dac092"
        style:
          color: "#FF0DFF"
     ,
      title:
        text: "Temperature"
        lineColor: "#FF0000"
        style:
          color: "#FF0000"
     ,

      max: 0.9
      min: 0
      title:
        text: "Cloud Cover"
        lineColor: "#FF0DFF"
        style:
          color: "#FF0DFF"
      opposite: true
      labels:
        style:
          color: "#FF0DFF"
    ]

    plotOptions:
      series:
        shadow: true
        offsetX: "3px"
        offsetY: "3px"
        opacity: "0."
        marker:
          enabled: false

    navigation:
      buttonOptions:
        enabled: false

    series: [ 
      yAxis: 0
      type: "spline"
      startOnTick: true
      name: "Watts Produced"
      pointInterval: 1800000
      pointStart: last_seven_day_time
      data: last_seven_day_data
     ,
      yAxis: 1
      type: "line"
      name: "Temperature"
      pointInterval: 1800000
      pointStart: last_seven_day_time
      data: temperature_data, dashStyle: 'shortdot'
     ,
      yAxis: 2
      type: "line"
      name: "Cloud Cover"
      pointInterval: 1800000
      pointStart: last_seven_day_time
      data: cloud_cover_data
    ]
  )