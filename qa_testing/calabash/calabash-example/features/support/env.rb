#language: en
#env.rb

require 'rspec'
require 'date'
require 'require_all'
require 'rake'
require 'byebug'

if ENV['PLATFORM'] == 'ios'
  require 'calabash-cucumber/cucumber'
  require 'calabash-cucumber/calabash_steps'
elsif ENV['PLATFORM'] == 'android'
  require 'calabash-android/cucumber'
  require 'calabash-android/calabash_steps'

end
