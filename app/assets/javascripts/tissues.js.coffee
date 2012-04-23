window.flash_timer = ''

window.flash = (message, type, timeout=5000) ->

  clearTimeout flash_timer

  $notification = $("#notification")

  $('body').prepend('<div id="notification" class="alert" />') if $notification.length == 0

  hide_notification = ->
    clearTimeout flash_timer
    $('#notification').slideUp "fast"
    
  $('#notification')
    .attr('class', '')
    .addClass("alert-#{type}")
    .html("<p>#{message}</p>")
    .show( 'bounce', "fast" )
    .click (e) ->
      e.preventDefault()
      hide_notification()

  window.flash_timer = setTimeout hide_notification, timeout

window.scroll_to = (target, speed = 500, diff = 0) ->
  $target = $(target)

  $('html, body').stop().animate {
    'scrollTop': $target.offset().top + diff if $target.offset() isnt null
  }, speed, 'swing', ->
    window.location.hash = target

$ ->
  $('a[href^="#"]').on 'click.smoothscroll', (e) ->
    e.preventDefault()

    scroll_to(@hash)