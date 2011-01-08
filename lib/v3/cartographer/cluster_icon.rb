require "json"
class Cartographer::ClusterIcon < Array
  attr_accessor :marker_type,:icon_elements


  def initialize( options = {} )
    @marker_type	      = options[:marker_type]		|| 'marker_type_icon'
    @icon_elements = options[:icon_elements] || []
    super(@icon_elements)
  end

  def var_name
    "cluster_style_#{@marker_type}"
  end
  # turn the object into valid js
  def to_js
    "var #{var_name} = [#{self.collect{|i| i.to_json}.join(",")}];"
  end

  def to_html
    "<script type='text/javascript'>
     #{to_js}
     </script>\n"
  end
end
