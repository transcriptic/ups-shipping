require "nokogiri"

module Shipping
  class Package
    attr_accessor :large
                  :weight
                  :description
                  :monetary_value

    def initialize(options={})
      @large = options[:large]
      @weight = options[:weight]
      @description = options[:description]
      @monetary_value = options[:monetary_value]
    end

    def build(xml)
      xml.Package {
        xml.PackagingType {
          xml.Code "02"
          xml.Description "Customer Supplied"
        }
        xml.Description @description
        xml.ReferenceNumber {
          xml.Code "00"
          xml.Value "Package"
        }
        xml.PackageWeight {
          xml.UnitOfMeasurement
          xml.Weight @weight
        }
        if @large
          xml.LargePackageIndicator
        end
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