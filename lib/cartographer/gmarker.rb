class Cartographer::Gmarker
  #include Reloadable
  attr_accessor :name, :icon, :position, :click, :info_window, :info_window_url, :map, :min_zoom, :max_zoom, :dblclick

  def initialize(options = {})
    @name = options[:name] || "marker"
    @position = options[:position] || [0, 0]
    @icon = options[:icon] || :normal
    @click = options[:click] # javascript to execute on click
    @dblclick = options[:dblclick] # javascript to execute on double click
    @info_window = options[:info_window] # html to pop up on click
    @info_window_url = options[:info_window_url] # html to pop up on click fetched from a URL
    @map = options[:map]
    
    # inherit our 'debug' settings from the map, if there is one, and it's in debug
    # you can also just debug this marker, if you like, or debug the map and
    # not this marker.
    @debug = options[:debug] || (@map.respond_to?(:debug) ? @map.debug : false)
  end

  # Return the latitude of the marker.
  def lat
    @position[0]
  end

  # return the longitude of the marker.
  def lon
    @position[1]
  end

  def header_js
    script = []
    return if @info_window_url
    if @info_window.kind_of?Array
      script << "  var #{@name}_infoTabs = ["
      script << @info_window.inject([]) { |tabs,tab|
        tabs << "   new GInfoWindowTab(\"#{tab[:title]}\",\"#{tab[:html]}\")"
      }.join(",\n")
      script << "  ]\n"
      script << "function #{@name}_infowindow_function(){
  #{@name}.openInfoWindowTabsHtml(#{@name}_infoTabs);
}\n"
    else        
      script << "function #{@name}_infowindow_function(){
  #{@name}.openInfoWindowHtml(\"#{@info_window}\")
}\n"
    end
  end

  def to_js(marker_mgr)
    script = []
    script << "// Set up the pre-defined marker" if @debug
    script << "#{@name} = new GMarker(new GLatLng(#{@position[0]}, #{@position[1]}), #{@icon.name});\n"

    if @click
      script << "// Create the listener for your custom click event" if @debug
      script << "GEvent.addListener(#{name}, \"click\", function() {#{@click}});\n"
    elsif @info_window_url
      script << "GEvent.addListener(#{name}, \"click\", function() { 
          GDownloadUrl(\"#{info_window_url}\", function(html) { 
            #{@name}.openInfoWindowHtml(html); 
          }); 
        });\n"
    else
      script << "GEvent.addListener(#{name}, \"click\", function() {#{name}_infowindow_function()});\n"
    end

    if @dblclick
      script << "GEvent.addListener(#{name}, \"dblclick\", function() {#{@dblclick}});\n"
    end

    script << "  // Add the marker to a new overlay on the map" if @debug
    script << "  #{@map.dom_id}.addOverlay(#{@name});\n" unless marker_mgr
    return @debug? script.join("\n  ") : script.join.gsub(/\s+/, ' ')
  end

  def infowindow_link(link_text = 'Show on map', options = {})
    anchor = '#' + options[:anchor].to_s
    "<a href='#{anchor}' onClick='#{@name}_infowindow_function(); return false;'>#{link_text}</a>"
  end
	
  def zoom_link(link_text = 'Zoom on map')
    "<a href='#' onClick='#{@map.dom_id}.setCenter(new GLatLng(#{@position.first}, #{@position.last}), 8); return false;'>#{link_text}</a>"
  end
end
