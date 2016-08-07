class Notifier
  include Interactor

  def call
    user = context.user
    action = context.action
    vars = context.vars || {}

    message = I18n.t("notifier.#{action}", vars)
    NotifierJob.perform_later(user.id, {message: message, type: "information"})
  end
end
