module Shipping
  class Package
    attr_accessor :width
                  :height
                  :length
                  :weight
                  :shape
                  :description
                  :monetary_value

    def initialize(options={})

    end
  end
end