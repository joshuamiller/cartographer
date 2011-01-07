# The core of the library.  To display a map, you must first create it.  For details, see <tt>#new</tt>.  Then, you can tweak various parameters of map display, detailed below:
#
# +draggable+:: Set to +false+ to disable the user's ability to drag the map around.
# +type+::      The type of map to display.  Can be set to +normal+ (default), +satellite+, or +hybrid+.
# +controls+::  Specify which map controls you would like displayed.  See below for more details.
# +center+::    An array specifying the center point of the map, as [ +latitude+, +longitude+ ]
# +zoom+::      Specify the zoom level of the map.  0 is world view, 17 is closest.
# +debug+::     Set to +true+ to enable debugging output in the Cartographer html (see <tt>#to_html</tt> and <tt>#to_js</tt> for more)
# +marker_mgr+  Set to +true+ to use a MarkerManager utility library to manage markers.  Set markers min_zoom, max_zoom attributes to control the display of markers.
# +current_marker+  Set to variable name of one of the markers to display the marker unfo window on load.
# ==== Collections
#
# +icons+::     A collection of <tt>Cartographer::Gicon</tt> objects to be added to the map.
# +markers+::   A collection of <tt>Cartographer::Gmarker</tt> objects to be added to the map.
# +polylines+:: A collection of <tt>Cartographer::GpolyLine</tt> objects to be added to the map.
#
# ==== Control types
#
# +small+::    A small navigation/zoom control in the upper-left.  Conflicts with +large+ and +zoom+.
# +large+::    A large navigation/zoom control in the upper-left.  Conflicts with +small+ and +zoom+.
# +zoom+::     A zoom control in the the upper-left.  Conflicts with +small+ and +large+.
# +type+::     Buttons to change the map type, shown in the upper-right
# +overview+:: A small, collapsible overview map, shown in the lower-right
# +scale+::    Scale of current map/zoom level, shown in the lower-left
class Cartographer::Gmap
  
  attr_accessor :dom_id, :draggable, :polylines,:type, :controls,
  :markers, :center, :zoom, :icons, :debug, :marker_mgr, :current_marker,:marker_clusterer



  @@window_onload = ""

  # Create a new <tt>Cartographer::Gmap</tt> object.
  #   Cartographer::Gmap.new('map')
  #
  # +dom_id+:: DOM ID of HTML element that will contain the map.
  # +opts+:: Initializing options for the map, includes :draggable,
  # :type, :controls, :center, :zoom, and :debug
  #
  # You can also pass a block to set options, like:
  #
  #   Cartographer::Gmap.new('map') do |m|
  #     m.zoom = 2
  #     m.debug = false
  #   end
  def initialize(dom_id, opts = {}, &block)
    @dom_id = dom_id

    @draggable = opts[:draggable]
    @type      = opts[:type] || :normal
    @controls  = opts[:controls] || [ :zoom ]
    @center    = opts[:center]
    @zoom      = opts[:zoom] || 1
    
    @debug = opts[:debug]
    
    @markers = []
    @polylines = []
    @icons = []

    @move_delay = 2000

    @marker_mgr = opts[:marker_mgr] || false
    @current_marker = opts[:current_marker] || nil

    yield self if block_given?
  end
  
  # Generates the HTML used to display the map. Set
  # :include_onload to false if you don't want the map 
  # loaded in the window.onload function (for example, if
  # you're generating it after an Ajax call).
  #
  # @map.to_html(:include_onload => true)
  def to_html(opts = {:include_onload => true})
    @markers.each { |m| m.map = self } # markers need to know their parent
    @center ||= auto_center

    html = []
    # setup the JS header
    html << "<!-- initialize the google map and your markers -->" if @debug
    html << "<script type=\"text/javascript\">\n/* <![CDATA[ */\n"  
    html << to_js(opts[:include_onload])
    html << "/* ]]> */</script> "
    html << "<!-- end of cartographer code -->" if @debug
    return @debug ? html.join("\n") : html.join.gsub(/\s+/, ' ')
  end
  
  # Generates the JavaScript used to display the map.
  def to_js(include_onload = true)
    html = []
    html << "// define the map-holding variable so we can use it from outside the onload event" if @debug
    html << "var #{@dom_id};\n"
    html << "// define the marker variables for your map so they can be accessed from outside the onload event" if @debug
    @markers.collect do |m| 
      html << "var #{m.name};" unless m.info_window_url
      html << m.header_js
    end
    
    html << "// define the map-initializing function for the onload event" if @debug
    html << "function initialize_gmap_#{@dom_id}() {
