# Defines a map header.  Insert the Google Map script dynamically:
#   <%= Cartographer::Header.header_for(request) %>
#
# or by specifying the hostname:
#   <%= Cartographer::Header.new('example.com').to_s %>
class Cartographer::Header
  #include Reloadable
  
  attr_accessor :uri
  @@keys = {} #place holder for config options

  def version
    CARTOGRAPHER_GMAP_VERSION
  end
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
    html << "<script type=\"text/javascript\" src=\"http://maps.google.com/maps/api/js?sensor=true\"></script>"
    html << "<script src='http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markermanager/src/markermanager_packed.js' type='text/javascript'></script>"
    html << "<script src='http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/markerclusterer_packed.js' type='text/javascript'></script>"
       
    return html
  end

  # Shortcut for <tt>Cartographer::Header.new(request.env["HTTP_HOST"]).to_s</tt>.
  def self.header_for(request = {}, version=CARTOGRAPHER_GMAP_VERSION) #request and version number are not required anymore and should be removed soon
    mh = self.new
    mh.to_s
  end

end