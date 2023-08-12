class PagesController < ApplicationController
  def home
  end
  
  def profile
    @user = current_user

    render 'profile'
  end
end
