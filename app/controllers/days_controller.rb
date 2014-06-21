class DaysController < ApplicationController
  def show
    @day ||= Day.find(params[:id])
    #TODO
    #if admin_access? then
    #  render 'days/admin'
    #else
      redirect_to entry_path(@day.story.leaves.sample)
    #end
  end

  def today
    @day = Day.find_by_date(Date.today.to_datetime)
    show
  end
end
