ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# INFO: (Stephan) taken from https://jeremy.wadsack.com/2018/10/05/disable-rails-bootsnap-in-production/
begin
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
rescue LoadError
# bootsnap is an optional dependency, so if we don't have it it's fine
# Do not load in production because file system (where cache would be written) is read-only
nil
end
