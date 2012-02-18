
require 'sinatra/base'

class NAME < Sinatra::Base
  
  get( '/' ) do
    "Hi, #{NAME}."
  end

  get('/time') do
    "Time: #{Time.now.strftime("%S - %H:%M - %Y:%m:%d")}"
  end
  
  
end # === class NAME
