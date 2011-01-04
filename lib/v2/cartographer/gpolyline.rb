class Cartographer::GpolyLine
  attr_accessor :name, :color, :points, :map, :weight, :opacity, :markers
	
  def initialize(options = {})
    @points = []
    options[:markers].each { |m| @points.push([m.position.first, m.position.last]) } if options[:markers]
    options[:points].each { |p| @points.push(p) } if options[:points]
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
    js_point_array_name = "g_polyline_points_for__#{@name}"
    js_GPolyline_opts = "'#{@color}', #{@weight}, #{@opacity}"

    script = ""
    script << "/* create the script for polyline #{@name} */\n" if @debug

    script << "  var #{js_point_array_name} = [];\n"
    script << "  /* append points to the polyline */\n" if @debug
    @points.each { |p|
      script << "\n#{js_point_array_name}.push(new GLatLng(#{p.first}, #{p.last}));"
    }

    script << "  /* Add the polyline to a new overlay on the map */\n" if @debug
    script << "	 #{@map.name}.addOverlay(new GPolyline(#{js_point_array_name}, #{js_GPolyline_opts}));\n"
    script
  end
end
