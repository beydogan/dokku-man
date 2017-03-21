class Notifier
  include Interactor
  include InteractorLogger

  def call
    server = context.server if context.server.present?
    user = context.user || server.user
    action = context.action
    i18n_vars = context.i18n_vars || {}
    reload_page = context.reload_page || false
    reload_element_check = context.reload_element_check
    content_replace = context.content_replace
    content_replace_target = context.content_replace_target
    content_replace_payload = context.content_replace_payload

    message = I18n.t("notifier.#{action}", i18n_vars)

    payload = {
        message: message,
        type: "information",
        reload_page: reload_page,
        reload_element_check: reload_element_check,
        content_replace: content_replace.present?,
        content_replace_target: content_replace_target,
        content_replace_payload: content_replace_payload
    }

    NotifierJob.perform_later(user.id, payload)
  end
end
