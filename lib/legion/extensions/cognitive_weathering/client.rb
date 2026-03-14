# frozen_string_literal: true

require 'legion/extensions/cognitive_weathering/helpers/constants'
require 'legion/extensions/cognitive_weathering/helpers/stressor'
require 'legion/extensions/cognitive_weathering/helpers/weathering_engine'
require 'legion/extensions/cognitive_weathering/runners/cognitive_weathering'

module Legion
  module Extensions
    module CognitiveWeathering
      class Client
        include Runners::CognitiveWeathering

        def initialize(**)
          @weathering_engine = Helpers::WeatheringEngine.new
        end
      end
    end
  end
end
