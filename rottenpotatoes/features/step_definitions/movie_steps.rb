# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create movie
  end
  #fail "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  if page.body.index(e1) >= page.body.index(e2)
    fail "index reversed"
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',')
    if uncheck
      ratings.each do |rating|
        rating = rating.strip
        step %{I uncheck "ratings_#{rating}"}
      end
    else
      ratings.each do |rating|
        rating = rating.strip
        step %{I check "ratings_#{rating}"}
      end
    end
  # fail "Unimplemented"
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  
  movies = Movie.all
  movies.each do |movie|
    step %{I should see "#{movie.title}"}
  end
  # fail "Unimplemented"
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
  movie = Movie.where( :title => arg1 ).first
  if !movie.director.eql? arg2
    fail "Wrong director name"
  end
end 