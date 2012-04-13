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

    end
  end
end