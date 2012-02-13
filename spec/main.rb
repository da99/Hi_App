
require File.expand_path('spec/helper')
require 'Hi_App'
require 'Bacon_Colored'
require "Unified_IO"
require 'open-uri'

Unified_IO::Local::Shell.quiet

def chdir
  BOX.chdir { yield }
end

def BIN cmd
  BOX.bin cmd
end

class Box
  
  include Unified_IO::Local::Shell::DSL

  FOLDER = "/tmp/Hi_App"

  def initialize
    reset
  end
  
  def bin cmd
    results = ''
    chdir {
      results = `bundle exec HI_APP #{cmd} 2>&1`
      if $?.exitstatus != 0
        raise results
      end
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
