$('#issue-actions-<%= @issue.id %>').html("<% if @issue.status == "done" %>Yay!<% end %>")

apply_issue_status '<%= @issue.status.to_s.gsub(" ", "-") %>', <%= @issue.id %>