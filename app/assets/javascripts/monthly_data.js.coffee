$(document).ready ->

  monthly_name_one = $('#monthly_data').data('monthly-name-one')
  monthly_data_one = $('#monthly_data').data('monthly-data-one').split(" ")
  monthly_name_two = $('#monthly_data').data('monthly-name-two')
  monthly_data_two = $('#monthly_data').data('monthly-data-two').split(" ")
  monthly_name_three = $('#monthly_data').data('monthly-name-three')
  monthly_data_three = $('#monthly_data').data('monthly-data-three').split(" ")


  turn_into_array = (data_string) ->
    i = 0
    while i < data_string.length
      data_string[i] = parseFloat(data_string[i], 10)
      i++

  turn_into_array(monthly_data_one)
  turn_into_array(monthly_data_two)
  turn_into_array(monthly_data_three)

  new Highcharts.Chart(
    chart:
      borderRadius: 0
      height: ($("body").height() * (1 / 2))
      renderTo: "monthly_data"
      type: "areaspline"
      backgroundColor: "#ffffff"
      plotBackgroundColor: null

    title:
      text: "Daily Totals Over the Last 3 Months"
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

    navigation:
      buttonOptions:
        enabled: false

    series: [
      {
        name: monthly_name_one
        data: monthly_data_one
      }
      {
        name: monthly_name_two
        data: monthly_data_two
      }
      {
        name: monthly_name_three
        data: monthly_data_three
      }
    ]
  )
