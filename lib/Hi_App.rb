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

  def exit_0 script
    Bundler.with_clean_env {
      Split_Lines(script).each { |cmd|
        Exit_0 {
          `#{cmd}`
          $?
        }
      }
    }
  end

  def create name, port = nil
    kname = name.sub(/^./) { |s| s.upcase }
    port ||= rand(3000...7000)
    exit_0 "mkdir -p #{name}/public"
    exit_0 "mkdir -p #{name}/spec/lib"
    exit_0 "touch #{name}/public/.gitkeep"
    files = {}

    %w{ Gemfile config.ru NAME.rb .gitignore thin.yml spec__lib__main.rb }.each { |f|
      path = File.expand_path "#{name}/#{f.sub('NAME', name).gsub('__','/')}"
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
      exit_0 %(
        bundle update
        git init 
        git add . 
        git commit -m "Added: Hi_App generated code."
      )
    }
  end # === def create_app
  
end # === class Hi_App
