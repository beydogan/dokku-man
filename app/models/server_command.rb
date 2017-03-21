class ServerCommand < ApplicationRecord
  enum status: [:waiting, :running, :success, :failed]
  belongs_to :server
  has_one :next_command, class_name: "ServerCommand", foreign_key: :next_command_id

  validate :next_command_cant_be_self

  def enqueue!
    ServerCommandRunnerJob.perform_later(self.id)
  end

  def run
    self.running!
    begin
      api_result = self.server.api.run("create_command", self.command, self.sync)
      puts api_result
      self.result = api_result["result_data"].to_json
      api_result["result_data"]["ok"] ? (self.status = :success) : (self.status = :failed)
      self.ran_at = DateTime.now
      self.token = api_result["token"]
      self.save!
    rescue
      self.failed!
    end
  end

  def is_sync?
    sync
  end

  def parsed_result
    JSON.parse(result)
  end

  private

    def next_command_cant_be_self
      errors[:next_command] << "Can't be self" if next_command.present? && (id == next_command_id)
    end
end
