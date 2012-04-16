require "rspec"
require "ups_shipping"

describe Shipping::UPS do
  before(:all) do
    @ups = Shipping::UPS.new("deanchen", "Transcriptic#1", "EC96D31A8D672E28")
  end
  it "#track_shipment" do
    tracking_result = @ups.track_shipment("1ZXX31290231000092")
    tracking_result.should have_key("TrackResponse")
  end
end