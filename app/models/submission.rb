class Submission < ActiveRecord::Base
  self.per_page = 10

  validates :text, presence: true
end
