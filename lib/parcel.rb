module LCPAL
  class Parcel
    include DataMapper::Resource

    def self.default_repository_name
      :lcpa
    end
    
    # belongs_to :person
    
    property :parcel_id, Integer, :key => true
    
  end
end