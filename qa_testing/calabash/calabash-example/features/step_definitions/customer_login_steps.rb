#language: en
#customer_login_steps.rb

When(/^the customer enters telephone "(\d+)" and password "(\d+)"$/) do |telephone,password|
  @screen.login_screen.login_with(telephone,password)
end

Then(/^the customer is successfully logged in$/) do
  @screen.home_screen.await
end

