class DeviseOverrides::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  include EmailHelper

  def omniauth_success
    Rails.logger.info "omniauth_success 2"
    get_resource_from_auth_hash

    @resource.present? ? sign_in_user : sign_up_user
  end

  private

  def sign_in_user
    Rails.logger.info "sign_in_user p=#{params} ah=#{auth_hash} r=#{@resource}"
    @resource.skip_confirmation! if confirmable_enabled?

    Rails.logger.info "sign_in_user for #{@resource}"
    # once the resource is found and verified
    # we can just send them to the login page again with the SSO params
    # that will log them in
    encoded_email = ERB::Util.url_encode(@resource.email)
    redirect_to login_page_url(email: encoded_email, sso_auth_token: @resource.generate_sso_auth_token)
  end

  def sign_up_user
    return redirect_to login_page_url(error: 'no-account-found') unless account_signup_allowed?
    return redirect_to login_page_url(error: 'business-account-only') unless validate_business_account?

    create_account_for_user
    Rails.logger.info "signing in fresh user #{@resource}"
    sign_in_user
  end

  def login_page_url(error: nil, email: nil, sso_auth_token: nil)
    frontend_url = ENV.fetch('FRONTEND_URL', nil)
    params = { email: email, sso_auth_token: sso_auth_token }.compact
    params[:error] = error if error.present?

    "#{frontend_url}/app/login?#{params.to_query}"
  end

  def account_signup_allowed?
    # set it to true by default, this is the behaviour across the app
    GlobalConfigService.load('ENABLE_ACCOUNT_SIGNUP', 'false') != 'false'
  end

  def resource_class(_mapping = nil)
    User
  end

  def get_resource_from_auth_hash # rubocop:disable Naming/AccessorMethodName
    # find the user with their email instead of UID and token
    @resource = resource_class.where(
      email: auth_hash['info']['email']
    ).first
  end

  def validate_business_account?
    # return true if the user is a business account, false if it is a gmail account
    auth_hash['info']['email'].exclude?('@gmail.com')
  end

  def create_random_password
    charset = Array('A'..'Z') + Array('a'..'z') + Array(['?','-','$','#','+','*','=','/']) + Array('0'..'9')
    Array.new(64) { charset.sample }.join
  end

  def create_account_for_user
    Rails.logger.info "create_account_for_user for #{auth_hash['info']['email']} / #{auth_hash['uid']}"
    @resource, @account = AccountBuilder.new(
      account_name: extract_domain_without_tld(auth_hash['info']['email']),
      user_full_name: auth_hash['info']['name'],
      email: auth_hash['info']['email'],
      locale: I18n.locale,
      #confirmed: auth_hash['info']['email_verified'],
      confirmed: true,
      user_password: create_random_password
    ).perform
    Avatar::AvatarFromUrlJob.perform_later(@resource, auth_hash['info']['image'])
  end

  def default_devise_mapping
    'user'
  end
end
