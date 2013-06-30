# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'date'
require 'active_support/ordered_options'

require 'simplecov'
SimpleCov.start { add_filter '/spec/' }

require 'ettu'
require 'fixtures'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end
