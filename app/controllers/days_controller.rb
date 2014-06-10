class DaysController < ApplicationController
  def show
    if current_user.admin? then
      render 'days/admin'
    else
      @day = Day.find(params[:id])
      @story = Story.find(days: @day)
      redirect_to entries_path(@story.leaves.sample)
  end

  def today
    @day = Day.find(date: Date.today)
    params[:day] = @day
    show
  end
end
