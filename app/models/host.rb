require 'net/ssh'

class Host < ApplicationRecord
  has_many :apps
  has_many :plugin_instances
  has_many :ssh_keys
  belongs_to :user

  attr_accessor :generate_keys

  before_save :generate_and_save_keys
  before_save :parse_private_key

  def execute(cmd)
    Net::SSH.start(
        self.addr, 'root',
        auth_methods: ["publickey"],
        keys: [],
        key_data: [self.private_key]
    ) do |ssh|
      ssh.exec!(cmd)
    end
  end

  def dokku_cmd(cmd, args = [])
    args = args.join(" ")
    execute("dokku #{cmd} #{args}")
  end

  def create_app(app_name)
    dokku_cmd "apps:create #{app_name}"
  end

  def sync_apps
    app_list = dokku_cmd("apps").split("\n").drop(1)

    app_list.each do |app_name|
      app = self.apps.find_by name: app_name

      if app.present?
        app.sync
      else
        self.apps.create(name: app_name)
      end
    end
  end

  def sync_plugins
    plugin_list = dokku_cmd("plugin")
    Plugin.all.each do |plugin|
      if plugin_list.include? plugin.slug
        self.plugins.push plugin.slug
      else
        self.plugins.delete plugin.slug
      end
    end

    self.save!
  end

  def sync_instances
    transaction do
      plugin_instances.destroy_all # Destroy all instances first
        plugins.uniq.each do |plugin_str|
        plugin = Plugin.find plugin_str
        result = dokku_cmd plugin.list_cmd
        list = result.split("\n").drop(1)

        list.each do |item|
          item_arr = item.split("  ")
          instance_name = item_arr.first
          app_name = item_arr.last.gsub(/\ $/, '') # delete last space char

          if app_name != "-"
            app = App.find_by name: app_name
          end

          instance = PluginInstance.find_or_create_by(name: instance_name, app_id: app.id, host_id: self.id, type: plugin.class_name)
          instance
        end
      end
    end
  end

  def sync!
    self.sync_apps
    self.sync_plugins
    self.sync_instances
    self.update(last_synced_at: DateTime.now)
  end

  def to_s
    self.name
  end

  def generate_and_save_keys
    if generate_keys == "1"
      key = SSHKey.generate
      self.private_key = key.private_key
      self.public_key = key.ssh_public_key
    end
  end

  def parse_private_key
    self.private_key = self.private_key.gsub("\r\n          ", "\n") #TODO find better way
  end
end
