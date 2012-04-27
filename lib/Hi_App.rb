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

  def create name, port = nil
    kname = name.sub(/^./) { |s| s.upcase }
    port ||= rand(3000...7000)
    Exit_0 "mkdir -p #{name}/public"
    Exit_0 "touch #{name}/public/.gitkeep"
    files = {}

    %w{ Gemfile config.ru NAME.rb .gitignore thin.yml }.each { |f|
      path = File.expand_path "#{name}/#{f.sub('NAME', name)}"
      next if File.exists?(path)
      
      content = read(f)
      .gsub('KNAME', kname)
      .gsub('NAME', name)
      .gsub('PORT', port.to_s)
      
      File.write path, content
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
