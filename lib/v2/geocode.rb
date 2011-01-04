require 'net/http'
require 'csv'
require 'xmlrpc/client'

module Cartographer::Geocode

  module GeocoderUS
    def geocode(input)
      server = XMLRPC::Client.new2('http://rpc.geocoder.us/service/xmlrpc') 
      result = server.call2('geocode', "#{input}")

      return { :score => 0 } if result.nil? || result[0].nil?
    
      return {
        :latitude => result[1][0]['lat'],
        :longitude => result[1][0]['long'],
        :description => nil,
        :original_address => input,
        :score => nil,
        :street_number => street_number,
        :prefix => prefix,
        :street_name => street_name,
        :street_type => street_type,
        :suffix => suffix,
        :city => city,
        :state => state,
        :zipcode => zipcode
      }
    end
  end

  module Ontok
    def geocode(input)
      req = Net::HTTP.get_response(URI.parse('http://www.ontok.com/geocode/rest?key=key&fmt=CSV&q=' + input.gsub(/\s/, '+')))
 
      #  float Longitude
      #  float Latitude
      #  string description - what was matched (will have some spaces removed)
      #  string q - the original request
      #  int score - the quality of the match:
      #      5 - perfect match, no ambiguity
      #      4 - good match, ambiguity encountered
      #      3 - ok match, spelling correction applied
      #      2 - street number rounding applied
      #      1 - no street found
      #      0 - no match found, (0.0, 0.0) returned
      #  string StreetNumber
      #  string Prefix
      #  string StreetName (* from the original input)
      #  string StreetType
      #  string Suffix
      #  string City
      #  string State
      #  string Zipcode
 
      longitude, latitude, description, original_address, score, street_number, prefix, street_name, street_type, suffix, city, state, zipcode = CSV.parse(req.body).first
 
      return {
        :latitude => latitude,
        :longitude => longitude,
        :description => description,
        :original_address => original_address,
        :score => score,
        :street_number => street_number,
        :prefix => prefix,
        :street_name => street_name,
        :street_type => street_type,
        :suffix => suffix,
        :city => city,
        :state => state,
        :zipcode => zipcode
      }
    end
  end
end