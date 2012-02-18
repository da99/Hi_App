
require 'sinatra/base'

class KNAME < Sinatra::Base
  
  get( '/' ) do
    "Hi, #{NAME}."
  end

  get('/time') do
    "Time: #{Time.now.strftime("%S - %H:%M - %Y:%m:%d")}"
  end
  
  
end # === class NAME
