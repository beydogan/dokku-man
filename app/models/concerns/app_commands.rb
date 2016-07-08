module AppCommands
  extend ActiveSupport::Concern

  def get_scale_cmd
    scale = {}
    result = self.host.dokku_cmd("ps:scale #{self.name}")
    result = result.gsub("-----> ", "").gsub(" ", "").split("\n")
    list_starts_at = result.find_index("-----------") + 1
    processes = result.slice(list_starts_at..-1)
    processes.each do |p|
      name = p[/\D+/]
      size = p[/\d+/]

      scale[name] = size
    end
    scale
  end

  def set_scale_cmd(scale)
    scale_str = scale.collect {|k,v| "#{k}=#{v}"}.join(" ")
    result = self.host.dokku_cmd("ps:scale #{self.name} #{scale_str}")
  end
end