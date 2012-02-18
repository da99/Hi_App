
describe "Hello create name" do
  
  before {
    chdir { 
      `rm -rf Hello` 
      prime = 'Hello_Prime'
      if not File.directory?(prime)
        BIN("create #{prime}")
        at_exit { `rm -rf #{prime}`}
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

  it 'creates folder /name/public' do
    chdir {
      File.directory?("Hello_Prime/public")
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

  it "creates a working app run by passenger" do
    port = rand(4000..5000)
    chdir {
      Dir.chdir('Hello_Prime') {
        begin
          BOX.shell_run "bundle update"
          BOX.shell_run "bundle exec passenger start -d -p #{port}"
          open("http://localhost:#{port}/").read
          .should.be == "Hi, Hello_Prime."
        ensure
          BOX.shell_run("bundle exec passenger stop -p #{port}") if `ps aux`["-p #{port}"]
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
          BOX.shell_run "bundle exec passenger start -d -p #{port}"
          open("http://localhost:#{port}/time").read
          .should.match %r!Time: \d{2} - \d{2}!
        ensure
          BOX.shell_run("bundle exec passenger stop -p #{port}") if `ps aux`["-p #{port}"]
        end
      }
    }
  end
  
end # === describe UNI_MIND sinatra create_app


