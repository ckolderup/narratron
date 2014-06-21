class EntriesController < ApplicationController
  before_filter :authorize, only: [:destroy, :create]

  def new
    @new_entry = Entry.new(entry_params)
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
    @entry = Entry.find(params[:id])
    @new_entry = @entry.entries.build
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
end
