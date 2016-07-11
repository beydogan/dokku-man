class PluginInstance < ApplicationRecord
  belongs_to :app
  belongs_to :host

  after_create :create_instance

  validates :name, uniqueness: {scope: [:host_id, :type]}

  private

  def create_instance

  end

  def link_to_app

  end

end
