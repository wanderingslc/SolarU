$ ->
  Highcharts.setOptions global:
        useUTC: false


# I don't know if we need this, it is breaking our graphs. If we save all of the data in the proper timezone, 
# do we still need a timezone offset?  But then again, with the daily power graph with the weather, it seems to help

# useUTC: false -- this seems to fix all graphs... not sure why...