#Integration between DokkuOutputParser <=> ServerCommand
module DokkuOutputable
  def dokku_output
    DokkuOutputParser.new(self.command, self.parsed_result["output"]).parse
  end
end
