
describe "gem files" do
  
  it "includes templates/Gemfile.lock" do
    `git ls-files -- lib/Hi_App/templates/*`.strip.split
    .should.include "lib/Hi_App/templates/Gemfile.lock"
  end
  
end # === gem files

