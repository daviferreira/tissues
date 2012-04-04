$('#issue-actions-<%= @issue.id %>')
  .fadeOut(->
    $(@).remove()
  )