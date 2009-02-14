require File.join(File.dirname(__FILE__), "/../spec_helper")

describe LCPAL do
  context "searching by a name that exists" do
    setup do
      @results = LCPAL::Person.get "John", "Marks"
    end
    
    it "should return results." do
      @results.should_not be_nil
    end
  end
  context "searching by a name that does not exist" do
    setup do
      @results = LCPAL::Person.get "Santa", "Claus"
    end
    
    it "should not return results." do
      @results.should be_nil
    end
  end
end