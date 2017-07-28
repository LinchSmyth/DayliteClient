# Libs
require 'base64'
require 'singleton'
require 'faraday'
require 'her'
require 'pry'

# Basic classes
require 'daylite_client/version'
require 'daylite_client/client'
require 'daylite_client/middleware'
require 'daylite_client/api_error'
require 'daylite_client/resource'

# Daylite api models
require 'daylite_client/api_models/user'
require 'daylite_client/api_models/contact'
require 'daylite_client/api_models/company'
require 'daylite_client/api_models/label'
require 'daylite_client/api_models/note'
require 'daylite_client/api_models/opportunity'

module DayliteClient
  def self.root
    File.expand_path '../..', __FILE__
  end
end
