require File.join(File.dirname(__FILE__), "/../spec_helper")

describe DataMapper::Adapters::LcpaAdapter do
  before(:all) do
    DataMapper.setup(:lcpa, :database => 'http://www.leonpa.org/search2.cfm', :adapter => 'lcpa')
    @adapter = DataMapper::Repository.adapters[:lcpa]
  end
  
  context "getting a person" do
    before(:all) do
      @mayor = LCPAL::Person.get "John","Marks"
      @santa = LCPAL::Person.get "Santa","Claus"
    end
    
    it "should get a person who exists." do
      @mayor.should_not be_nil
      @mayor.should be_instance_of(LCPAL::Person)
      
    end
    
    it "should not get a person who doesn't exist." do
      @santa.should be_nil
    end
  end

  context "getting parcels for a person" do
    before(:all) do
      @mayor = LCPAL::Person.get "John","Marks"
    end
    
    it "should get parcels for a person who exists." do
      @mayor.parcels.should_not be_empty
      @mayor.parcels[0].should be_instance_of(LCPAL::Parcel)
    end
  end
end