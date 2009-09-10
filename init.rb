require 'revisionist'

ActiveRecord::Base.send :include, Revisionist::Record
