class App < ApplicationRecord
  include AppCommands

  belongs_to :host
  has_many :app_configs, dependent: :destroy
  has_many :plugin_instances, dependent: :destroy

  accepts_nested_attributes_for :app_configs, reject_if: :all_blank, allow_destroy: true

  validates :name, uniqueness: {scope: :host}

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
    sync_config
  end

  def sync_config
    #configs = app_configs.collect {|c| "#{c.name}=#{c.value}" }.join(" ")
    #self.host.dokku_cmd("config:set #{self.name} #{configs}")
  end

  def sync_scale
    self.scale = get_scale_cmd
    self.save
  end
end
