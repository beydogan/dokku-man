class Plugin
  extend Ambry::Model

  field :name, :slug, :url, :version, :class_name

  def install_cmd
    "#{url} #{slug}"
  end
end
