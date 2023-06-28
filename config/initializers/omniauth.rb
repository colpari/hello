Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV.fetch('GOOGLE_OAUTH_CLIENT_ID', nil), ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET', nil), {
    provider_ignores_state: true
  }
  provider :openid_connect, {
    name: :openid_connect,
    issuer: ENV.fetch('OIDC_ISSUER', nil),
    discovery: true,
    scope: [:openid, :email, :profile],
    #TODO: post_logout_redirect_uri
    client_options: {
      identifier: ENV.fetch('OIDC_CLIENT_ID', nil),
      secret: ENV.fetch('OIDC_SECRET', nil),
    }
  }
end
