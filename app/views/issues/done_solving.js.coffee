$('#issue-actions-<%= @issue.id %>').html 'Yay!'

apply_issue_status '<%= @issue.status.to_s.gsub(" ", "-") %>', <%= @issue.id %>