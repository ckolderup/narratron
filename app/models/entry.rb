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

  def story
    parent.story
  end

  def leaves
    return [self] if entries.empty?

    leaves, rest = entries.partition { |e| e.entries.nil? }
    return [leaves] + rest.map { |e| e.leaves }
  end

  def all_players
    parent.all_players + [user]
  end
end
