# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    m = Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #assert page.body.index(e1) < page.body.index(e2) , "Wrong order"
  assert(page.body =~ /#{e1}.+#{e2}/m, "e1 is #{e1} and e2 is #{e2}")
end



#check part of the ratings selected
Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
  ratings = rating_list.split(",")
  ratings = Movie.all_ratings - ratings if negation
  db_size = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
    page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size}]")
end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(",")
  ratings.each do |rating|
    rating = "ratings_" + rating
    if uncheck == "un"
      uncheck(rating)
      # step %{I uncheck "#{rating}"}
    else
      check(rating)
      # step %{I check "#{rating}"}
      end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

# Check and Uncheck all the ratings
When /I (un)?check all the ratings/ do |uncheck|
  Movie.all_ratings.each do |rating|
    rating = "ratings_" + rating
      if uncheck
        uncheck(rating)
      else
        check(rating)
      end  
  end
end

# After "I check/uncheck all the ratings, Then I should see/not see movies
Then /^I should see none of the movies$/ do
  rows = page.all('#movies tr').size - 11
  assert(rows == 0, "rows number is #{rows}")
end

Then /^I should see all of the movies$/ do
  rows = page.all('#movies tr').size - 1
  assert(rows == Movie.count)
end

