module ProjectsHelper

  def status_with_user(issue)
    case issue.status
      when "in progress"
        "#{issue.who_is_solving.name.split(" ").first} #{t("issues.working_on_it")}"
      when "waiting for validation"
        "#{issue.who_is_solving.name.split(" ").first} #{t("issues.solved_waiting_validation")}"
      when "validating"
        "#{issue.who_is_validating.name.split(" ").first} #{t("issues.is_validating")}"
      when "not approved"
        "#{issue.who_is_validating.name.split(" ").first} #{t("issues.not_approved")}"
      when "done"
        "#{issue.who_is_solving.name.split(" ").first} #{t("issues.solved_it")}"
      else
        "#{t("issues.author")} #{issue.user.name.split(" ").first}"
    end
  end

  def show_action_for(issue)
    case issue.status
      when "pending"
        action = "issues/button_solve"
      when "waiting for validation"
        action = "issues/button_validate" if issue.who_is_solving != current_user
      when "in progress"
        action = "issues/button_done" if issue.who_is_solving == current_user
      when "validating"
        action = action = "issues/buttons_validation" if issue.who_is_validating == current_user
    end
    render(action, :issue => issue) if action
  end

end