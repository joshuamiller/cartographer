class Cartographer::Gmarker
  #include Reloadable
  attr_accessor :name, :marker_type, :highlight, :icon, :position, :click, :info_window, :info_window_url, :map, :min_zoom, :max_zoom, :dblclick, :draggable, :label

  def initialize(options = {})
    @name = options[:name] || "marker"
    @marker_type = options[:marker_type] || nil
    @position = options[:position] || [0, 0]
    @icon = options[:icon] || Cartographer::Gicon.new
    @click = options[:click] # javascript to execute on click
    @dblclick = options[:dblclick] # javascript to execute on double click
    @info_window = options[:info_window] # html to pop up on click
    @info_window_url = options[:info_window_url] # html to pop up on click fetched from a URL
    @map = options[:map]
    @highlight = options[:highlight] || false
    @draggable = options[:draggable] || false
    @label = options[:label] || nil
  
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
      # this probably won't work with API v3 since it does not support tabs.
      script << "  var #{@name}_infoTabs = ["
      script << @info_window.inject([]) { |tabs,tab|
        tabs << "   new GInfoWindowTab(\"#{tab[:title]}\",\"#{tab[:html]}\")"
      }.join(",\n")
      script << "  ]\n"
      script << "function #{@name}_infowindow_function(){
  #{@name}.openInfoWindowTabsHtml(#{@name}_infoTabs);
}\n"
    else        
      # using API V3 of infowindow (PG)
      script << "var #{@name}_infowindow = new google.maps.InfoWindow({
          content: \"#{escape_javascript(@info_window)}\"
      });"

      script << "function #{@name}_infowindow_function(){
        #{@name}_infowindow.open(#{@map.dom_id},#{@name});
      }\n"
    end
  end

  def to_js(marker_mgr_flag = false, marker_clusterer_flag = false)
    marker_mgr = marker_mgr_flag
    marker_clusterer = marker_clusterer_flag
    script = []
    script << "// Set up the pre-defined marker" if @debug
    if @label
      label_options = []
      @label.each do |key, value|
        if :anchor == key
          label_options << "label#{key.to_s.capitalize}:#{value.to_s}"
        else
          label_options << "label#{key.to_s.capitalize}:'#{value.to_s}'"
        end
      end
      script << "#{@name} = new MarkerWithLabel({map: null, position: new google.maps.LatLng(#{@position[0]}, #{@position[1]}), draggable: #{@draggable}, icon: #{@icon.name}, #{@icon.flat ? 'flat: true' : "shadow: #{@icon.name}_shadow"},#{label_options.join(',')}});\n"
    else
      script << "#{@name} = new google.maps.Marker({map: null, position: new google.maps.LatLng(#{@position[0]}, #{@position[1]}), draggable: #{@draggable}, icon: #{@icon.name}, #{@icon.flat ? 'flat: true' : "shadow: #{@icon.name}_shadow"}}); \n"
    end

    if @click
      script << "// Create the listener for your custom click event" if @debug
      script << "google.maps.event.addListener(#{name}, 'click', function() {#{@click}});\n"
    elsif @info_window_url
      script << "google.maps.event.addListener(#{name}, \"click\", function() {
          #{@map.shared_info_window.name}.close();
          var fetched_content = cartographer_ajax_fetch_url(\"#{info_window_url}\");
          #{@map.shared_info_window.name}.setContent(fetched_content);
          #{@map.shared_info_window.name}.open(#{@map.dom_id},#{name});
        });\n"
    else
      script << "google.maps.event.addListener(#{name}, \"click\", function() {#{name}_infowindow_function()});\n"
    end

    if @dblclick
      script << "google.maps.event.addListener(#{name}, 'dblclick', function() {#{@dblclick}});\n"
    end

    script << "  // Add the marker to a new overlay on the map" if @debug
    script << "  #{@name}.setMap(#{@map.dom_id});\n" if self.highlight || (!marker_mgr && !marker_clusterer)
    return @debug? script.join("\n  ") : script.join.gsub(/\s+/, ' ')
  end

  def infowindow_link(link_text = 'Show on map', options = {})
    anchor = '#' + options[:anchor].to_s
    "<a href='#{anchor}' onClick='#{@name}_infowindow_function(); return false;'>#{link_text}</a>"
  end
	
  def zoom_link(link_text = 'Zoom on map')
    "<a href='#' onClick='#{@map.dom_id}.setCenter(new GLatLng(#{@position.first}, #{@position.last}), 8); return false;'>#{link_text}</a>"
  end
  
  #Escape string to be used in JavaScript. Lifted from rails.
  def escape_javascript(javascript)
    javascript.gsub(/\r\n|\n|\r/, "\\n").gsub("\"") { |m| "\\#{m}" }
  end

end
