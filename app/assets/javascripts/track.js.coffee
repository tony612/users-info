# $('#stranger_time').
setInterval( ->
  $div = $('#stranger_time')
  time = parseInt($div.data('seconds')) + 1
  $div.data('seconds', time)
  $div.html("#{Math.floor(time / 60)}minutes #{time % 60}s")
, 1000)
