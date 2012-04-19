require "rspec"
require "ups_shipping"
require "address"
require "organization"

describe Shipping::UPS do
  before(:all) do
    @ups = Shipping::UPS.new("deanchen", "Transcriptic#1", "EC96D31A8D672E28", :test => true)
    @address = Shipping::Address.new(
        :address_lines => ["1402 Faber St."],
        :city => "Durham",
        :state => "NC",
        :zip => "27705",
        :country => "US"
    )
  end
  it "address object" do
    @address.to_xml.gsub(/^\s+/, "").gsub(/\s+$/, $/).should == '
      <?xml version="1.0"?>
      <Address>
        <AddressLine1>1402 Faber St.</AddressLine1>
        <City>Durham</City>
        <StateProvinceCode>NC</StateProvinceCode>
        <PostalCode>27705</PostalCode>
        <CountryCode>US</CountryCode>
      </Address>
      '.gsub(/^\s+/, "").gsub(/\s+$/, $/)
  end
  it "organization object" do
    @organization = Shipping::Organization.new(
        :name => "Transcriptic",
        :phone => "1233455678",
        :address => @address
    )
    puts @organization.to_xml("Shipper")
  end
  it "#track_shipment" do
    tracking_result = @ups.track_shipment("1ZXX31290231000092")
    tracking_result.should have_key("TrackResponse")
    tracking_result["TrackResponse"]["Response"]["ResponseStatusCode"].should == "1"
  end
end