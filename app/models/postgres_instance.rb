class PostgresInstance < PluginInstance

  def create_command
    "postgres:create #{self.name}"
  end

  def link_command(app)
    "postgres:link #{self.name} #{app}"
  end


  private

  def create_instance
  end

  def link_to_app
  end

end
