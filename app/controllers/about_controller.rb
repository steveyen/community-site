class AboutController < ApplicationController
  caches_page :index, :users

  def index
  end

  def users
  end

  def test
  end

  def test_recaptcha
  end

  def test_recaptcha_go
    if verify_recaptcha
      render :text => 'recaptcha passed'
    else
      render :text => 'recaptcha failed'
    end
  end
end
