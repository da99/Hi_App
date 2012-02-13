
describe "Hi_App create/Hello" do
  
  before { BOX.reset }
  
  it "creates a dir called Hello" do
    BIN('create/Hello')
    chdir {
      File.directory?('Hello')
      .should.be == true
    }
  end
  
end # === Hi_App create Hi_App

