module Shipping
  class Organization
    ADDRESS_TYPES = %w{residential commercial po_box}
    attr_accessor :name
                  :phone
                  :email
                  :address

    def initialize(options={})

    end
  end
end
