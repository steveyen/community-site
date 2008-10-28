set :server_0,    "8.17.170.112"
set :user,        "metaha"
set :runner,      "metaha"
set :use_sudo,    false
set :deploy_to,   "/users/home/#{user}/domains/northscale.org/site"
set :application, "community-site"
set :repository,  "git://github.com/steveyen/community-site.git"

set :scm,    :git
set :branch, "master"
set :deploy_via, :remote_cache

role :app, "#{server_0}"
role :web, "#{server_0}"
role :db,  "#{server_0}", :primary => true
 
depend :remote, :command, "git"
depend :remote, :gem, "sqlite3-ruby", ">= 1.2"
depend :remote, :gem, "haml", ">= 1.8"
 

 
