$ ->
  $('a[href^="#"]').on 'click.smoothscroll', (e) ->
    e.preventDefault()

    target = @hash
    $target = $(target)

    $('html, body').stop().animate {
      'scrollTop': $target.offset().top if $target.offset() isnt null
    }, 500, 'swing', ->
      window.location.hash = target