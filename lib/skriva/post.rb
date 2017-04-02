require 'skriva/post_helpers/class_methods.rb'
require 'skriva/post_helpers/instance_methods.rb'

module Skriva
  class Post
    include Skriva::PostHelpers::InstanceMethods
    extend Skriva::PostHelpers::ClassMethods
  end
end
