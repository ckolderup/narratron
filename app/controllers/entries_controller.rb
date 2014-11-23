class EntriesController < ApplicationController
  before_filter :allow_story_creation, only: :new
  before_filter :authorize, only: :destroy

  def new
    @new_entry = Entry.new(story: Story.new)
  end

  def create
    @entry = Entry.create(entry_params.merge(user: current_user))
    @entry.build_story

    if @entry.save
      attempt_closing_story(@entry.story)
      attempt_wrapping_story(@entry.story)
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
    redirect_to find_entry_path(@entry, {id: encoded, delete: params[:delete]})
  end

  def find
    Rails.logger.info("locating entry #{params[:id]}")
    decoded = Base58.decode(params[:id])
    @entry = Entry.find(decoded)

    @entry.story.close_public_if_ready

    edits_allowed = @entry.story.can_be_edited?(current_user)
    delete_mode = edits_allowed & !!params[:delete].present?

    if @entry.nil?
      raise ActiveRecord::RecordNotFound
    elsif can_show_story || delete_mode
      leaf = @entry.leaf? ? @entry : @entry.leaves.sample
      @story = leaf.story
      @entries = @story.paths(leaf).first
      render('read', locals: {delete_mode: delete_mode}) and return
    end

    @entry = leaf_with_shortest_path(@entry.leaves, @entry.story) unless @entry.leaf?

    @new_entry = @entry.entries.build
    @new_entry.ending = true if @entry.story.wrapping?
    @entries = @entry.story.paths(@entry).first
    @entries.pop(2) #remove the one we're showing & the one we're writing

    render 'contribute'
  end

  def destroy
    @entry = Entry.find(params[:id])

    user_can_destroy = @entry.story.can_be_edited?(current_user)
    user_owns_entry = current_user && @entry.user == current_user

    if user_can_destroy || user_owns_entry
      entry_parent = @entry.parent
      @entry.destroy
      flash[:message] = 'Entry deleted.'
    else
      flash[:error] = 'Unauthorized action!'
    end

    redirect_to entry_path(entry_parent)
  end

  private

  def can_show_story
    @entry.story.closed? || (current_user && @entry.story.contributed?(current_user))
  end

  def entry_params
    params.require(:entry).permit(:text, :parent_type, :parent_id, parent_attributes: [ :id, :title ])
  end

  def attempt_closing_story(story)
    unfinished_leaves = story.leaves.select { |e| e.ending = false }
    story.update(status: "closed") if story.wrapping? && unfinished_leaves.empty?
  end

  def attempt_wrapping_story(story)
    story.update(status: "wrapping") if story.ready_to_wrap?
  end

  def leaf_with_shortest_path(leaves, story)
    leaves.inject({}) { |m,k| m.update(k => story.paths(k).first.size) }
          .min_by(&:last).first
  end
end
