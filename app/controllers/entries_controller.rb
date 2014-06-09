class EntriesController < ApplicationController

  def create
    @parent = Entry.find(params[:entry_id])
    @entry = @parent.children.create entry_params
    redirect_to entry_path(@entry)
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def destroy
    @entry = current_user.entries.find(params[:id])
    @parent = @entry.parent

    @entry.destroy
    flash.notice 'Entry deleted.'

    redirect_to @parent
  end

  private

  def entry_params
    params.require(:entry).permit(:text)
  end
end
