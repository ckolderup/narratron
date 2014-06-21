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
  has_one :entry, as: :parent, dependent: :destroy

  def entries
    if entry.nil?
      []
    else
      entry.descendants.prepend(entry)
    end
  end

  def leaves
    entries.select { |e| e.leaf? }
  end

  def contributors
    entries.collect { |e| e.user }
  end
end
