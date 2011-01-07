require "spec_helper"


describe Cartographer::Gmap do

  before do

  end

  after do

  end

  it "should initialise the map with no parameter" do
    map = Cartographer::Gmap.new('map')
    map.to_s.should include("map = new google.maps.Map(document.getElementById(\"map\"),{center: new google.maps.LatLng(0, 0), zoom: 0, mapTypeId: google.maps.MapTypeId.ROADMAP});")
  end

  it "should initialise the map with option for disabling dragging" do
    map = Cartographer::Gmap.new('map',{:draggable => false})
    map.to_s.should include("map.draggable = false;")

  end
  it "should initialise the map with option for center & zoom" do
    map = Cartographer::Gmap.new('map',{:center => [12,14],:zoom=> 10})
    map.to_s.should include("map.setCenter(new google.maps.LatLng(12, 14));map.setZoom(10);")
  end
  it "should allow zoom to be :bound" do
    map = Cartographer::Gmap.new('map',{:center => [12,14],:zoom=> :bound})
    map.to_s.should include("map.fitBounds(map_bounds);")
  end

  it "should allow marker clusterer" do
    map = Cartographer::Gmap.new('map')
    map.marker_clusterer = true
    map.marker_clusterer.should equal(true)
  end

  it "should allow various map types" do
    [:roadmap,:hybrid,:satellite,:terrain].each{|map_type|
      map = Cartographer::Gmap.new('map',{:type => map_type})
      map.to_s.should include("map.setMapTypeId(google.maps.MapTypeId.#{map_type.to_s.upcase});")
    }
  end

  it "should have a global shared info window" do

    map = Cartographer::Gmap.new('map',{})
    map.to_s.should include("var default_shared_info_window = new google.maps.InfoWindow({ content: \"\" });")

    info_win =Cartographer::InfoWindow.new(:name => "custom_name",:content => 'This is a lovely window')
    map = Cartographer::Gmap.new('map',{:shared_info_window => info_win })
    map.to_s.should include("custom_name")

  end

  it "should allow marker manager" do
    map = Cartographer::Gmap.new('map')
    map.marker_mgr = true
    map.marker_mgr.should equal(true)


  end
  it "should allow marker clusterer" do
    map = Cartographer::Gmap.new('map')
    map.marker_clusterer = true
    map.marker_clusterer.should equal(true)
  end

end