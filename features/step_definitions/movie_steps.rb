# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #assert false, "Unimplmemented"
end

Given /^I am on the RottenPotatoes home page$/ do
  visit('/movies')
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split
  ratings.each do |r|
    if uncheck
      uncheck("ratings_#{r}")
    else
      check("ratings_#{r}")
    end
  end
end

When /^I submit the search form$/ do
  click_button "Refresh"
end

When /I sort the results by (.*)/ do |sort_order|
  sort_id = sort_order.gsub(/\s/, '_')
  click_link "#{sort_id}_header"
end

Then /^I should see PG and R movies$/ do
  #page.should have_xpath("//td[text()='PG']")
  assert page.has_xpath?("//td[text()='PG']")
  assert page.has_xpath?("//td[text()='R']")
end

Then /^I should not see other movies$/ do
  assert page.has_no_xpath?("//td[text()='PG-13']")
  assert page.has_no_xpath?("//td[text()='G']")
end

Then /^I should see all of the movies$/ do
  #puts page.body
  assert page.has_css?("table tbody tr", count: 10)
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body =~ /#{e1}.*#{e2}/m
  #assert false, "Unimplmemented"
end

