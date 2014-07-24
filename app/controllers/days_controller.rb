class DaysController < ApplicationController
  before_filter :authorize, only: [:queue, :destroy]

  def show
    @day ||= Day.find(params[:id])
    #TODO
    #if current_user.admin?
    #  render 'days/admin'
    #else
    #end
    redirect_to entry_path(@day.story.leaves.sample)
  end

  def today
    @day = Day.find_by_date(Day.pacific_time.to_date)

    redirect_to entry_path(@day.story.leaves.sample)
  end

  def queue
    @queued_days = Day.where("date > ?", Day.pacific_time)
                      .paginate(page: params[:page])
                      .order('date ASC')
  end

  def destroy
    @day = Day.find(params[:id])
    flash[:message] = "Day deleted!" if @day.destroy
    redirect_back_or_default(queue_path)
  end
end
