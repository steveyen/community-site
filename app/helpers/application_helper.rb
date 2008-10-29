require 'haml'

module ApplicationHelper
  def site_domain_name
    ActiveRecord::Base.configurations[RAILS_ENV]['site_domain_name']
  end

  def support_email_address
    'support@' + site_domain_name
  end

  def blog_posts(offset = 0, limit = 3)
    posts = IO.readlines("#{RAILS_ROOT}/app/views/blog/_posts.html.haml", "\.blog_post\n")
    haml  = ".blog_post\n" + posts[(offset + 1)..(offset + limit)].join
    Haml::Engine.new(haml).render
  end
end

