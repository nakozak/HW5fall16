# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end
 Then /^(?:|I )should not see "([^"]*)"$/ do |text|
    expect(page).to !have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.
Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
 # pending  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
   m =  Movie.create!(movie)
   m.save()
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end
When /^I have opted to see movies rated: "(.*?)"$/ do |args|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
 # pending  #remove this statement after implementing the test step
 ratings = args.split(/\s*,\s*/)
 Movie.where(rating: ratings).find_each do |movie|
     step "I should see \"#{movie.title}\""
    end
end

Then /^I should see only movies rated: "(.*?)"$/ do |rating_list|
 ratings = rating_list.split(/\s*,\s*/)
 Movie.where(rating: ratings).find_each do |movie|
     step "I should see \"#{movie.title}\""
 end
end
#Should see all the movies
#Then /^I should see all of the movies/ do
  #rows = page.all('#movies tr').size - 1
 # assert rows == Movie.count()
#end
#  ensure that that e1 occurs before e2.
Then /^I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  page.content  is the entire content of the page as a string.
  assert_match(/#{e1}(.|\n)*#{e2}/,page.body)
end
#Shouldn't see any movies
Then /I should not see any of the movies/ do
  rows = page.all('#movies tr').size - 1
  assert rows == 0
end

Then /the movies should be sorted by "(.*)"/ do |field|
  prev=""
  Movie.find(:all, :order => field).each do |movie|
    curr = movie.send(field)
    step "I should see \"#{prev}\" before \"#{curr}\"" if prev != ""
    prev = curr 
  end
end
#Mimic unchecking/checking  a ratings box
When /^I (un)?check the following ratings: "(.*)"/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each {|x| step %{I uncheck "ratings_#{x}"}}
  else
    rating_list.split(', ').each {|x| step %{I check "ratings_#{x}"}}
  end
end
#Mimic Button Press on page
When /^I press "(.*?)"$/ do |button|
  click_button(button)
end
