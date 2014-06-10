# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  thanks     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Story < ActiveRecord::Base
  obfuscate_id

  has_one :day
  has_one :entry, as: :spawnable, dependent: :destroy

  def leaves
    if entry.nil?
      nil
    else
      entry.leaves
    end
  end
end
