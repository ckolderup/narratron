# == Schema Information
#
# Table name: days
#
#  id         :integer          not null, primary key
#  date       :datetime
#  created_at :datetime
#  updated_at :datetime
#  story_id   :integer
#

class Day < ActiveRecord::Base
  belongs_to :story

  self.per_page = 5

  def to_date
    date.to_date
  end

  def self.today
    Day.find_by_date (Date.today - 8.hours).to_date
  end
end
