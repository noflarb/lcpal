require File.join(File.dirname(__FILE__), "/../spec_helper")

describe LCPAL do
  context "searching by a name that exists" do
    setup do
      @lcpal = LCPAL.new
      @results = @lcpal.search :first_name => "John", :last_name => "Marks"
    end
    
    it "should return results." do
      @results.should_not be_empty
    end
  end
  context "searching by a name that does not exist" do
    setup do
      @lcpal = LCPAL.new
      @results = @lcpal.search :first_name => "Santa", :last_name => "Claus"
    end
    
    it "should not return results." do
      @results.should be_empty
    end
  end
end