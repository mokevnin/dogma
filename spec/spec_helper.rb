DOGMA_SPEC_PATH = File.join(File.dirname(__FILE__))

require 'dogma'
require 'sequel'

Dir["./spec/support/**/*.rb"].each {|f| require f}

Dogma.configure do |config|
  config.mapping_paths += [
    DOGMA_SPEC_PATH + '/fixtures/mapping',
    DOGMA_SPEC_PATH + '/fixtures/driver'
  ]
end
