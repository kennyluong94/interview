require 'sinatra/base'
require 'yaml'
Dir['./lib/*.rb'].each { |f| require f }



class Main < Sinatra::Base
  get '/' do
    @address_book ||= YAML::load_file(File.join(__dir__, 'config', 'addresses.yml'))
    @addresses ||= Array.new

    if @addresses.empty?
      @address_book["addresses"].each do |k, v|
        @addresses << Address.new(lat: v["lat"], lng: v["lng"], full_address: nil)
      end
    end

    erb :index , locals: { addresses: @addresses }
  end
end
