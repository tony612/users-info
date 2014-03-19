# $('#stranger_time').
setInterval( ->
  $div = $('#stranger_time')
  time = parseInt($div.html())
  $div.html(time + 1)
, 60000)
