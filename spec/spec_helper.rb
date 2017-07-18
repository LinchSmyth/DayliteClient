$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'daylite_client'
require 'pry'

Dir["#{DayliteClient.root}/spec/support/**/*.rb"].each { |f| require f }
