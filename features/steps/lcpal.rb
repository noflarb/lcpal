Given /^I have not performed any searches$/ do
end

When /^I search for "(.*)"$/ do |name|
  first_name, last_name = name.split(' ')
  # @person = LCPAL::Person.new :first_name => first_name, :last_name => last_name
  @person = LCPAL::Person.get first_name, last_name
  @results = @person.parcels
  # @results = LCPAL.new.search :first_name => first_name, :last_name => last_name
end

Then /^I should get results$/ do
  @results.should_not be_empty
end

Then /^results should include parcel: (\d*)$/ do |parcel_id|
  @results.select{|result| result.parcel_id.to_s == parcel_id}.should_not be_empty
end