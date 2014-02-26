



$(document).ready(function(){
  var power_saved = $('#counter_all_time').data("total-power");

  var money_saved_counter = new flipCounter("counter_all_time", {
    value: 234234,
    pace: 2000,
    auto: false
    }
  );



  setInterval(function(){
    money_saved_counter.incrementTo
    });
  }, 300000);
  
}); 
