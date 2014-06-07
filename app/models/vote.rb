# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#  path_id    :integer
#

class Vote < ActiveRecord::Base
  belongs_to :path

  validates :score, inclusion: { in: [-1,1] }
end
