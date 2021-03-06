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
    },
    "apps" => {
      "regex" => /(\w+)/,
      "keys" => [:name],
      "remove_lines" => 2
    },
    "plugin" => {
        "regex" => / {2}([\d\w]+)\s+(\d\.\d\.\d) enabled +dokku (\w+)/,
        "keys" => [:name, :version, :type],
        "remove_lines" => 1
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
    matches = @output.scan(@options["regex"]).flatten
    slice = keys.count
    matches.each_slice(slice) do |line|
      item = {}
      keys.each_with_index do |key, i|
        next if key == :skip
        item[key] = line[i]
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
