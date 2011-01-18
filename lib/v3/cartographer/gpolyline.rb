class Cartographer::GpolyLine
  attr_accessor :name, :color, :points, :map, :weight, :opacity, :markers

  def initialize(options = {})
    @points  = options[:points] || []
    @markers  = options[:markers] || []
    @color   = options[:color] || '#0000ff'
    @map     = options[:map]
    @weight  = options[:width] || options[:weight] || 3
    @opacity = options[:opacity] || 0.5
    @name = "gmap_polyline_" + (options[:name] || options.object_id.to_s)
    @debug = options[:debug] || false
    @options = options
  end

  def width=(w)
    @weight = w
  end

	def to_html
	  script = "<script type='text/javascript'>/*<!CDATA[\n*/"
	  script << to_js
	  script << "//]]></script>"
	  script
  end

  def to_js

    @markers.each { |m| @points.push([m.position.first, m.position.last]) } if @markers.size > 0


    js_point_array_name = "g_polyline_points_for_#{@name}"
    js_GPolyline_opts = "strokeColor: '#{@color}',strokeWeight: #{@weight},strokeOpacity: #{@opacity}"

    script = ""
    script << "/* create the script for polyline #{@name} */\n" if @debug

    script << "  var #{js_point_array_name} = [];\n"
    script << "  /* append points to the polyline */\n" if @debug
    @points.each { |p|
      script << "\n#{js_point_array_name}.push(new google.maps.LatLng(#{p.first}, #{p.last}));"
    }
    script << "	var #{@name} = new google.maps.Polyline({path: #{js_point_array_name},#{js_GPolyline_opts}});"
    script << "  /* Add the polyline to a new overlay on the map */\n" if @debug
    script << "	#{@name}.setMap(#{@map.dom_id});"

    script
  end
end
