module DayliteClient
  class Label < Resource
    custom_get :social_profiles, :emails, :urls, :phone_numbers, :addresses
  end
end