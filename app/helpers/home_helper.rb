module HomeHelper
  def story_title(story)
    "#{story.day.present? ? 'Public story for' : 'Private story created'} \
     #{(story.day.present? ? story.day.date : story.created_at).strftime('%A %B %e')}"
  end
end
