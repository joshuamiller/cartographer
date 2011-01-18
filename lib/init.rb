

CARTOGRAPHER_GMAP_VERSION = 2 if !defined?(CARTOGRAPHER_GMAP_VERSION) # By default we make cartographer to use Google maps v2 for backward compatibility

if CARTOGRAPHER_GMAP_VERSION == 2 #Support Legacy Cartographer apis
  require 'v2/cartographer'
  require 'v2/cartographer/gmap'
  require 'v2/cartographer/header'
  require 'v2/cartographer/gicon'
  require 'v2/cartographer/gmarker'
  require 'v2/geocode'

  Cartographer
  Cartographer::Gmap
  Cartographer::Header
  Cartographer::Geocode

  ActionController::Base.send :include, Cartographer
  ActiveRecord::Base.send     :include, Cartographer
  ActionView::Base.send       :include, Cartographer

end

if CARTOGRAPHER_GMAP_VERSION == 3
  require 'v3/cartographer'
  require 'v3/cartographer/header'
  require 'v3/cartographer/gmap'
  require 'v3/cartographer/gicon'
  require 'v3/cartographer/gmarker'
  require 'v3/cartographer/infowindow'
  require 'v3/cartographer/cluster_icon'
  require 'v3/cartographer/gpolyline'

  Cartographer
  Cartographer::Header
  Cartographer::Gmap

  ActionController::Base.send :include, Cartographer if defined?(ActionController)
  ActiveRecord::Base.send     :include, Cartographer if defined?(ActiveRecord)
  ActionView::Base.send       :include, Cartographer if defined?(ActionView)
end