
describe "Hello create name" do
  
  before {
    chdir { `rm -rf Hello` }
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
    BIN "create Hello"
    chdir {
      File.directory?("Hello/public")
      .should.be == true
    }
  end

  it 'creates file   /name/config.ru' do
    str = "run Hello"
    BIN "create Hello"
    chdir {
      File.read("Hello/config.ru")[str]
      .should == str
    }
  end

  it 'creates file   /name/name.rb' do
    str = "class Hello"
    BIN "create Hello"
    chdir {
      File.read("Hello/Hello.rb")[str]
      .should == str
    }
  end

  it 'creates file   /name/Gemfile' do
    r = %r!gem .sinatra.!
    BIN "create Hello"
    chdir {
      File.read("Hello/Gemfile")[r]
      .should.match r
    }
  end

  it 'git ignores tmp/*' do
    BIN "create Hello"
    chdir {
      File.read("Hello/.gitignore")[%r!^tmp/\*$!]
      .should == "tmp/*"
    }
  end
  
  it 'git ignores logs/*' do
    BIN "create Hello"
    chdir {
      File.read("Hello/.gitignore")[%r!^logs/\*$!]
      .should == "logs/*"
    }
  end

  it 'creates a git commit of: First commit' do
    BIN "create Hello"
    chdir {
      `cd Hello && git log -n 1 --oneline`.strip
      .should.match %r!First commit!
    }
  end

end # === describe UNI_MIND sinatra create_app


