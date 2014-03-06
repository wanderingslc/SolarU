$(document).ready ->
  total_output = $("#counter_total_output").data("total-output")

  total_output_counter = new flipCounter("counter_total_output",
    value: total_output
    pace: 2000
    auto: false
  )
  total_saved = Math.round((((total_output / 1000) * 7.74) / 100))
  money_saved_counter = new flipCounter("counter_total_saved",
    value: total_saved
    pace: 2000
    auto: false
  )

  total_trees = Math.round(total_output / 55300)
  total_output_trees = new flipCounter("counter_total_trees",
    value: total_trees
    pace: 2000
    auto: false
  )


  total_coffee = Math.round(total_output / 80)
  total_coffee_counter = new flipCounter("counter_total_coffee",
    value: total_coffee
    pace: 2000
    auto: false
  )

  total_laptops = Math.round(total_output / 55)
  total_laptops_counter = new flipCounter("counter_total_laptops",
    value: total_laptops
    pace: 2000
    auto: false
  )

  total_houses = Math.round(total_output / 10837000)
  total_houses_counter = new flipCounter("counter_total_houses",
    value: total_houses
    pace: 2000
    auto: false
  )

  total_coal = Math.round(total_output / 900)
  total_coal_counter = new flipCounter("counter_total_coal",
    value: total_coal
    pace: 2000
    auto: false
  )

  total_natural_gas = Math.round(total_output / 127)
  total_natural_gas_counter = new flipCounter("counter_total_natural_gas",
    value: total_natural_gas
    pace: 2000
    auto: false
  )

  reload_counters = (new_total_output) -> 
    all_counters = [
      total_output_counter, money_saved_counter, total_output_trees, 
      total_coffee_counter, total_laptops_counter, total_houses_counter, 
      total_coal_counter,total_natural_gas_counter
    ]
    all_multipliers = [1, 0.0000774, 55300, 80, 55, 10837000, 900, 127]
    for counter, index in all_counters
      if index == 1
        new_counter_value = Math.round(new_total_output * all_multipliers[index])
      else
        new_counter_value = Math.round(new_total_output / all_multipliers[index])
      console.log "new value: #{new_counter_value}"
      counter.incrementTo(new_counter_value, 10, 600)

  setInterval (->
    reload_counters(9000000)
  ), 5000






  # setInterval(function(){
  #   money_saved_counter.incrementTo
  #   });
  # }, 300000);
  