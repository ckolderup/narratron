class EntriesController < ApplicationController
  before_filter :authorize, only: [:destroy, :create]

  def new
    @new_entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.parent = Story.create if @entry.parent.nil?

    if @entry.save then
      redirect_to entry_path(@entry)
    else
      redirect_to @entry.parent
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
    elsif @entry.story.closed?
      leaf = @entry.leaves.sample unless @entry.leaf?
      @entries = chronological_path_from_leaf(leaf)
      @story = leaf.story
      render 'read' and return
    elsif @entry.story.contributed?(current_user)
      contribution = @entry.story.contribution_from(current_user)
      leaf = contribution.leaf? ? contribution : contribution.leaves.sample
      @entries = chronological_path_from_leaf(leaf)
      @story = leaf.story
      render 'read' and return
    end

    @new_entry = @entry.entries.build
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

  def chronological_path_from_leaf(e)
    if e.parent_type == 'Story'
      [e]
    else
      chronological_path_from_leaf(e.parent) << e
    end
  end
end
