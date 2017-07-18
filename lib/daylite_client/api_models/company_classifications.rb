module DayliteClient
  class CompanyClassifications < Resource
    collection_path "/companies/:type"

    custom_get :industries, :regions, :types

    # scope :industries, -> { where(type: "industries") }
    # scope :regions,    -> { where(type: "regions") }
    # scope :types,      -> { where(type: "types") }
  end
end