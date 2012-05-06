<% if flash[:error] %>
  flash "<%= flash[:error] %>", "error"
  $("#comment_body_<%= @issue.id %>").focus()
<% else %>
  $project = $("#projects-page")
  $issues_list = $project.find("ul:first")

  if !$issues_list.length
    $issues_list = $('<ul class="clearfix" />').insertAfter $project.find("header:first")

  $issue = $('<%= escape_javascript(render @issue) %>')
            .appendTo($issues_list)
            .show "scale", 200

  $("#new_issue").find("textarea").val ""

  $issue.find('div.info, div.actions').on "mouseenter", ->
    $(@).parent().find("> a").addClass "active"

  $issue.find('div.info, div.actions').on "mouseleave", ->
    if !$(@).parent().hasClass "active"
      $(@).parent().find("> a").removeClass "active"

  $issue.find('a.delete').on 'click', ->
    delete_object $(@)

<% end %>
<% flash.clear %>