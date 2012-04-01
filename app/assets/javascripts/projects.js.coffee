$('.alert').alert 'close'

$ ->
  $('a[href="#new_issue"]').on 'click', (e) ->
    e.preventDefault
    $('#issue_content').focus()