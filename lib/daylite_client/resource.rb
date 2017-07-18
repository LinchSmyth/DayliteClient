module DayliteClient
  class Resource
    include Her::Model
    use_api DayliteClient::Client.instance.her_api

    # transforms "/v1/:model/1000" to "1000" based on caller model
    def id
      return nil unless self.self.present?

      model = self.class.to_s.split("::")[1].downcase.pluralize
      id = self.self.match(/\/v1\/#{model}\/([0-9]+)/)[1]

      id.present? ? id.to_i : nil
    end
  end
end
