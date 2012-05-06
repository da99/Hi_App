
require File.expand_path('spec/helper')
require 'Hi_App'
require 'Bacon_Colored'
require 'Exit_0'
require 'open-uri'
require 'pry'
require 'yaml'

GEMFILE = File.expand_path("Gemfile.lock")

Exit_0 "rm -rf /apps/tmp"


def thin_procs
  Split_Lines(Exit_0("ps aux").out).select { |l| l['thin server'] }
end

ORIG_THINS = thin_procs

def no_extra_thins!
  if thin_procs.size != ORIG_THINS.size
    raise RuntimeError, "Thin processes not stopped: #{(ORIG_THINS - thin_procs).join ' '}"
  end
end

def thin_yml
  YAML::load(File.read "thin.yml")
end

def chdir path = ""
  BOX.chdir(path) { yield }
end

def BIN cmd
  BOX.bin cmd
end

def start
  copy_gemfile
  
  app_name = File.basename(File.expand_path('.'))
  dir = "/apps/#{app_name}"
  
  if File.exists?(dir) && app_name != 'Hello_Prime'
    raise ArgumentError, "#{app_name} already exists."
  else
    Exit_0 "ln -s #{File.expand_path '.'} #{dir}"
    at_exit { Exit_0 "rm #{dir}" if File.exists?(dir) }
  end
  
  Exit_0 %! echo "servers: 1"      >> thin.yml !
  Exit_0 %! echo "daemonize: true" >> thin.yml !
  Exit_0 "bundle exec thin -C thin.yml start"
  sleep 0.3
  
  begin
    yield
  ensure
    shutdown
  end
end

def shutdown
  dir = File.dirname(thin_yml['pid'])
  Dir.glob(File.join dir, '*.pid').each { |f|
    Exit_0 "bundle exec thin -P #{f} stop"
  }
  no_extra_thins!
end

def read path = "/"
  port = thin_yml['port']
  open("http://localhost:#{port}#{path}").read
end

def copy_gemfile
  File.write "Gemfile.lock", File.read(GEMFILE)
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