if (!GBrowserIsCompatible()) return false;
#{@dom_id} = new GMap2(document.getElementById(\"#{@dom_id}\"));"

    html << "  #{@dom_id}.disableDragging();" if @draggable == false
    
    if( @zoom == :bound )
      sw_ne = self.bounding_points
      html << "#{@dom_id}.setCenter(new GLatLng(0,0),0);\n"
      html << "var #{@dom_id}_bounds = new GLatLngBounds(new GLatLng(#{sw_ne[0][0]}, #{sw_ne[0][1]}), new GLatLng(#{sw_ne[1][0]}, #{sw_ne[1][1]}));\n"
      html << "#{@dom_id}.setCenter(#{@dom_id}_bounds.getCenter());\n"
      html << "#{@dom_id}.setZoom(#{@dom_id}.getBoundsZoomLevel(#{@dom_id}_bounds));\n"
    else
      html << "#{@dom_id}.setCenter(new GLatLng(#{@center[0]}, #{@center[1]}), #{@zoom});\n"
    end

    html << "  // set the default map type" if @debug 
    html << "  #{@dom_id}.setMapType(G_#{@type.to_s.upcase}_MAP);\n"

    html << "  // define which controls the user can use." if @debug 
   @controls.each do |control|
      html << "  #{@dom_id}.addControl(new " + case control
        when :large, :small, :overview
          "G#{control.to_s.capitalize}MapControl"
        when :scale
          "GScaleControl"
        when :type
          "GMapTypeControl"
        when :zoom
          "GSmallZoomControl"
        when :overview
          "GOverviewMapControl"
      end + "());"
    end

    html << "\n  // create markers from the @markers array" if @debug
    html << "\n setupMarkers();"   

    # trigger marker info window is current_marker is defined
    (html << "GEvent.trigger(#{@current_marker}, \"click\");\n") unless @current_marker.nil?

    html << "  // create polylines from the @polylines array" if @debug
    @polylines.each { |pl| html << pl.to_js }
    
    # ending the gmap_#{name} function
    html << "}\n"
    
    html << "function setupMarkers(){"
    
    # Render the Icons
    html << "  // create icons from the @icons array" if @debug
    @icons.each { |i| html << i.to_js }
  
    html << "mgr = new MarkerManager(#{@dom_id});" if @marker_mgr
    hmarkers = Hash.new 
    hmarkers_no_zoom =[]
    @markers.each do |m|
      if (m.min_zoom.nil?) || (m.min_zoom == '')
        hmarkers_no_zoom << m
      else
        hmarkers[m.min_zoom] = [] unless hmarkers[m.min_zoom]
        hmarkers[m.min_zoom] << m
      end
    end   
    
    hmarkers.each do |zoom, markers|
      html << "var batch#{zoom} = [];"
      markers.each do |m|
        html << m.to_js(@marker_mgr)
        html << "batch#{zoom}.push(#{m.name});"
      end      
      html << "mgr.addMarkers(batch#{zoom}, #{zoom});"
    end
    
    if (hmarkers_no_zoom.size > 0)
      html << "var batch = [];"
      hmarkers_no_zoom.each do |m|      
        html << m.to_js(@marker_mgr)
        html << "batch.push(#{m.name});" if @marker_mgr
      end
      html << "mgr.addMarkers(batch, 0);" if @marker_mgr
    end
    html << "mgr.refresh();\n" if @marker_mgr
    html << "}"
        
    html << "  // Dynamically attach to the window.onload event while still allowing for your existing onload events." if @debug

    # todo: allow for onload to happen before, or after, the existing onload events, like :before or :after
    if include_onload
      # all these functions need to be added to window.onload due to an IE bug
      @@window_onload << "gmap_#{@dom_id}();\n"

      html << "
if (typeof window.onload != 'function')
  window.onload = initialize_gmap_#{@dom_id};
else {
  old_before_cartographer_#{@dom_id} = window.onload;
  window.onload = function() { 
    old_before_cartographer_#{@dom_id}(); 
    initialize_gmap_#{@dom_id}(); 
  }
}"      
    else #include_onload == false
      html << "initialize_gmap_#{@dom_id}();"
    end
    return @debug ? html.join("\n") : html.join.gsub(/\s+/, ' ')
  end
  
  # Doesn't get called anywhere and the js method it calls doesn't seem to exist.  Is this used?
  def follow_route_link(link_text = 'Follow route', options = {})#:nodoc:
    anchor = '#' + (options[:anchor].to_s || '')
    move_delay = (options[:delay] || @move_delay)
    "<a href='#{anchor}' onclick='follow_gmap_route_#{@dom_id}_function(#{move_delay}); return false;'>#{link_text}</a>"
  end    

  # Shortcut for <tt>#to_html(true)</tt>
  def to_s
    self.to_html
  end
  
  # Returns the coordinates of the center of the bounding box that contains all of the map's markers.
  def auto_center
  	return [45,0] unless @markers
      return @markers.first.position if @markers.length == 1
  	maxlat, minlat, maxlon, minlon = Float::MIN, Float::MAX, Float::MIN, Float::MAX
  	@markers.each do |marker| 
  		if marker.lat > maxlat then maxlat = marker.lat end
  		if marker.lat < minlat then minlat = marker.lat end
  		if marker.lon > maxlon then maxlon = marker.lon end 
  		if marker.lon < minlon then minlon = marker.lon end
  	end
  	return [((maxlat+minlat)/2), ((maxlon+minlon)/2)]
  end
  
  def bounding_points
  
    maxlat, minlat, maxlon, minlon = nil, nil, nil, nil
  
    @markers.each do |marker| 
  		if ! maxlat || marker.lat > maxlat then maxlat = marker.lat end
  		if ! minlat || marker.lat < minlat then minlat = marker.lat end
  		if ! maxlon || marker.lon > maxlon then maxlon = marker.lon end 
  		if ! minlon || marker.lon < minlon then minlon = marker.lon end
  	end
  
    @polylines.each do |line|
      line.points.each do |point|
  		if ! maxlat || point[0] > maxlat then maxlat = point[0] end
  		if ! minlat || point[0] < minlat then minlat = point[0] end
  		if ! maxlon || point[1] > maxlon then maxlon = point[1] end 
  		if ! minlon || point[1] < minlon then minlon = point[1] end
  	  end
    end

  	return [[minlat, minlon], [maxlat, maxlon]]
  end
end
