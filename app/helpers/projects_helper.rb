module ProjectsHelper

  def status_with_user(issue)
    case issue.status
      when "in progress"
        name = get_user_first_name(issue.who_is_solving)
        "#{name} #{if issue.who_is_solving == current_user then t(:are) else t(:is) end} #{t("issues.working_on_it")}"
      when "waiting for validation"
        "#{get_user_first_name(issue.who_is_solving)} #{t("issues.solved_waiting_validation")}"
      when "validating"
        name = get_user_first_name(issue.who_is_validating)
        "#{name} #{if issue.who_is_validating == current_user then t(:are) else t(:is) end} #{t("issues.is_validating")}"
      when "not approved"
        "#{get_user_first_name(issue.who_is_validating)} #{t("issues.not_approved")}"
      when "done"
        "#{get_user_first_name(issue.who_is_solving)} #{t("issues.solved_it")}"
      else
        "#{t("issues.author")} #{get_user_first_name(issue.user)}"
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

  def get_user_first_name(user)
    if user == current_user
      "you"
    else
      user.name.split(" ").first
    end
  end

end