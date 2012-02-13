
require 'sinatra/base'

class NAME < Sinatra::Base
  
  get( '/' ) do
    "Hi, #{NAME}."
  end
  
end # === class NAME
