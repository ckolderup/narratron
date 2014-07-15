class EntriesController < ApplicationController
  before_filter :allow_story_creation, only: :new
  before_filter :authorize, only: :destroy

  def new
    @new_entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.parent = Story.new if @entry.parent.nil?

    if @entry.save
      attempt_wrapping_story(@entry.story)
      attempt_closing_story(@entry.story)
      redirect_to entry_path(@entry)
    else
      if @entry.parent.new_record?
        flash[:error] = @entry.errors.to_a.join(", ")
        redirect_to new_entry_path
      else
        redirect_to @entry.parent
      end
    end
  end

  def show
    encoded = Base58.encode(params[:id].to_i)
    redirect_to find_entry_path(@entry, {id: encoded})
  end

  def find
    decoded = Base58.decode(params[:id])
    @entry = Entry.find(decoded)

    if @entry.nil?
      raise ActiveRecord::RecordNotFound
    elsif @entry.story.closed? || @entry.story.contributed?(current_user)
      leaf = @entry.leaf? ? @entry : @entry.leaves.sample
      @story = leaf.story
      @entries = @story.paths(leaf).first
      render 'read' and return
    end

    @entry = @entry.story.leaves.sample

    @new_entry = @entry.entries.build
    @new_entry.ending = true if @entry.story.wrapping?

    render 'contribute'
  end

  def destroy
    @entry = current_user.entries.find(params[:id])

    @entry.destroy
    flash.notice 'Entry deleted.'

    redirect_to story_index
  end

  private

  def entry_params
    params.require(:entry).permit(:text, :parent_type, :parent_id)
  end

  def attempt_closing_story(story)
    unfinished_leaves = story.leaves.select { |e| e.ending = false }
    story.update(status: "closed") if story.wrapping? && unfinished_leaves.empty?
  end

  def attempt_wrapping_story(story)
    story.update(status: "wrapping") if story.ready_to_wrap?
  end
end
