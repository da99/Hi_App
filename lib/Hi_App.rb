require 'Hi_App/version'
require 'Unified_IO'
class Hi_App
  
  DIR = File.dirname(__FILE__) + "/#{self.name}"

  include Unified_IO::Local::Shell::DSL

  private # ======================================================

  def read name
    file = File.join( DIR , 'templates', name )
    File.read file
  end

  public # =======================================================

  def create name
    shell_run "mkdir -p #{name}/public"
    files = {}

    %w{ Gemfile Gemfile.lock config.ru NAME.rb .gitignore }.each { |f|
      path = File.expand_path "#{name}/#{f.sub('NAME', name)}"
      next if File.exists?(path)
      
      File.write path, read(f).gsub('NAME', name)
    }

    files.each do |k,v|
    end

    Dir.chdir(name) {
      shell_run "git init && git add . && git commit -m \"First commit: Uni_Mind generated code.\""
    }
  end # === def create_app
  
end # === class Hi_App
