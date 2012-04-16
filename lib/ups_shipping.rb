require "nokogiri"
require "httparty"

module Shipping
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
      @access_request = access_request(user, password, license)
      @http = Http.new(@access_request, :test => @options[:test])
    end

    def validate_address(address)

    end

    def find_rates(package, origin, destination)

    end

    def request_shipment(package, origin, destination, options={})

    end

    def cancel_shipment(shipment_id)

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

    def request_pickup(origin, date)

    end

    def cancel_pickup(pickup_request_id)

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