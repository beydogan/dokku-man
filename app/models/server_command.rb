class ServerCommand < ApplicationRecord
  enum status: [:waiting, :success, :failed]
  belongs_to :server
end
