require "spec_helper"
describe Cartographer::Gicon do

  before do

  end

  after do

  end

  it "should accept valid Gicon configuration for producing MarkerImage object" do
    icon = Cartographer::Gicon.new(:name => "icon_name",
          :image_url => '/images/icon.gif',
          :shadow_url => '/images/icon.gif',
          :width => 30,
          :height => 20,
          :shadow_width => 30,
          :shadow_height => 20,
          :anchor_x => 0,
          :anchor_y => 20,
          :info_anchor_x => 5,
          :info_anchor_x => 1)
    icon.to_js.should include("google.maps.MarkerImage")
  end



end