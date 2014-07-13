module EntriesHelper
  def entry_date(e)
    e.created_at.strftime("%A, %B %e %Y")
  end
end
