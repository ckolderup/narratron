# == Schema Information
#
# Table name: entries
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  story_id   :integer
#  user_id    :integer
#  parent_id  :reference
#  text       :string(255)
#

class Entry < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

  has_many :children, class_name: "Entry", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Entry"

  validates :story, presence: true
  validate :story_only_has_one_start

  def story_only_has_one_start
    unless parent.present? || story.entries.empty? then
      errors[:base] << "This entry's story already has a beginning"
    end
  end
end
