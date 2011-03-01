require "spec_helper"


describe Cartographer::Gad do

  before do

  end

  after do

  end

  it "should accept valid Gad configuration for producing AdSense ad object" do
    ad = Cartographer::Gad.new(
    :format       => "SKYSCRAPER",
    :div          => "div",
    :position     => "RIGHT_TOP",
    :map          => :map,
    :visible      => true,
    :publisher_id => "PUBLISHER_ID")
    ad.to_js.should include("var adUnit;
     var adUnitDiv	= document.createElement('div');
     var adUnitOptions = {
       format: google.maps.adsense.AdFormat.SKYSCRAPER,
       position: google.maps.ControlPosition.RIGHT_TOP,
       map: map,
       visible: true,
       publisherId: 'PUBLISHER_ID'
     };
     adUnit = new google.maps.adsense.AdUnit(adUnitDiv, adUnitOptions);")
  end
end
