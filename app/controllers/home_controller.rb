require 'will_paginate/array'

class HomeController < ApplicationController
  def index
  end

  def archive
    public_days = Day.where("date <= ?", Day.pacific_time)
                     .map { |d| [d.story, d.date] }

    private_stories = []
    if current_user
      private_stories = Entry.where(user: current_user)
                             .map { |e| [e.story, e.story.created_at] }
    end

    all_stories = (public_days + private_stories)
                    .sort_by { |x| x.last }
                    .reverse
                    .map { |x| x.first}
                    .uniq

    current_page = [params[:page].to_i, 1].max
    @stories = all_stories.paginate(page: current_page, per_page: Story.per_page)
  end
end
