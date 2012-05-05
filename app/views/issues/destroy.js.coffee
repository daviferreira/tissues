$('#modal-confirm').modal 'hide'
$("#issue-<%= @issue.id %>").fadeOut "fast", ->
  $(@).remove()