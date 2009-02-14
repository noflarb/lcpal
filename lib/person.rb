module LCPAL
  class Person
    include DataMapper::Resource
    
    def self.default_repository_name
      :lcpa
    end
  
    property :first_name, String, :key => true
    property :last_name, String, :key => true
  
    has n, :parcels
  
  end
end