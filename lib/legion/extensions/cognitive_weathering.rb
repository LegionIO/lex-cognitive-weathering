# frozen_string_literal: true

require 'legion/extensions/cognitive_weathering/version'
require 'legion/extensions/cognitive_weathering/helpers/constants'
require 'legion/extensions/cognitive_weathering/helpers/stressor'
require 'legion/extensions/cognitive_weathering/helpers/weathering_engine'
require 'legion/extensions/cognitive_weathering/runners/cognitive_weathering'

module Legion
  module Extensions
    module CognitiveWeathering
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
