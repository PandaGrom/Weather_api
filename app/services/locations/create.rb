module Locations
  class Create < ApplicationService
    def initialize(args)
      @args = args
    end

    def call
      Location.create!(
        uuid: args[:uuid],
        location_name: args[:location_name]
      )
    end

    private

    attr_reader :args
  end
end
