el = $('#issue-details-<%= @issue.id %>')

$('.details').each ->
  if $(@).attr("id") != el.attr("id")
    $(@)
      .hide()
      .prev()
        .removeClass("active")
        .find('> a')
        .removeClass "active"

$('.editing').each ->
    $(@).find('.issue-inline-edit').remove()
    $(@).find('.issue-body').show()
    $(@).removeClass('editing')

issue = $('#issue-<%= @issue.id %>')
effect = "blind"
speed = 200

activate_issue = ->
  issue
    .addClass("active")
    .find("> a:first")
      .addClass "active"

deactivate_issue = ->
  issue
    .removeClass("active")
    .find("> a:first")
      .removeClass "active"

if el.length == 0
  activate_issue()
  $('<%= escape_javascript(render("issues/details", :issue => @issue)) %>')
    .insertAfter("#issue-<%= @issue.id %>")
    .show effect, speed, ->
      scroll_to "#issue-details-<%= @issue.id %>", speed, -1 * ($(@).prev().height() + 17)
else
  if el.is(":visible")
    deactivate_issue()
    el.slideUp()
  else
    activate_issue()
    el.show effect, speed, ->
      scroll_to "#issue-details-<%= @issue.id %>", speed, -1 * ($(@).prev().height() + 17)
