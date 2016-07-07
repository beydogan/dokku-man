class App < ApplicationRecord
  belongs_to :host
  has_many :app_configs

  after_create :create
  after_save :sync

  def execute(cmd, args = [])
    args = args.unshift(self.name)
    self.host.dokku_cmd("apps:#{cmd}", args)
  end

  def create
    self.execute("create")
  end

  def sync
    if self.name_changed?
      self.host.dokku_cmd("apps:rename", [name_was, name])
    end
  end

  def sync_config
    configs = app_configs.collect {|c| "#{c.name}=#{c.value}" }.join(" ")
    self.host.dokku_cmd("config:set #{self.name} #{configs}")
  end
end
