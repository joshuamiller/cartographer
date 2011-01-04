# Defines a map header.  Insert the Google Map script dynamically:
#   <%= Cartographer::Header.header_for(request) %>
#
# or by specifying the hostname:
#   <%= Cartographer::Header.new('example.com').to_s %>
class Cartographer::Header
  #include Reloadable
  
  attr_accessor :uri, :version
  @@keys = YAML.load(File.new("#{RAILS_ROOT}/config/cartographer-config.yml"))
  @version = 2

  # not called anywhere... remove?
  def header_keys #:nodoc:
    @@keys  
  end
  
  # Checks whether the specified URI has a matching API key in the <tt>cartographer-config.yml</tt>.
  def has_key?(uri)
    @@keys.has_key?(uri)
  end
  
  # Returns the API key for the specified URI.
  def value_for(uri)
    @@keys[uri]
  end
  
  # Returns the JavaScript header with the appropriate API key/version.
  def to_s
    # initialize the html with the IE polyline VML code
    html = "\n<!--[if IE]>\n<style type=\"text/css\">v\\:* { behavior:url(#default#VML); }</style>\n<![endif]-->"

    # check if our URI is in the keys yml file and show the appropriate script
    if has_key?(@uri)
      html << "<script src='http://maps.google.com/maps?file=api&amp;v=#{version}&amp;key=#{value_for(@uri)}' type='text/javascript'></script>"
      html << "<script src='http://gmaps-utility-library.googlecode.com/svn/trunk/markermanager/1.1/src/markermanager_packed.js' type='text/javascript'></script>"
    else
      html << "<!-- Cartographer Header goes here.  The URI [#{@uri}] couldn't be found in your 
      cartographer-config.yml file.  Please add it and your map initialization code will
      appear here. Otherwise, perhaps your YML is misformed -->"
    end
    return html
  end

  # Shortcut for <tt>Cartographer::Header.new(request.env["HTTP_HOST"]).to_s</tt>.
  def self.header_for(request, version=2)
    mh = self.new
    mh.version = version
    mh.uri = request.env["HTTP_HOST"]
    mh.to_s
  end
end