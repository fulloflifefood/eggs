class ActivationsController < ApplicationController
  skip_before_filter :authenticate
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user = User.find_using_perishable_token(params[:activation_code], 0)
    
    if @user
      if @user.active?
        flash[:notice] = "Your account is already active"
        redirect_to root_url if @user.active?
      end
    else
      flash[:notice] = "That activation code is invalid"
      redirect_to root_url
    end


  end

  def create
    @user = User.find(params[:id])

    if @user.active?
      flash[:notice] = "Looks like your account is already active.  Try logging in."
      redirect_to login_url
    elsif @user.activate!(params)
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      redirect_to root_url
    else
      render :action => :new
    end
  end

end
