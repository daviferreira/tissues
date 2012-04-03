$('#box-form-avatar img, #box-form-avatar .actions').fadeOut ->
  $(@).remove()
  $('#avatar-field').fadeIn()