
describe "{{class_name}}" do
  
  it "renders something" do
    get "/"
    renders 200, &r!Hi!
  end

end # === {{class_name}}

