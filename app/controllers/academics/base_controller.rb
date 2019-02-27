class Academics::BaseController < ActionController::Base
  add_breadcrumb I18n.t('breadcrumbs.homepage'), :academics_root_path

  layout 'layouts/academics/application'

  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
