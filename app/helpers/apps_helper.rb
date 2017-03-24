module AppsHelper

  def app_status_label_class(status)
    case status
    when "creating"
      return "label-warning"
    when "created"
      return "label-success"
    when "failed"
      return "label-danger"
    when "not_exist"
      return "label-warning"
    end
  end

  def app_status_label(status)
    content_tag :span, class: "label #{app_status_label_class(status)}" do
      status.humanize
    end
  end
end
