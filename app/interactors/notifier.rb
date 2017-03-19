class Notifier
  include Interactor

  @@reloads = [
    :server_sync_completed,
  ]

  def call
    server = context.server if context.server.present?
    user = context.user || server.user
    action = context.action
    i18n_vars = context.i18n_vars || {}
    content_replace = context.content_replace
    content_replace_target = context.content_replace_target
    content_replace_payload = context.content_replace_payload

    message = I18n.t("notifier.#{action}", i18n_vars)

    payload = {
        message: message,
        type: "information",
        reload: @@reloads.include?(action),
        content_replace: content_replace.present?,
        content_replace_target: content_replace_target,
        content_replace_payload: content_replace_payload
    }

    NotifierJob.perform_later(user.id, payload)
  end
end
