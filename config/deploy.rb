# frozen_string_literal: true

require './config/deploy/cialfo-deploy/aws_util/resource_naming'
require './config/deploy/cialfo-deploy/aws_util/ec2'
require './config/deploy/cialfo-deploy/aws_util/auto_scaling_dynamic'
require './config/deploy/cialfo-deploy/aws_util/auto_scaling'
require './config/deploy/cialfo-deploy/aws_util/auto_scaling_policy'
require './config/deploy/cialfo-deploy/aws_util/cleanup_resources'

# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

set :application, "core-api"
set :repo_url, 'git@github.com:cialfo/app-cialfo-core-api.git'

set :user, 'deployer'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, "config/credentials/#{fetch(:stage)}.key", "config/credentials/#{fetch(:stage)}.yml.enc", ".env.#{fetch(:stage)}.local"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "public/uploads"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '3.1.2'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl puma pumactl}
set :rbenv_roles, :all # default value

set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
set :sidekiq_roles, -> { :sidekiq }

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(publickey)
}

set :whenever_roles, 'cron_master'

# INFO: (Stephan) these values are used when running cap puma:systemd:config and cap puma:config
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "tcp://0.0.0.0:3000"
set :puma_state,      "#{shared_path}/tmp/pids/server.state"
set :puma_pid,        "#{shared_path}/tmp/pids/server.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_service_unit_name, "puma.service"
set :puma_systemctl_user, fetch(:user)
set :puma_preload_app, true

# AWS settings
set :ec2_resource_region, 'ap-northeast-1'
# Core-Api-Web
set :resource_prefix_web, 'Core-Api-Web'
set :aws_resource_names_web, AwsUtil::ResourceNaming.new("#{fetch(:resource_prefix_web)}-#{fetch(:stage).capitalize}").call.to_h
set :aws_ec2_web, AwsUtil::Ec2.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_web))
set :aws_auto_scaling_web,
  AwsUtil::AutoScaling.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_web))
# set :aws_auto_scaling_policy_web, AwsUtil::AutoscalingPolicy.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_web))
set :aws_resource_cleanup_web, AwsUtil::CleanupResources.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_web))
# Core-Api-Sidekiq
set :resource_prefix_sidekiq, 'Core-Api-Sidekiq'
set :aws_resource_names_sidekiq, AwsUtil::ResourceNaming.new("#{fetch(:resource_prefix_sidekiq)}-#{fetch(:stage).capitalize}").call.to_h
set :aws_ec2_sidekiq, AwsUtil::Ec2.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_sidekiq))
set :aws_auto_scaling_sidekiq,
  AwsUtil::AutoScalingDynamic.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_sidekiq))
# set :aws_auto_scaling_policy_sidekiq, AwsUtil::AutoscalingPolicy.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_sidekiq))
set :aws_resource_cleanup_sidekiq, AwsUtil::CleanupResources.new(fetch(:stage), fetch(:ec2_resource_region), fetch(:aws_resource_names_sidekiq))

set :aws_servers_web, fetch(:aws_ec2_web).deployed_app_server_dns_names_with_user('deployer')
set :aws_servers_sidekiq, fetch(:aws_ec2_sidekiq).deployed_app_server_dns_names_with_user('deployer')
set :aws_servers_all, fetch(:aws_servers_web) + fetch(:aws_servers_sidekiq)

role :app, fetch(:aws_servers_web)
role :sidekiq, fetch(:aws_servers_sidekiq)

namespace :deploy do
  before :deploy, :check_stop_deployment_when_pending do
    puts 'Running Check to prevent deployment during pending'

    if fetch(:aws_ec2_web).instances_pending? || fetch(:aws_ec2_sidekiq).instances_pending?
      puts 'Instance is scaling up... Stopping deployment.'

      exit;
    end
  end
  # TODO: Stephan reenable autoscaling
  # before :starting, :pause_auto_scaling do
  #   puts 'Pausing autoscaling'
  #   fetch(:aws_auto_scaling_policy).pause_auto_scaling
  # end

  # after :finished, :resume_auto_scaling do
  #   puts 'Resuming autoscaling after finished'
  #   fetch(:aws_auto_scaling_policy).resume_auto_scaling
  # end

  after :finished, :cleanup_resources do
    puts 'Running Update Scaling AMI update'
    ami_id = fetch(:aws_auto_scaling_web)
    fetch(:aws_auto_scaling_sidekiq).run_call(ami_id)
    # puts 'Resuming autoscaling after finished'
    # fetch(:aws_auto_scaling_policy).resume_auto_scaling
    fetch(:aws_resource_cleanup_web).cleanup(30)
    fetch(:aws_resource_cleanup_sidekiq).cleanup(30)
  end
  after :finishing,          "deploy:cleanup"
end


namespace :aws do
  task :manual_update_scaling do
    if fetch(:aws_ec2_web).instances_pending?
      puts 'Instance is scaling up... Stopping deployment.'

      exit;
    end

    ami_id = fetch(:aws_auto_scaling_web)
    fetch(:aws_auto_scaling_sidekiq).run_call(ami_id)
    fetch(:aws_resource_cleanup_web).cleanup(30)
    fetch(:aws_resource_cleanup_sidekiq).cleanup(30)
  end

  task :print_servers_domains do
    server_domains = fetch(:main_server)
    server_domains << fetch(:extra_sidekiq_servers) if fetch(:extra_sidekiq_servers)
    server_domains << fetch(:aws_servers)
    puts '-----------------------------'
    server_domains.each do |server_name|
      puts server_name
    end
    puts '-----------------------------'
  end
end
