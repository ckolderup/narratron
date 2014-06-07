# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  path_id    :integer
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  has_one :path
end
