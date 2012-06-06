require "nokogiri"
require "httparty"
require 'ups_shipping/address'
require 'ups_shipping/organization'
require 'ups_shipping/package'
require 'ups_shipping/pickup'

module Shipping

  VERSION = '1.0.1'

  class UPS

    TEST_URL = "https://wwwcie.ups.com"
    LIVE_URL = "https://onlinetools.ups.com"

    class Http
      include HTTParty
      base_uri LIVE_URL

      def initialize(access_request, options={})
        @access_request = access_request

        if (options[:test])
          self.class.base_uri TEST_URL
        end
      end

      def commit(url, request)
        request = @access_request + request
        self.class.post(url, :body => request).parsed_response
      end
    end

    def initialize(user, password, license, options={})
      @options = options
      @shipper = options[:shipper]
      @access_request = access_request(user, password, license)
      @http = Http.new(@access_request, :test => @options[:test])

      @services = {
        "01" => "Next Day Air",
        "02" => "2nd Day Air",
        "03" => "Ground",
        "07" => "Express",
        "08" => "Expedited",
        "11" => "UPS Standard",
        "12" => "3 Day Select",
        "13" => "Next Day Air Saver",
        "14" => "Next Day Air Early AM",
        "54" => "Express Plus",
        "59" => "2nd Day Air A.M.",
        "65" => "UPS Saver",
        "82" => "UPS Today Standard",
        "83" => "UPS Today Dedicated Courier",
        "84" => "UPS Today Intercity",
        "85" => "UPS Today Express",
        "86" => "UPS Today Express Saver"
      }
    end

    def validate_address(address)
      validate_request = Nokogiri::XML::Builder.new do |xml|
        xml.AddressValidationRequest {
          xml.Request {
            xml.TransactionReference {
              xml.CustomerContext
              xml.XpciVersion 1.0001
            }
            xml.RequestAction "XAV"
            xml.RequestOption "3"
          }
          xml.MaximumListSize 3
          xml.AddressKeyFormat {
            xml.AddressLine address.address_lines[0]
            xml.PoliticalDivision2 address.city
            xml.PoliticalDivision1 address.state
            xml.PostcodePrimaryLow address.zip
            xml.CountryCode address.country
          }
        }
      end
      @http.commit("/ups.app/xml/XAV", validate_request.to_xml)
    end

    def find_rates(package, origin, destination, options={})
      rate_request = Nokogiri::XML::Builder.new do |xml|
        xml.RatingServiceSelectionRequest {
          xml.Request {
            xml.RequestAction "Rate"
            xml.RequestOption "Rate"
          }
          if options[:pickup]
            @options[:pickup].build_type(xml)
          end
          @shipper.build(xml, "Shipper")
          destination.build(xml, "ShipTo")
          origin.build(xml, "ShipFrom")
          xml.PaymentInformation {
            xml.Prepaid {
              xml.BillShipper {
                xml.AccountNumber "Ship Number"
              }
            }
          }
          package.build(xml)
        }
      end
      @http.commit("/ups.app/xml/Rate", rate_request.to_xml)
    end

    def request_shipment(package, origin, destination, service, options={})
      shipment_request = Nokogiri::XML::Builder.new do |xml|
        xml.ShipmentConfirmRequest {
          xml.Request {
            xml.RequestAction "ShipConfirm"
            xml.RequestOptions "validate"
          }
          if options[:label]
            xml.LabelSpecification {
              xml.LabelPrintMethod {
                xml.Code "GIF"
                xml.Description "gif file"
              }
              xml.HTTPUserAgent "Mozilla/4.5"
              xml.LabelImageFormat {
                xml.Code "GIF"
                xml.Description "gif"
              }
            }
          end
          @shipper.build(xml, "Shipper")
          destination.build(xml, "ShipTo")
          origin.build(xml, "ShipFrom")
          xml.PaymentInformation {
            xml.Prepaid {
              xml.BillShipper {
                xml.AccountNumber "Ship Number"
              }
            }
          }
          xml.Service {
            xml.Code service
            xml.Description @services[service]
          }
          package.build(xml)
        }
      end
      @http.commit("/ups.app/xml/ShipConfirm", shipment_request.to_xml)
    end

    def cancel_shipment(shipment_id)
      cancel_request = Nokogiri::XML::Builder.new do |xml|
        xml.VoidShipmentRequest {
          xml.Request {
            xml.RequestAction "1"
            xml.RequestOption "1"
          }
          xml.ShipmentIdentificationNumber shipment_id
        }
      end
      @http.commit("/ups.app/xml/Void", cancel_request.to_xml)
    end

    def track_shipment(tracking_number)
      track_request = Nokogiri::XML::Builder.new do
        TrackRequest {
          Request {
            RequestAction "Track"
            RequestOption "activity"
          }
          TrackingNumber tracking_number
        }
      end

      @http.commit("/ups.app/xml/Track", track_request.to_xml)
    end


    private
    def access_request(user, password, license)
      access_request = Nokogiri::XML::Builder.new do
        AccessRequest {
          AccessLicenseNumber license
          UserId user
          Password password
        }
      end

      access_request.to_xml
    end

  end
end