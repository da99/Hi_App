
describe "Hi_App create name" do
  
  before {
    chdir {
      `rm -rf Hi_App`
    }
  }
  
  it 'does not overwrite existing files.' do
    target = %!Original #{rand(10)}!
    chdir {
      `mkdir -p Hi_App`
      File.open('Hi_App/app.rb', 'w') do |io|
        io.write target
      end
      
      BIN "sinatra/create_app Hi_App"

      File.read("Hi_App/app.rb").should == target
    }
  end

  it 'creates folder /name/public' do
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.directory?("Hi_App/public")
      .should.be == true
    }
  end

  it 'creates file   /name/config.ru' do
    str = "run Hi_App"
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.read("Hi_App/config.ru")[str]
      .should == str
    }
  end

  it 'creates file   /name/name.rb' do
    str = "class Hi_App"
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.read("Hi_App/Hi_App.rb")[str]
      .should == str
    }
  end

  it 'creates file   /name/Gemfile' do
    r = %r!gem .sinatra.!
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.read("Hi_App/Gemfile")[r]
      .should.match r
    }
  end

  it 'git ignores tmp/*' do
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.read("Hi_App/.gitignore")[%r!^tmp/\*$!]
      .should == "tmp/*"
    }
  end
  
  it 'git ignores logs/*' do
    BIN "sinatra/create_app Hi_App"
    chdir {
      File.read("Hi_App/.gitignore")[%r!^logs/\*$!]
      .should == "logs/*"
    }
  end

  it 'creates a git commit of: First commit' do
    BIN "sinatra/create_app Hi_App"
    chdir {
      `cd Hi_App && git log -n 1 --oneline`.strip
      .should.match %r!First commit!
    }
  end

end # === describe UNI_MIND sinatra create_app


