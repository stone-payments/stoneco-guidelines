#language: en
#calabash_steps.rb

if ENV['PLATFORM'] == 'android'
  require 'calabash-android/calabash_steps'
elsif ENV['PLATFORM'] == 'ios'
  require 'calabash-cucumber/calabash_steps'
end