require "nokogiri"

module Shipping
  class Address
    ADDRESS_TYPES = %w{residential commercial po_box}
    attr_accessor :address_lines
                  :city
                  :state
                  :zip
                  :country
                  :type

    def initialize(options={})
      @address_lines = options[:address_lines]
      @city = options[:city]
      @state = options[:state]
      @zip = options[:zip]
      @country = options[:country]
      @type = options[:type]
    end

    def build(xml)
      xml.Address {
        xml.AddressLine1 @address_lines[0]
        xml.City @city
        xml.StateProvinceCode @state
        xml.PostalCode @zip
        xml.CountryCode @country
      }
    end

    def to_xml()
      builder = Nokogiri::XML::Builder.new do |xml|
        build(xml)
      end
      builder.to_xml
    end
  end
end