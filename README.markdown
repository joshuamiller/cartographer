Cartographer
============
  Cartographer generates painless Google Maps for your Rails application. It supports **Google Maps API v3** & comes with all the goodies (MarkerManager && MarkerClusterer) for managing large number of markers with least effort.


### Features
* Support for Google Maps v3 and v2
* Drop-in-replacement for older version of cartographer (which only worked with google maps v2)
* Support for MarkerManager v3
* Support for MarkerClusterer v3
* You can easily define custom icons for cluster
* Works with Rails 3+ and also works on older rails versions to provide backward compatibility

### How to use?

if you want to use google maps v3, set this constant in first line of environment.rb (this constant should be set before the plugin is loaded)
<pre><code>
 CARTOGRAPHER_GMAP_VERSION = 3
</code></pre>

In your controller...
<pre><code>
  @map = Cartographer::Gmap.new( 'map' )
  @map.zoom = :bound
  marker1 = Cartographer::Gmarker.new(:name=> "taj_mahal", :marker_type => "Building",
              :position => [27.173006,78.042086],
              :info_window_url => "/url_for_info_content")
  marker2 = Cartographer::Gmarker.new(:name=> "raj_bhawan", :marker_type => "Building",
              :position => [28.614309,77.201353],
              :info_window_url => "/url_for_info_content")

  @map.markers << marker1
  @map.markers << marker2
</code></pre>

In your view...
<pre><code>
  # for Rails 3+ you need to make use of 'raw'
  &lt;%= raw Cartographer::Header.new.to_s %&gt;
  &lt;%= raw @map.to_html %&gt;
</code></pre>

Here is another example with custom icons + clustering
<pre><code>
  #controller code
  @map = Cartographer::Gmap.new( 'map' )
  @map.zoom = :bound
  @map.marker_clusterer = true

  icon_building = Cartographer::Gicon.new(:name => "building_icon",
          :image_url => '/images/icon.gif',
          :width => 31,
          :height => 24,
          :anchor_x => 0,
          :anchor_y => 20,
          :info_anchor_x => 5,
          :info_anchor_x => 1)

  building_cluster_icon = Cartographer::ClusterIcon.new({:marker_type => "Building"})
  #Clustering requires various variant of icon for different grouping/zoom level
  #push first variant
  building_cluster_icon << {
                 :url => '/images/small_icon.gif',
                 :height => 33,
                 :width => 58,
                 :opt_anchor => [10, 0],
                 :opt_textColor => 'black'
               }
  #push second variant
  building_cluster_icon << {
                 :url => '/images/bigger_icon.gif',
                 :height => 63,
                  :width => 98,
                 :opt_anchor => [20, 0],
                 :opt_textColor => 'black'
               }

  #push third variant
  building_cluster_icon << {
                 :url => '/images/biggest_icon.gif',
                 :height => 73,
                 :width => 118,
                 :opt_anchor => [26, 0],
                 :opt_textColor => 'black'
               }

  @map.marker_clusterer_icons = [building_cluster_icon]


  marker1 = Cartographer::Gmarker.new(:name=> "taj_mahal", :marker_type => "Building",
              :position => [27.173006,78.042086],
              :info_window_url => "/url_for_info_content",
              :icon => icon_building)
  marker2 = Cartographer::Gmarker.new(:name=> "raj_bhawan", :marker_type => "Building",
              :position => [28.614309,77.201353],
              :info_window_url => "/url_for_info_content",
              :icon => icon_building)

  @map.markers << marker1
  @map.markers << marker2
</code></pre>

Install
-------
<pre><code>
  cd rails_app
  git clone git://github.com/parolkar/cartographer.git vendor/plugins/cartographer
</code></pre>


History:

Original Rails blog announcement of 2005 is at http://download.rubyonrails.com/2005/8/30/cartographer-effortless-google-maps-in-rails

Copyright (c) 2011 Abhishek Parolkar & Joshua Miller, released under the MIT license
