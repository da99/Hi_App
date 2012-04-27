require 'Hi_App/version'
require 'Exit_0'

class Hi_App
  
  DIR = File.dirname(__FILE__) + "/#{self.name}"

  private # ======================================================

  def read name
    file = File.join( DIR , 'templates', name )
    File.read file
  end

  public # =======================================================

  def create name
    kname = name.sub(/^./) { |s| s.upcase }
    Exit_0 "mkdir -p #{name}/public"
    Exit_0 "touch #{name}/public/.gitkeep"
    files = {}

    %w{ Gemfile config.ru NAME.rb .gitignore }.each { |f|
      path = File.expand_path "#{name}/#{f.sub('NAME', name)}"
      next if File.exists?(path)
      
      File.write path, read(f).gsub('KNAME', kname).gsub('NAME', name)
    }

    files.each do |k,v|
    end

    Dir.chdir(name) {
      unless Dir.pwd[/\A\/tmp/]
        Exit_0 "bundle update"
      end
      Exit_0 "git init && git add . && git commit -m \"Added: Hi_App generated code.\""
    }
  end # === def create_app
  
end # === class Hi_App
