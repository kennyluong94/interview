require_relative 'geocoding'

class Address
  attr_accessor :lat, :lng, :full_address, :distance

  DEFAULT_LOCATION = "1600 Pennsylvania Avenue NW Washington, D.C. 20500"

  def initialize(lat: nil, lng: nil, full_address: nil)
    # NOTE: The constructor was written with the intention of minimizing as many API calls as possible.

    @lat = lat
    @lng = lng
    @reverse_geocode = reverse_geocode
    @geocode         = geocode
    @full_address    = full_address || address
    @distance        = miles_to(location: nil)
  end

  def coordinates
    [@lat, @lng]
  end

  # If we only care about the default location, we can remove the parameters and make this method private and display self.distance in the view instead.

  def miles_to(location: nil)
    location ||= @default_location.first
    Geocoder::Calculations.distance_between(self.coordinates, location.coordinates)
  rescue
    "Limit reached"
  end

  def geocoded?
    !@geocode.empty?
  end

  def reverse_geocoded?
    !@reverse_geocode.empty?
  end

  # Sorts based on distance from the default location per project specs. Can be configured as needed.

  def <=>(address)
    @distance <=> address.distance
  end

  private

  def address
    @reverse_geocode.first&.address || "Limit Reaced"
  end

  def geocode
    Geocoder.search(@full_address)
  end

  def reverse_geocode
    Geocoder.search(coordinates)
  end
end
