class Plugin
  extend Ambry::Model

  field :name, :slug, :url, :version

  def install_cmd
    "#{url} #{slug}"
  end
end
