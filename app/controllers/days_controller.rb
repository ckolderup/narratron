class DaysController < ApplicationController
  def show
    @day ||= Day.find(params[:id])
    #TODO
    #if current_user.is_admin?
    #  render 'days/admin'
    #else
    #end
    redirect_to entry_path(@day.story.leaves.sample)
  end

  def today
    @day = Day.find_by_date(Date.today.to_datetime)

    redirect_to entry_path(@day.story.leaves.sample)
  end
end
