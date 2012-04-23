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