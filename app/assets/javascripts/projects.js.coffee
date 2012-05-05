window.apply_issue_status = (status, issue) ->
  $issue = $("#issue-#{issue}")
  $issue[0].className = $issue[0].className.replace(/issue\-([a-z\-]+)/g, '');
  $issue
    .addClass("issue-#{status}")
    .show "highlight"

  $details = $("#issue-details-#{issue}")

  $details[0].className = $details[0].className.replace(/details\-([a-z\-]+)/g, '');
  $details.addClass("details-#{status}")

$ ->
  $('ul.users').tooltip {
      selector: "a[rel=tooltip]"
  }

  $('div.info, div.actions').on "mouseenter", ->
    $(@).parent().find("> a").addClass "active"

  $('div.info, div.actions').on "mouseleave", ->
    if !$(@).parent().hasClass "active"
      $(@).parent().find("> a").removeClass "active"

  $('a.delete-issue').on 'click', ->
    modal = $('#modal-confirm')
    modal.find('.btn-danger').attr('href', "/issues/#{$(@).data('id')}")
    modal.find('.modal-body').html "#{$(@).data('message')}<span>#{$(@).data('issue')}</span>"

  $('.btn-close').on 'click', ->
    $('#modal-confirm').modal 'hide'