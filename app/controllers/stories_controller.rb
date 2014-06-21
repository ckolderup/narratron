class StoriesController < ApplicationController
  before_filter :authorize, except: :show

  def index
    @stories = Story.all
  end

  def show
    @story = Story.find(params[:id])
    @leaf = @story.leaves.sample
  end

  def new
    @new_entry = Entry.new
  end
end
