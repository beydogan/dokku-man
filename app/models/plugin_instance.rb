class PluginInstance < ApplicationRecord
  enum status: [:waiting, :created, :linked]
  belongs_to :app
  belongs_to :server

  validates :name, uniqueness: {scope: [:server_id, :type]}

  def enqueue!
    PluginInstanceCreateJob.perform_later(self.id)
  end
end
