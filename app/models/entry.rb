# == Schema Information
#
# Table name: entries
#
#  id             :integer          not null, primary key
#  parent_id      :integer
#  parent_type    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#  text           :string(255)
#

class Entry < ActiveRecord::Base
  obfuscate_id

  belongs_to :story
  belongs_to :user

  belongs_to :parent, polymorphic: true
  has_many :entries, as: :parent, dependent: :destroy

  validates :parent, presence: true
  validates :text, presence: true
  validate :user_only_writes_once_per_story

  def story
    if parent_type == 'Story' then
      parent
    else
      parent.story
    end
  end

  def descendants
    entries.flat_map { |e| [e] + e.descendants }
  end

  def leaf?
    entries.empty?
  end

  private

  def user_only_writes_once_per_story
    if story.contributors.include?(user) then
      errors.add(:base, "Can't contribute twice to the same story")
    end
  end
end
