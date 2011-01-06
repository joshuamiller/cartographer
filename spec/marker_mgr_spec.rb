require "spec_helper"
describe "Marker manager integration" do

  before do
    @map = Cartographer::Gmap.new('map')
    @icon = Cartographer::Gicon.new(:name => "icon_name",
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
    @marker1 = Cartographer::Gmarker.new(:name=> "org11", :marker_type => "Organization",
              :position => [ 36.031332, -21.093750],
              :info_window_url => "/some_url",
              :icon => @icon,
              :map=>@map)

    @marker2 = Cartographer::Gmarker.new(:name=> "org12", :marker_type => "Organization",
              :position => [ 32.031332, -22.093750],
              :info_window_url => "/some_url",
              :icon => @icon,
              :map=>@map)


  end

  after do

  end


  it "should spit out the marker manager initialization with appropriate markers & zoom" do
    @map.marker_mgr = true
    @map.markers << @marker1
    @map.markers << @marker2
    @map.to_js().should include("google.maps.event.addListener(mgr, 'loaded', function()")
    @map.to_js().should include("mgr.refresh();")

  end

end