# == Schema Information
#
# Table name: entries
#
#  id             :integer          not null, primary key
#  spawnable_id   :integer
#  spawnable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#  text           :string(255)
#

class Entry < ActiveRecord::Base
  obfuscate_id

  belongs_to :story
  belongs_to :user

  belongs_to :spawnable, polymorphic: true
  has_many :entries, as: :spawnable, dependent: :destroy

  validates :spawnable, presence: true
  validates :text, presence: true
end
