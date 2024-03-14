require_relative '../../test_helper'

class TestOmniAuthReddit < StrategyTestCase
  def test_it_has_the_correct_site
    assert_match(/reddit.com/, strategy.client.site)
  end

  def test_it_has_the_correct_authorize_url
    assert_equal 'https://www.reddit.com/api/v1/authorize', strategy.client.authorize_url
  end

  def test_it_has_the_correct_token_url
    assert_equal 'https://www.reddit.com/api/v1/access_token', strategy.client.token_url
  end

  # Reddit OAuth requests require an HTTP Basic Authorization header
  # The format is:
  # Authorization: Basic base64encode(client_id:client_secret)
  def test_it_should_build_a_basic_authorization_header
    assert_equal 'Basic cmR0MTIzOjUzY3IzdHo=', strategy.basic_auth_header
  end
end

class OmniAuthRedditIntegrationTests < StrategyIntegrationTestCase
  def test_callback_request_should_include_authorization_header
    # WebMock converts the Authorization header into a username:password URL
    # https://github.com/bblimke/webmock/blob/2c596fa8ce9217a05ce2c188df8593431dc96796/lib/webmock/http_lib_adapters/net_http.rb#L240
    stub_request(:post, 'https://www.reddit.com/api/v1/access_token')
      .with(
        body: { 'code' => 'requestcode', 'grant_type' => 'authorization_code',
                'redirect_uri' => 'http://example.org/auth/reddit/callback' },
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic aWQ6c2VjcmV0',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'User-Agent' => 'Faraday v2.9.0'
        }
      )
      .to_return(status: 200, body: '', headers: {})

    get '/auth/reddit/callback?state=state&code=requestcode', {},
        'rack.session' => { 'callback_confirmed' => true, 'omniauth.state' => 'state' }
    assert_requested :post, 'https://www.reddit.com/api/v1/access_token'
  end
end
