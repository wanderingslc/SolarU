$(document).ready ->
  new Highcharts.Chart(
    chart:
      borderRadius: 0
      height: ($("body").height() * (1 / 2))
      renderTo: "monthly_data"
      type: "areaspline"
      backgroundColor: "#fff"
      plotBackgroundColor: null

    title:
      text: "Daily Totals"
      style:
        color: "#cc0000"
        fontWeight: "bold"
        fontSize: "25px"
        fontFamily: "'orbitron-light', sans-serif"

    legend:
      enabled: true
      align: "center"
      style:
        fontSize: "15px"

    xAxis:
      categories: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31" ]
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
        shadow: true
        offsetX: "3px"
        offsetY: "3px"
        opacity: "0.1"
        marker:
          enabled: false

    series: [
      name: gon.monthly_name_one
      data: gon.monthly_data_one
    ,
      name: gon.monthly_name_two
      data: gon.monthly_data_two
    ,
      name: gon.monthly_name_three
      data: gon.monthly_data_three
     ]
  )
