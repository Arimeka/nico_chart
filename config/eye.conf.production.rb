require 'eye-rotate'

Eye.load('./eye/*.rb')
ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Eye.config do
  logger File.join(ROOT, 'log', 'eye.log')
  log_rotate every: 1.day, count: 7, gzip: true
end

Eye.app 'nico_chart' do
  stop_on_delete true

  working_dir ROOT

  stdall './log/trash.log'

  env 'RAILS_ENV' => 'production'

  triggers :flapping, times: 10, within: 5.minute

  group 'sidekiq' do
    %w[sidekiq].each do |name|
      sidekiq_process(self, name, 'config/sidekiq.yml')
    end
  end

  group 'web' do
    web_server(self, 'nicochart-go', 'nicochart-go/main', 'config.yml', port: 5000)
  end
end
