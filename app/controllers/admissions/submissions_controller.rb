class Admissions::SubmissionsController < ApplicationController
  skip_before_filter :authenticate_user!,        :only => [:new, :create]
  skip_before_filter :change_password_if_needed, :only => [:new, :create]

  before_filter :find_submission, :only => [:show, :attachment, :update,
                                              :comment ]
  before_filter :find_available_slots, :only => [:new, :create]
  before_filter :admin_required,  :only => [:update]
  before_filter :authorized_users_required, :only => [:show, :index, :comment]

  def index
    @submissions = Admissions::Submission.order("admissions_submissions.created_at")

    unless current_access_level.allows?(:update_admissions_status)
      @submissions = @submissions.reviewable
    end
  end

  def show
    @statuses = Admissions::Status.order('sort_order').map {|s| [s.name, s.id]}
  end

  def thanks

  end

  def comment
    @submission.create_comment(params[:comment].merge(:user_id => current_user.id))

    if current_access_level.allows? :update_admissions_status
      @submission.update_attribute(:status_id, params[:status_id])
    end

    flash[:notice] = "Comment posted."

    redirect_to :action => :show
  end

  def attachment
    send_data(File.binread(@submission.attachment))
  end

  def new
    @user = User.new
    @user.admissions_submission = Admissions::Submission.new
  end

  def create
    @user = User.new(params[:user])
    @user.admissions_submission ||= Admissions::Submission.new

    if @user.save
      @user.update_attribute(:requires_password_change, false)
      @user.update_attribute(:access_level, "applicant")

      flash[:notice] = "Your application has been sucessfully created!"

      sign_in(@user)

      redirect_to thanks_admissions_submission_path(@user.admissions_submission)
    else
      render :action => :new
    end
  end

  def update
    @submission.update_attribute(:status_id, params[:value])

    render :text => @submission.status.name
  end

  private

  def find_submission
    @submission = Admissions::Submission.find(params[:id])
  end

  def authorized_users_required
    unless current_access_level.allows?(:discuss_admissions)
      flash[:error] = "Your account does not have access to this area"
      redirect_to dashboard_path
    end
  end

  def find_available_slots
    @open = Course.find_by_id(CURRENT_COURSE).try(:available_slots) || 0
  end
end
