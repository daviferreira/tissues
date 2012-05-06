$('#modal-confirm').modal 'hide'
$("#issue-<%= @issue.id %>, #issue-details-<%= @issue.id %>").fadeOut "fast", ->
  $(@).remove()