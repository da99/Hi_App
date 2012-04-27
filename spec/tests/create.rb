
describe "Hello create name" do
  
  before {
    chdir { 
      `rm -rf Hello_Prime` 
      `rm -rf Hello` 
      prime = 'Hello_Prime'
      if not File.directory?(prime)
        BIN("create #{prime}")
        # at_exit { `rm -rf #{prime}`}
      end
    }
  }
  
  it 'does not overwrite existing files.' do
    target = %!Original #{rand(10)}!
    chdir {
      `mkdir -p Hello`
      File.write('Hello/app.rb', target)
      BIN "create Hello"
      File.read("Hello/app.rb")
      .should == target
    }
  end

  it 'creates file /name/public/.gitkeep' do
    chdir {
      File.file?("Hello_Prime/public/.gitkeep")
      .should.be == true
    }
  end

  it 'creates file   /name/config.ru' do
    str = "run Hello_Prime"
    chdir {
      File.read("Hello_Prime/config.ru")[str]
      .should == str
    }
  end

  it 'creates file   /name/name.rb' do
    str = "class Hello_Prime"
    chdir {
      File.read("Hello_Prime/Hello_Prime.rb")[str]
      .should == str
    }
  end

  it 'creates file   /name/Gemfile' do
    r = %r!gem .sinatra.!
    chdir {
      File.read("Hello_Prime/Gemfile")[r]
      .should.match r
    }
  end

  it 'git ignores tmp/*' do
    chdir {
      File.read("Hello_Prime/.gitignore")[%r!^tmp/\*$!]
      .should == "tmp/*"
    }
  end
  
  it 'git ignores log/*' do
    chdir {
      File.read("Hello_Prime/.gitignore")[%r!^log/\*$!]
      .should == "log/*"
    }
  end

  it 'git ignores logs/*' do
    chdir {
      File.read("Hello_Prime/.gitignore")[%r!^logs/\*$!]
      .should == "logs/*"
    }
  end

  it 'creates a git commit of: Hi_App generated code' do
    chdir {
      `cd Hello_Prime && git log -n 1 --oneline`.strip
      .should.match %r!Hi_App generated code!
    }
  end

  it 'creates a thin.yml file with log: /apps/tmp/NAME/thin.log' do
    chdir('Hello_Prime') {
      thin_yml['log']
      .should == "/apps/tmp/Hello_Prime/thin.log"
    }
  end

  it 'creates a thin.yml file with pid: /apps/tmp/NAME/thin.pid' do
    chdir('Hello_Prime') {
      thin_yml['pid']
      .should == "/apps/tmp/Hello_Prime/thin.pid"
    }
  end

  it 'creates a thin.yml file with environment: production' do
    chdir('Hello_Prime') {
      thin_yml['environment']
      .should == "production"
    }
  end

  it "creates a working app run by thin" do
    port = rand(4000..5000)
    chdir {
      Dir.chdir('Hello_Prime') {
        begin
          BOX.shell_run "bundle update"
          start port
          read(port)
          .should.be == "Hi, Hello_Prime."
        ensure
          shutdown
        end
      }
    }
  end

  it "creates a working app with route /time" do
    port = rand(4000..5000)
    chdir {
      Dir.chdir('Hello_Prime') {
        begin
          BOX.shell_run "bundle update"
          start port
          read(port, "/time")
          .should.match %r!Time: \d{2} - \d{2}!
        ensure
          shutdown
        end
      }
    }
  end
  
end # === describe UNI_MIND sinatra create_app


