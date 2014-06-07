# == Schema Information
#
# Table name: paths
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  story      :reference
#

class Path < ActiveRecord::Base
  has_many :entries
  has_many :votes
  has_one :story

  def score
    votes.map { |v| v.score }.reduce(:+)
  end
end
