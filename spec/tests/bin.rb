
describe "permissions of bin/" do
  
  it "should be 750" do
    `stat -c %a bin`.strip
    .should.be == "750"
  end
  
end # === permissions of bin/


describe "HI_APP create/Hello" do
  
  before { BOX.reset }
  
  it "creates a dir called Hello" do
    BIN('create/Hello')
    chdir {
      File.directory?('Hello')
      .should.be == true
    }
  end
  
end # === Hi_App create HI_APP

