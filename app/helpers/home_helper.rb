module HomeHelper
  def story_title(story)
    "#{story.day.present? ? 'Public story for' : 'Private story created'} \
     #{(story.day.present? ? story.day.date : story.created_at).strftime('%A %B %e')}"
  end

  def last_author_display(leaf)
   if leaf.user.nil?
     leaf.story.thanks || 'Anonymous'
   elsif leaf.user == current_user
     'you'
   else
     leaf.user.display_name
   end
  end
end
