#Integration between DokkuOutputParser <=> ServerCommand
module DokkuOutputable
  def dokku_output
    return nil if result.nil?
    DokkuOutputParser.new(self.command, self.parsed_result["output"]).parse
  end
end
