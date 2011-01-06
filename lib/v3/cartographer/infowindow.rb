class Cartographer::InfoWindow
  attr_accessor :name,:content,:disableAutoPan,:maxWidth,:pixelOffset,:position,:zIndex

  #TODO: Implement all options
  def initialize( options = {} )
    @name	      = options[:name]		|| 'infowindow'
    @content      = options[:content]     || ' '

  end

  # turn the object into valid js
  def to_js
    "var #{@name} = new google.maps.InfoWindow({
      content: \"#{@content}\"
    });
    "


  end

  def to_html
    "<script type='text/javascript'>
     #{to_js}
     </script>\n"
  end
end
