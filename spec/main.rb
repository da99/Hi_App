
require File.expand_path('spec/helper')
require 'Hi_App'
require 'Bacon_Colored'
require 'Exit_0'
require 'open-uri'
require 'pry'
require 'yaml'

def thin_yml
  YAML::load(File.read "thin.yml")
end

def chdir path = ""
  BOX.chdir(path) { yield }
end

def BIN cmd
  BOX.bin cmd
end

def start port
  Exit_0 "bundle exec thin start -d -p #{port}"
end

def shutdown port = nil
  pid_file = "tmp/pids/thin.pid"
  if File.file?(pid_file)
    Exit_0 "bundle exec thin -P #{pid_file} stop"
  end
  
  # BOX.shell_run("bundle exec thin stop -p #{port}") if `ps aux`["-p #{port}"]
end

def read port, path = "/"
  sleep 0.2
  open("http://localhost:#{port}#{path}").read
end

class Box
  
  FOLDER = "/tmp/Hi_App"

  def initialize
    reset
  end
  
  def bin cmd
    results = ''
    chdir {
      Exit_0 "bundle exec Hi_App #{cmd}"
    }
    results
  end

  def chdir path = ""
    Dir.chdir(File.join FOLDER, path) { yield }
  end

  def reset
    shell_run "rm -rf #{FOLDER}"
    shell_run "mkdir  #{FOLDER}"
    shell_run "cp spec/Box/Gemfile #{FOLDER}/Gemfile"
    shell_run "cp Gemfile.lock     #{FOLDER}/Gemfile.lock"
  end
  
  def shell_run *args
    Exit_0 *args
  end

end # === Box

BOX = Box.new

# ======== Include the tests.
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else

  Dir.glob('spec/tests/*.rb').each { |file|
    require File.expand_path(file.sub('.rb', '')) if File.file?(file)
  }
  
end
