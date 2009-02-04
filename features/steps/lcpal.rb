Given /^I have not performed any searches$/ do
end

When /^I search for "(.*)"$/ do |name|
  first_name, last_name = name.split(' ')
  @results = LCPAL.new.search :first_name => first_name, :last_name => last_name
end

Then /^I should get results$/ do
  @results.should_not be_empty
end

Then /^results should include parcel: (\d*)$/ do |parcel|
  @results.select{|result| result == parcel}.should_not be_empty
end