id = <%= @issue.id %>
issue = $('#issue-' + id)

return if not id

issueLink = $('#issue-body-' + id)

if issue.hasClass('editing')
    issueLink.show()
    issue.find('.issue-inline-edit').remove()
    issue.removeClass 'editing'
else
    input = $('<input type="text" value="' + issueLink.text()  + '" data-id="' + id  + '">')
    form = $('<div class="issue-inline-edit"></div>').insertAfter(issueLink)
    input.appendTo(form)
    issueLink.hide()
    input.focus()
    issue.addClass 'editing'
