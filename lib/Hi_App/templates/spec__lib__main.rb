

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

require 'pry'
require 'bacon'
require 'Bacon_Colored'
require 'Bacon_Rack'
Bacon.summary_on_exit

ENV['RACK_ENV'] = 'test'
require 'rack/test'
require "./NAME"

PERM = 301

class Bacon::Context
  
  include Rack::Test::Methods

  def app
    NAME
  end  
  

end # === class


# ==== Custom Code ============




# ========= Include the files ==================
if ARGV.size > 1 && ARGV[1, ARGV.size - 1].detect { |a| File.exists?(a) }
  # Do nothing. Bacon grabs the file.
else
  Dir.glob('./specs/*.rb').each { |file|
    require(file.sub '.rb', '' ) if File.basename(file)[%r!\A(C|M|V)_!]
  }
end


