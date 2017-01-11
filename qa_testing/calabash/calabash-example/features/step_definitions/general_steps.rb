#language: en
#general_steps.rb

Given(/^the app is launched$/) do
  #@screen = page(AppScreens)
end

Then(/^the customer should see "(.*?)"$/) do |text|
  #Check if text exists in the screen
  wait_for_text(text)
  screenshot_embed
end