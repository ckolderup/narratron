# == Schema Information
#
# Table name: entries
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  parent_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  text        :string(255)
#  ending      :boolean
#

class Entry < ActiveRecord::Base
  obfuscate_id

  self.per_page = 5

  belongs_to :story
  belongs_to :user

  belongs_to :parent, polymorphic: true
  has_many :entries, as: :parent, dependent: :destroy

  validates :parent, presence: true
  validates :text, presence: true
  validate :user_only_writes_once_per_story
  validate :entry_text_is_only_one_sentence

  attr_accessor :override_sentence_limit

  def story
    if parent_type == 'Story'
      parent
    elsif parent.present?
      parent.story
    else
      nil
    end
  end

  def first_sentence?
    parent_type == 'Story'
  end

  def descendants
    entries.flat_map { |e| [e] + e.descendants }
  end

  def leaves
    descendants.select { |e| e.leaf? }
  end

  def leaf?
    entries.empty?
  end


  private

  def user_only_writes_once_per_story
    if story.contributors.include?(user)
      errors.add(:base, "Can't contribute twice to the same story")
    end
  end

  def entry_text_is_only_one_sentence
    unless override_sentence_limit || text.blank? #the other validation will catch blank text
      tokenizer = Punkt::SentenceTokenizer.new(text)
      result    = tokenizer.sentences_from_text(text, :output => :sentences_text)
      if result.reject { |s| s.length <= 1 }.size > 1
        errors.add(:base, "Entries must be made up of one sentence only")
      end
    end
  end
end
