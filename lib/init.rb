# wondering what the "right" way to do this is...
require 'cartographer'
require 'cartographer/gmap'
require 'cartographer/header'
require 'geocode'

Cartographer
Cartographer::Gmap
Cartographer::Header
Cartographer::Geocode

ActionController::Base.send :include, Cartographer
ActiveRecord::Base.send     :include, Cartographer
ActionView::Base.send       :include, Cartographer