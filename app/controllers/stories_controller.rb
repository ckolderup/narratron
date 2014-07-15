class StoriesController < ApplicationController
  before_filter :authorize, except: :show

  def index
    @stories = Story.all
  end

  def show
    @story = Story.find(params[:id])
    @leaf = @story.leaves.sample
    redirect_to @leaf
  end

  def new
    redirect_to new_entry_path
  end

  def toggle_status
    @story = Story.find(params[:story_id])
    if @story.closed?
      @story.open!
      flash[:message] = "Story opened!"
    else
      @story.closed!
      flash[:message] = "Story closed!"
    end

    redirect_back_or_default(story_path(@story))
  end
end
