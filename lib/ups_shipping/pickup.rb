require "nokogiri"

module Shipping
  class Pickup
    attr_accessor :address_lines, :pickup_day, :contact_method, :type

    def initialize(options={})
      @type = options[:type]
      if options[:pickup_day]
        @pickup_day = options[:pickup_day]
      end
      if options[:contact_method]
        @contact_method = options[:contact_method]
      end

      @pickupTypes = {
          "01" => "Daily Pickup",
          "03" => "Customer Counter",
          "06" => "One Time Pickup",
          "07" => "On Call Air",
          "19" => "Letter Center",
          "20" => "Air Service Center"
      }
    end

    def build_schedule(xml)
      xml.OnCallAir {
        xml.Schedule {
          if @pickup_day
            xml.PickupDay @pickup_day
          end
          if @contact_method
            xml.Method @contact_method
          end
        }
      }
    end

    def build_type(xml)
      xml.PickupType {
        xml.Code type
        xml.Description @pickupTypes[type]
      }
    end
  end
end
