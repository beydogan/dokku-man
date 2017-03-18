class CommandRunner
  include Interactor

  def call
    server = Server.find(context.server_id)
    command = context.command
    args = context.args

    begin
      api_result = server.api.run("create_command", command)
      raise "UnexpectedError" if api_result["status"] == "error"
      sc = ServerCommand.create!(command: command, token: api_result["token"], server: server)
      context.server_command = sc
    rescue Exception => e
      puts e.message
    end
  end
end
