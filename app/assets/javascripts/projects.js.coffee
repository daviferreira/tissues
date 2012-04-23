$('.alert').alert 'close'

$ ->
  $('a[href="#new_issue"]').on 'click', (e) ->
    e.preventDefault
    $('#issue_content').focus()

  $('div.info, div.actions').mouseenter ->
    $(@).parent().find("> a").addClass "active"

  $('div.info, div.actions').mouseleave ->
    $(@).parent().find("> a").removeClass "active"