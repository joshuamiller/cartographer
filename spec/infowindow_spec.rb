require "spec_helper"
describe Cartographer::InfoWindow do

  before do

  end

  after do

  end

  it "should accept valid infowindow configuration for producing google.maps.InfoWindow object" do
    iw = Cartographer::InfoWindow.new(:name => "window_name",
          :content => 'This is a lovely window'
          )
    iw.to_js.should include("var window_name = new google.maps.InfoWindow({\n      content: \"This is a lovely window\"\n    });")
  end



end