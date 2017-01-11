#language: en
#app_screen.rb

require 'calabash-android/abase'
require_relative '../../../features/android/screens/base_screen'

class AppScreens < BaseScreen

  def login_screen
    @login_screen ||= page(LoginScreen)
  end

  def home_screen
    @home_screen ||= page(HomeScreen)
  end

end

