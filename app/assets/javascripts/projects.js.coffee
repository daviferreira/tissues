window.apply_issue_status = (status, issue) ->
  $issue = $("#issue-#{issue}")
  $issue[0].className = $issue[0].className.replace(/issue\-([a-z\-]+)/g, '');
  $issue
    .addClass("issue-#{status}")
    .show "highlight"

  $details = $("#issue-details-#{issue}")

  $details[0].className = $details[0].className.replace(/details\-([a-z\-]+)/g, '');
  $details.addClass("details-#{status}")

$('.alert').alert 'close'

$ ->
  $('a[href="#new_issue"]').on 'click', (e) ->
    e.preventDefault
    $('#issue_content').focus()

  $('div.info, div.actions').mouseenter ->
    $(@).parent().find("> a").addClass "active"

  $('div.info, div.actions').mouseleave ->
    if !$(@).parent().hasClass "active"
      $(@).parent().find("> a").removeClass "active"