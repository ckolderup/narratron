# == Schema Information
#
# Table name: days
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  story_id   :integer
#

class Day < ActiveRecord::Base
  belongs_to :story
end
