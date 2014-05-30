class Story < ActiveRecord::Base
  has_one :day
  has_many :entries
end
