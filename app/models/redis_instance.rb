class RedisInstance < PluginInstance

  private

  def create_instance
    super
    self.host.dokku_cmd("redis:create #{self.name}")
    link_to_app
  end

  def link_to_app
    super
    if app.present?
      self.host.dokku_cmd("redis:link #{self.name} #{self.app.name}")
    end
  end
end
