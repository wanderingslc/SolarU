$(document).ready -> 
  new Highcharts.Chart(
    chart:
      borderRadius: 0
      # width: $(".bottom-row").width()
      height: ($(window).height() * (1 / 2))
      # height: $(".bottom-row").height()
      renderTo: "power_all_time"
      backgroundColor: "#fff"
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
      pointStart: gon.lifetime_unix_time 
      data: gon.lifetime_data
    ]
  )