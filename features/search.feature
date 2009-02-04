Feature: Leon County Property Appraiser Search
  In order to get information about properties in Leon County
  As a ruby developer
  I want to search from ruby
  
  Scenario: New Search
    Given I have not performed any searches
    When I search for "John Marks"
    Then I should get results
    And results should include parcel: 1106290000010
  

  
