class PluginInstance < ApplicationRecord
  belongs_to :app
  belongs_to :host

  after_create :create_instance

  validates :type, uniqueness: {scope: :app }

  private

  def create_instance

  end

  def link_to_app

  end

end
