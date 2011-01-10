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
  marker1 = Cartographer::Gmarker.new(:name=&gt; &quot;taj_mahal&quot;, :marker_type =&gt; &quot;Building&quot;,
              :position =&gt; [27.173006,78.042086],
              :info_window_url =&gt; &quot;/url_for_info_content&quot;)
  marker2 = Cartographer::Gmarker.new(:name=&gt; &quot;raj_bhawan&quot;, :marker_type =&gt; &quot;Building&quot;,
              :position =&gt; [28.614309,77.201353],
              :info_window_url =&gt; &quot;/url_for_info_content&quot;)

  @map.markers &lt;&lt; marker1
  @map.markers &lt;&lt; marker2
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

  icon_building = Cartographer::Gicon.new(:name =&gt; &quot;building_icon&quot;,
          :image_url =&gt; '/images/icon.gif',
          :width =&gt; 31,
          :height =&gt; 24,
          :anchor_x =&gt; 0,
          :anchor_y =&gt; 20,
          :info_anchor_x =&gt; 5,
          :info_anchor_x =&gt; 1)

  building_cluster_icon = Cartographer::ClusterIcon.new({:marker_type =&gt; &quot;Building&quot;})
  #Clustering requires various variant of icon for different grouping/zoom level
  #push first variant
  building_cluster_icon &lt;&lt; {
                 :url =&gt; '/images/small_icon.gif',
                 :height =&gt; 33,
                 :width =&gt; 58,
                 :opt_anchor =&gt; [10, 0],
                 :opt_textColor =&gt; 'black'
               }
  #push second variant
  building_cluster_icon &lt;&lt; {
                 :url =&gt; '/images/bigger_icon.gif',
                 :height =&gt; 63,
                  :width =&gt; 98,
                 :opt_anchor =&gt; [20, 0],
                 :opt_textColor =&gt; 'black'
               }

  #push third variant
  building_cluster_icon &lt;&lt; {
                 :url =&gt; '/images/biggest_icon.gif',
                 :height =&gt; 73,
                 :width =&gt; 118,
                 :opt_anchor =&gt; [26, 0],
                 :opt_textColor =&gt; 'black'
               }

  @map.marker_clusterer_icons = [building_cluster_icon]


  marker1 = Cartographer::Gmarker.new(:name=&gt; &quot;taj_mahal&quot;, :marker_type =&gt; &quot;Building&quot;,
              :position =&gt; [27.173006,78.042086],
              :info_window_url =&gt; &quot;/url_for_info_content&quot;,
              :icon =&gt; icon_building)
  marker2 = Cartographer::Gmarker.new(:name=&gt; &quot;raj_bhawan&quot;, :marker_type =&gt; &quot;Building&quot;,
              :position =&gt; [28.614309,77.201353],
              :info_window_url =&gt; &quot;/url_for_info_content&quot;,
              :icon =&gt; icon_building)

  @map.markers &lt;&lt; marker1
  @map.markers &lt;&lt; marker2
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
