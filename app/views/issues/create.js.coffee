<% if flash[:error] %>
  flash "<%= flash[:error] %>", "error"
  $("#comment_body_<%= @issue.id %>").focus()
<% else %>
  $project = $("#projects-page")
  $issues_list = $project.find("ul:first")

  if !$issues_list.length
    $issues_list = $('<ul class="clearfix" />').insertAfter $project.find("header:first")

  $('<%= escape_javascript(render @issue) %>')
    .appendTo($issues_list)
    .show "scale", 200

  flash "<%= flash[:success] %>", "success"

  $("#new_issue").find("textarea").val ""
<% end %>
<% flash.clear %>