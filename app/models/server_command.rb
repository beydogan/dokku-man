class ServerCommand < ApplicationRecord
  enum status: [:waiting, :success, :failed]
  belongs_to :server
  has_one :next_command, class_name: "ServerCommand", foreign_key: :next_command_id

  validate :next_command_cant_be_self

  def enqueue!
    ServerCommandRunnerJob.perform_later(self.id)
  end


  private

    def next_command_cant_be_self
      errors[:next_command] << "Can't be self" if (id == next_command_id)
    end

end
