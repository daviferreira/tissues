# coding: utf-8
module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <section class="alert alert-error">
      <a class="close" data-dismiss="alert">&times;</a>
      <header>
        <h4 class="alert-heading">
          #{sentence}
        </h4>
      </header>
      <ul>
      #{messages}
      </ul>
    </section>
    HTML

    html.html_safe
  end
end