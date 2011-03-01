class Cartographer::Gad
  attr_accessor :format, :div, :position, :map, :visible, :publisher_id

  # Options for displaying AdSense Ads (http://code.google.com/apis/maps/documentation/javascript/advertising.html#AdUnitFormats)
  # => format: LEADERBOARD, BANNER, HALF_BANNER, SKYSCRAPER, WIDE_SKYSCRAPER, VERTICAL_BANNER, BUTTON, SMALL_SQUARE, SQUARE, SMALL_RECTANGLE, MEDIUM_RECTANGLE, LARGE_RECTANGLE
  
  # Options for the position of the Ad (http://code.google.com/apis/maps/documentation/javascript/controls.html#ControlPositioning)
  # => position: TOP_CENTER, TOP_LEFT, TOP_RIGHT, LEFT_TOP, RIGHT_TOP, LEFT_CENTER, RIGHT_CENTER, LEFT_BOTTOM, RIGHT_BOTTOM, BOTTOM_CENTER, BOTTOM_LEFT, BOTTOM_RIGHT

  def initialize( options = {} )
    @format      = options[:format]   || 'HALF_BANNER'
    @div         = options[:div] || 'div'
    @position    = options[:position]     || 'TOP'
    @map         = options[:map]    || 'map'
    @visible     = options[:visible]    || true
    @publisher_id = options[:publisher_id]  || 'YOUR_PUBLISHER_ID'
  end 


  # turn the object into valid js
  def to_js
    "var adUnit;
     var adUnitDiv	= document.createElement('div');
     var adUnitOptions = {
       format: google.maps.adsense.AdFormat.#{@format},
       position: google.maps.ControlPosition.#{@position},
       map: #{@map},
       visible: #{@visible},
       publisherId: '#{@publisher_id}'
     };
     adUnit = new google.maps.adsense.AdUnit(adUnitDiv, adUnitOptions);
   "
  end
  
end