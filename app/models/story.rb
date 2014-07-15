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

  enum status: %w(open wrapping closed)

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

  def contributed?(user)
    contributors.include?(user)
  end

  def contribution_from(user)
    entries.select { |e| e.user == user }.first
  end

  def ready_to_wrap?
    open? && entries.size > 4 && created_at < 1.day.ago
  end

  def paths(entry = nil)
    if entry.nil?
      eligible_leaves = leaves
    elsif entry.leaf?
      eligible_leaves = [entry]
    else
      eligible_leaves = entry.leaves
    end

    eligible_leaves.map { |e| paths_helper(e) }
  end

  private

  def paths_helper(e)
    if e.nil?
      []
    elsif e.parent_type == 'Story'
      [e]
    else
      paths_helper(e.parent) << e
    end
  end
end
