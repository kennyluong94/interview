require 'geocoder'

Geocoder.configure(lookup: :geocoder_ca, timeout: 20, http_headers: { 'Accept-Encoding' => 'json' })
