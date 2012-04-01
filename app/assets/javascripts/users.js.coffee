$ ->
  $('#change_avatar').on 'click', (e) ->
    e.preventDefault()
    if $('#avatar-field').is ':visible'
      $('#avatar-field').fadeOut()
    else
      $('#avatar-field').fadeIn()