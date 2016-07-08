class Plugin
  extend Ambry::Model

  field :slug, :name, :url, :version, :class_name

  def install_cmd
    "#{url} #{slug}"
  end

  def list_cmd
    "#{slug}:list"
  end
end
