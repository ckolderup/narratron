class SubmissionsController < ApplicationController
  before_filter :authorize, except: [:new, :create]

  def index
    @submissions = Submission.paginate(page: params[:page]).order('created_at DESC')
    next_twenty_days = (0..19).map { |x| (Day.pacific_time + x.days).to_date }
    @unassigned_days = next_twenty_days.reject { |d| Day.exists?(date: d) }
  end

  def new
    @submission = Submission.new
  end

  def new_story
    @submission = Submission.new
    @publish_now = true

    render :new
  end

  def create_and_publish
    @submission = Submission.new(submission_params)

    story = Story.new(thanks: @submission.author, title: @submission.title)
    entry = Entry.new(text: @submission.text, parent: story,
                      override_sentence_limit: true, user: current_user)
    unless story.save && entry.save
      flash[:error] = entry.errors.to_a.join(", ")
      redirect_to create_story_path and return
    end

    flash[:message] = "Story created!"
    redirect_to entry_path(entry)
  end

  def create
    @submission = Submission.new(submission_params)

    flash[:message] = "Submission received! Thanks, friend." if @submission.save
    redirect_to new_submission_path
  end

  def assign
    params.permit(:date)
    submission = Submission.find(params[:submission_id])

    story = Story.new(thanks: submission.author)
    entry = Entry.new(text: submission.text, parent: story, override_sentence_limit: true)
    unless story.save && entry.save
      flash[:error] = entry.errors.to_a.join(", ")
      redirect_to submissions_path and return
    end

    params.permit(:date)
    if day = Day.create(date: Date.parse(params[:date]), story: story)
      submission.destroy
      flash[:message] = "Submission queued for #{day.date.strftime('%A %d %b')}"
    end

    if Submission.any?
      redirect_to submissions_path
    else
      redirect_to queue_path
    end

  end

  def destroy
    @submission = Submission.find(params[:id])
    flash[:message] = "Submission deleted!" if @submission.destroy
    redirect_back_or_default(submissions_path)
  end

  private

  def submission_params
    params.require(:submission).permit(:id, :text, :title, :author)
  end
end
