
require File.expand_path('spec/helper')
require 'Hi_App'
require 'Bacon_Colored'
require "Exit_Zero"
require 'open-uri'


def chdir
  BOX.chdir { yield }
end

def BIN cmd
  BOX.bin cmd
end

class Box
  
  FOLDER = "/tmp/Hi_App"

  def initialize
    reset
  end
  
  def bin cmd
    results = ''
    chdir {
      Exit_Zero "bundle exec Hi_App #{cmd}"
    }
    results
  end

  def chdir 
    Dir.chdir(FOLDER) { yield }
  end

  def reset
    shell_run "rm -rf #{FOLDER}"
    shell_run "mkdir  #{FOLDER}"
    shell_run "cp spec/Box/Gemfile #{FOLDER}/Gemfile"
    shell_run "cp Gemfile.lock     #{FOLDER}/Gemfile.lock"
  end
  
  def shell_run *args
    Exit_Zero *args
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
