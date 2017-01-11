#language: en
#base_screen.rb

require 'calabash-android/abase'

class BaseScreen < Calabash::ABase

  def method_missing(name, *args, &block)
    send(name, *args, &block)
  end

  def self.element(name, &block)
    define_method(name.to_s, &block)
  end

  class << self
    alias :value    :element
    alias :action   :element
    alias :trait    :element
  end

end
