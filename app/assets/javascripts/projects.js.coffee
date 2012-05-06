window.apply_issue_status = (status, issue) ->
  $issue = $("#issue-#{issue}")
  $issue[0].className = $issue[0].className.replace(/issue\-([a-z\-]+)/g, '');
  $issue
    .addClass("issue-#{status}")
    .show "highlight"

  $details = $("#issue-details-#{issue}")

  $details[0].className = $details[0].className.replace(/details\-([a-z\-]+)/g, '');
  $details.addClass("details-#{status}")

window.delete_issue = (issue) ->
  modal = $('#modal-confirm')
  modal.find('.btn-danger').attr('href', issue.data("path"))
  modal.find('.modal-body')
    .text("#{issue.data('message')}")
    .append("<span />")
      .text("#{issue.data('issue')}")

$ ->
  $('ul.users').tooltip {
      selector: "a[rel=tooltip]"
  }

  $('div.info, div.actions').on "mouseenter", ->
    $(@).parent().find("> a").addClass "active"

  $('div.info, div.actions').on "mouseleave", ->
    if !$(@).parent().hasClass "active"
      $(@).parent().find("> a").removeClass "active"

  $('div.actions').on 'click', 'a.delete', ->
    delete_issue $(@)

  $('.modal').on 'click', '.btn-close', ->
    $('#modal-confirm').modal 'hide'