class ApplicationRecord < ActiveRecord::Base
  extend Useful
  self.abstract_class = true
end
