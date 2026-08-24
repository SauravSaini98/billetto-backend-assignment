class ApplicationController < ActionController::Base
  include Clerk::Authenticatable
  
  helper_method :signed_in?, :current_user_id

  def require_authentication!
    redirect_to clerk&.sign_in_url || '/', alert: "You must be signed in to perform this action." unless clerk&.session
  end

  def signed_in?
    clerk&.session.present?
  end

  def current_user_id
    clerk&.session&.user_id
  end
end
