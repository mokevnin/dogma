require 'dogma'
require 'sequel'

Dir["./spec/support/**/*.rb"].each {|f| require f}

Dogma.configure do |config|
  config.mapping_paths += [
    DOGMA_ROOT_PATH + '/spec/fixtures/mapping',
    DOGMA_ROOT_PATH + '/spec/fixtures/driver'
  ]
end
