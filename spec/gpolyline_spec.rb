require "spec_helper"
describe Cartographer::GpolyLine do

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
              :position => [ 32.031332, -22.092750],
              :info_window_url => "/some_url",
              :icon => @icon,
              :map=>@map)




  end


  it "should spit out the polyline overlay when supplied with markers" do
    @map.marker_clusterer = false
    @map.markers << @marker1
    @map.markers << @marker2
    polyline = Cartographer::GpolyLine.new({:name=>"test_lines"})
    polyline.markers = [@marker1,@marker1]
    polyline.map = @map

    polyline.to_js().should include("var g_polyline_points_for_gmap_polyline_test_lines = [];\n\ng_polyline_points_for_gmap_polyline_test_lines.push(new google.maps.LatLng(36.031332, -21.09375));\ng_polyline_points_for_gmap_polyline_test_lines.push(new google.maps.LatLng(36.031332, -21.09375));\tvar gmap_polyline_test_lines = new google.maps.Polyline({path: g_polyline_points_for_gmap_polyline_test_lines,strokeColor: '#0000ff',strokeWeight: 3,strokeOpacity: 0.5});\tgmap_polyline_test_lines.setMap(map);")

  end

end