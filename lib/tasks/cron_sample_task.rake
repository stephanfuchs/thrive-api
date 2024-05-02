desc 'Whenever Sample rake task'
task cron_sample_task: :environment do
  Rails.logger.info "Cron Sample Task"
end
