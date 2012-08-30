Then /^I should see the following json response:$/ do |string|
  expected = MultiJson.decode(string)
  expected.should == MultiJson.decode(page.driver.response.body)
end

