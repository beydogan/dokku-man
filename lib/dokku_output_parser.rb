# Generic output parser to parse dokku command outputs
# Its using regex to match patterns within output and returns an array of hashes

class DokkuOutputParser
  @@options = {
    "postgres:list" => {
      "regex" => /([\w\:\.-]+)[\s]/,
      "keys" => [:name, :version, :status, :skip, :links],
      "remove_lines" => 1
    },
    "redis:list" => {
      "regex" => /([\w\:\.-]+)[\s]/,
      "keys" => [:name, :version, :status, :skip, :links],
      "remove_lines" => 1
    },
    "ps:scale" => {
      "regex" => /([\w\:\.-]+)[\s]/,
      "keys" => [:proc_type, :quantity],
      "remove_lines" => 3
    }
  }

  def initialize(command, output)
    @command = command
    @output = output
    @options = @@options[@command]
    remove_lines!
  end

  def parse
    result = []
    keys = @options["keys"]
    matches = @output.scan @options["regex"]
    matches.each_slice(keys.count) do |line|
      item = {}
      keys.each_with_index do |key, i|
        next if key == :skip
        item[key] = line[i][0]
      end
      result << item
    end
    result
  end

  def remove_lines!
    count = @options["remove_lines"]
    @output = @output.split("\n").drop(count).join(" ").concat(" ")
  end
end
