class Submission < ActiveRecord::Base
  obfuscate_id

  self.per_page = 10

  validates :text, presence: true
end
