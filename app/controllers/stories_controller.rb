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
end
