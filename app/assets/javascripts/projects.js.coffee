window.apply_issue_status = (status, issue) ->
  $issue = $("#issue-#{issue}")
  $issue[0].className = $issue[0].className.replace(/issue\-([a-z\-]+)/g, '');
  $issue
    .addClass("issue-#{status}")
    .show "highlight"

  $details = $("#issue-details-#{issue}")

  $details[0].className = $details[0].className.replace(/details\-([a-z\-]+)/g, '');
  $details.addClass("details-#{status}")

window.delete_object = (object) ->
  console.log object.data('message')
  modal = $('#modal-confirm')
  modal.find('.btn-danger').attr('href', object.data("path"))
  modal.find('.modal-body')
    .text(object.data('message'))
    .append("<span />")
  modal.find(".modal-body > span").text("#{object.data('content')}")

$ ->
  $('ul.users').tooltip {
      selector: "a[rel=tooltip]"
  }

  $('div.info, div.actions').on "mouseenter", ->
    $(@).parent().find("> a").addClass "active"

  $('div.info, div.actions').on "mouseleave", ->
    if !$(@).parent().hasClass "active"
      $(@).parent().find("> a").removeClass "active"

  $('a.delete').on 'click', ->
    delete_object $(@)

  $('.modal').on 'click', '.btn-close', ->
    $('#modal-confirm').modal 'hide'
