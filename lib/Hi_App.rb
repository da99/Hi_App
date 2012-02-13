require 'Hi_App/version'
require 'Unified_IO'
class Hi_App
  
  include Unified_IO::Local::Shell::DSL

  private # ======================================================

  def read file
    dir = File.join(  File.dirname(__FILE__), file )
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

    shell_run "git init && git add . && git commit -m \"First commit: Uni_Mind generated code.\""
  end # === def create_app
  
end # === class Hi_App
