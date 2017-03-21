module AppsHelper

  def app_status_label_class(status)
    case status
    when "creating"
      return "label-warning"
    when "created"
      return "label-success"
    when "failed"
      return "label-danger"
    end
  end
end
