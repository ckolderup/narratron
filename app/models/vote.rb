class Vote < ActiveRecord::Base
  belongs_to :path

  validates :score, inclusion: { in: [-1,1] }
end
