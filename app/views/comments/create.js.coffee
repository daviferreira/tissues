<% if flash[:error] %>
  flash "<%= flash[:error] %>", "error"
  $("#comment_body_<%= @issue.id %>").focus()
<% else %>
  $details = $("#issue-details-<%= @issue.id %>")
  $comments_list = $details.find("section.comments")

  if !$comments_list.length
    $comments_list = $('<section class="comments" />').insertAfter $details.find("h1:first")

  $('<%= escape_javascript(render @comment) %>')
    .appendTo($comments_list)
    .show "scale", 200

  $("form.comment").find("textarea").val ""
<% end %>
<% flash.clear %>