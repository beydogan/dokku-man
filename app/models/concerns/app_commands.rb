module AppCommands
  extend ActiveSupport::Concern

  def get_scale_cmd
    scale = {}
    result = self.server.dokku_cmd("ps:scale #{self.name}")
    result = result.gsub("-----> ", "").gsub(" ", "").split("\n")
    list_starts_at = result.find_index("-----------") + 1
    processes = result.slice(list_starts_at..-1)
    processes.each do |p|
      name = p[/\D+/]
      size = p[/\d+/]

      scale[name] = size
    end
    scale
  end

  def set_scale_cmd(scale)
    scale_str = scale.collect {|k,v| "#{k}=#{v}"}.join(" ")
    result = self.server.dokku_cmd("ps:scale #{self.name} #{scale_str}")
  end

  def deploy(branch)
    @sh = Session::Bash.new
    o = execute_local_sh 'pwd'
    tmp = o.rstrip + "/tmp"
    execute_local_sh "cd '#{tmp}'"
    dir = "changeme"
    execute_local_sh "git clone #{git_url} #{dir}"
    execute_local_sh "cd '#{dir}'"
    execute_local_sh "git checkout '#{branch}'"
    execute_local_sh "git remote add deploy dokku@#{server.addr}:#{name}"
    execute_local_sh "git push deploy #{branch}:master"
    execute_local_sh "rm -rf ./#{dir}"
  end

  def execute_local_sh(cmd)
    output = ""
    @sh.execute cmd do |o, e|
      puts o if o
      output = output + o if o
      puts e if e
    end
    return output
  end
end