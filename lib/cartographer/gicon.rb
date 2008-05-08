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
    @shadow_width   = options[:shadow_width]  || 37
    @shadow_height  = options[:shadow_height] || 34
    @anchor_x	      = options[:anchor_x]	|| 6
    @anchor_y	      = options[:anchor_y]	|| 20
    @info_anchor_x  = options[:anchor_x]	|| 5
    @info_anchor_y  = options[:anchor_y]	|| 1
  end	

  # turn the object into valid js
  def to_js
    "var #{@name}		= new GIcon();
    #{@name}.image		= \"#{@image_url}\";
    #{@name}.shadow		= \"#{@shadow_url}\";
    #{@name}.iconSize         = new GSize(#{@width}, #{@height});
    #{@name}.shadowSize       = new GSize(#{@shadow_width}, #{@shadow_height});
    #{@name}.iconAnchor       = new GPoint(#{@anchor_x}, #{@anchor_y});
    #{@name}.infoWindowAnchor = new GPoint(#{@info_anchor_x}, #{@info_anchor_y});
    "
  end

  def to_html
    "<script type='text/javascript'>
     #{to_js}
     </script>\n"
  end
end
