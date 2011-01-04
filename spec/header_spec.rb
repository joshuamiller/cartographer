require "spec_helper"


describe Cartographer::Header do

  before do

  end

  after do

  end

   it "should support google maps v3" do
      Cartographer::Header.new.version.should equal(3)
   end

  it "should emit header for google maps three api" do
        Cartographer::Header.new.to_s.should include("<script type=\"text/javascript\" src=\"http://maps.google.com/maps/api/js?sensor=true\"></script>")
      Cartographer::Header.header_for({},3).should include("<script type=\"text/javascript\" src=\"http://maps.google.com/maps/api/js?sensor=true\"></script>")
  end

  

end

