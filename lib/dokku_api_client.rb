class DokkuAPIClient
  valid_commands = ["list_commands", "create_command", "get_command", "retry_command"].freeze

  def initialize(endpoint, api_key, api_secret)
    @endpoint = endpoint
    @api_key = api_key
    @api_secret = api_secret
  end

  def run(command, *args)
    JSON.parse(self.send(command, *args).to_s)
  end

  def list_commands
    client.get("#{@endpoint}/commands")
  end

  def get_command(token)
    client.get("#{@endpoint}/commands/#{token}")
  end

  def create_command(command)
    client.post("#{@endpoint}/commands", form: {cmd: command})
  end

  def retry_command(token)
    client.get("#{@endpoint}/commands/#{token}/retry")
  end

  private

    def validate_command!(command)
      raise "InvalidCommand" unless valid_commands.includes? command
    end

    def client
      HTTP.headers(headers)
    end

    def headers
      {
        "Accept" => "application/json",
        "Api-Key" => @api_key,
        "Api-Secret" => @api_secret
      }
    end
end
