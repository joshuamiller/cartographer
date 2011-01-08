require "spec_helper"
describe "Marker clusterer integration" do

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


    @cluster_icon = Cartographer::ClusterIcon.new({:marker_type => "Organization"})
    #push first variant
    @cluster_icon << {
            :url => '/image_smallest.gif',
            :height => 18,
            :width => 10,
            :opt_anchor => [10, 0],
            :opt_textColor => 'black'
          }
   #push second variant
   @cluster_icon << {
            :url => '/image_normal.gif',
            :height => 21,
            :width => 15,
            :opt_anchor => [20, 0],
            :opt_textColor => 'black'
          }

  #push third variant
   @cluster_icon << {
            :url => '/image_biggest.gif',
            :height => 27,
            :width => 19,
            :opt_anchor => [26, 0],
            :opt_textColor => 'black'
          }

  @map.marker_clusterer_icons = [@cluster_icon]

  end

  after do

  end


  it "should spit out the marker clusterer initialization" do
    @map.marker_clusterer = true
    @map.markers << @marker1
    @map.markers << @marker2
    @map.to_js().should include("var markerCluster_Organization = new MarkerClusterer(map, clusterBatch_Organization, {gridSize: 20,maxZoom:10 ,styles: cluster_style_Organization});")

  end

end