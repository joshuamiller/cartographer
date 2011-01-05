class Cartographer::Gicon
  attr_accessor :name, 
    :width, :height, 
    :shadow_width, :shadow_height, 
    :image_url, :shadow_url, 
    :anchor_x, :anchor_y,
    :info_anchor_x, :info_anchor_y

  def initialize( options = {} )
    @name	      = options[:name]		|| 'icon'
    @image_url      = options[:image_url]     || 'http://www.google.com/mapfiles/marker.png'
    @shadow_url     = options[:shadow_url]    || 'http://www.google.com/mapfiles/shadow50.png'
    @width	      = options[:width]		|| 20
    @height	      = options[:height]	|| 34
    @shadow_width   = options[:shadow_width]  || 37 #to be deprecated
    @shadow_height  = options[:shadow_height] || 34 #to be deprecated
    @anchor_x	      = options[:anchor_x]	|| 6
    @anchor_y	      = options[:anchor_y]	|| 20
    @info_anchor_x  = options[:anchor_x]	|| 5 #to be deprecated
    @info_anchor_y  = options[:anchor_y]	|| 1 #to be deprecated
  end	

  # turn the object into valid js
  def to_js
    "var #{@name}		= new google.maps.MarkerImage(
      \"#{@image_url}\",
      google.maps.Size(#{@width},#{@height}),
      google.maps.Point(0,0),
      google.maps.Point(#{@anchor_x},#{@anchor_y}),
      google.maps.Size(#{@width},#{@height})
    );
    "


  end

  def to_html
    "<script type='text/javascript'>
     #{to_js}
     </script>\n"
  end
end
