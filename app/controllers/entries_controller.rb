class EntriesController < ApplicationController
  def new
    @new_entry = Entry.new(entry_params)
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.spawnable = Story.create if @entry.spawnable.nil?

    if @entry.save then
      redirect_to entry_path(@entry)
    else
      redirect_to @entry.spawnable
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
    params.require(:entry).permit(:text, :spawnable_type, :spawnable_id)
  end
end
