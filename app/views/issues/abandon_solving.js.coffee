$('#issue-actions-<%= @issue.id %>').html '<%= escape_javascript(render("issues/button_solve", :issue => @issue)) %>'

apply_issue_status '<%= @issue.status.to_s.gsub(" ", "-") %>', <%= @issue.id %>