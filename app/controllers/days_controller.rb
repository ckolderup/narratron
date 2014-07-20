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
    @day = Day.find_by_date((Date.today - 8.hours).to_date)

    redirect_to entry_path(@day.story.leaves.sample)
  end

  def index
    @public_days = Day.where("date <= ?", Date.today - 8.hours)
                      .paginate(page: params[:page])
                      .order('date DESC')
  end
end
