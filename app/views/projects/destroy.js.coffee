$('#modal-confirm').modal 'hide'
$("#project-<%= @project.id %>").fadeOut "fast", ->
  $(@).remove()