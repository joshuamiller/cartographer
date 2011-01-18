require "spec_helper"
describe Cartographer::Gmarker do

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

  end

  after do

  end

  it "should accept valid Gmarker configuration for producing v3 marker object" do

    marker = Cartographer::Gmarker.new(:name=> "org11", :marker_type => "Organization",
              :position => [ 36.031332, -21.093750],
              :info_window_url => "/some_url",
              :icon => @icon,
              :map=>@map)
    marker.to_js(false).should include("org11 = new google.maps.Marker({map: null,position: new google.maps.LatLng(36.031332, -21.09375), draggable: false, icon: icon_name});")


    marker.to_js(true).should include("org11 = new google.maps.Marker")
  end

  it "should accept configuration for click event" do
    marker = Cartographer::Gmarker.new(:name=> "org11", :marker_type => "Organization",
              :position => [ 36.031332, -21.093750],
              :click => "alert(\"Click Works!\");",
              :icon => @icon,
              :map=>@map)
    marker.to_js().should include("google.maps.event.addListener(org11, 'click', function() {alert(\"Click Works!\");});")

  end

  it "should accept configuration for info window url" do
    marker = Cartographer::Gmarker.new(:name=> "org11", :marker_type => "Organization",
              :position => [ 36.031332, -21.093750],
              :info_window_url => "/some_url",
              :icon => @icon,
              :map=>@map)
    marker.to_js().should include("var fetched_content = cartographer_ajax_fetch_url(\"/some_url\");")

  end

end