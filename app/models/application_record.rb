class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  PULL = 1
  PUSH = 2
end
