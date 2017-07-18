module ApplicationHelper

  def status_label_class(status)
    case status
      when "creating", "syncing"
        return "label-warning"
      when "created", "ok"
        return "label-success"
      when "failed", "out_of_sync", "error"
        return "label-danger"
      when "not_exist"
        return "label-warning"
    end
  end

  def status_label(status)
    content_tag :span, class: "label #{status_label_class(status)}" do
      status.humanize
    end
  end
end
