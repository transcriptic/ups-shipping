module Shipping
  class UPS
    def initialize(options={})
      @options = options
      @test = @options[:test]
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

    end

    def request_pickup(origin, date)

    end

    def cancel_pickup(pickup_request_id)

    end

  end
end