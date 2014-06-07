class EntriesController < ApplicationController

  def create
    @parent = Entry.find(params[:parent])
    @entry = @parent.children.new entry_params

    if @entry.save then
      redirect_to @entry
    else
      render :new
    end
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
