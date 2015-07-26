def sidekiq_process(proxy, name, config, options = {})
  memory       = options.fetch(:mem, 300.megabytes)
  quit_seconds = options.fetch(:quit_seconds, 5.seconds)
  term_seconds = options.fetch(:term_seconds, 5.seconds)

  opts = [
    "-e #{proxy.env['RAILS_ENV']}",
    "-C #{config}"
  ]

  proxy.process name do
    pid_file "tmp/pids/#{name}.pid"
    stdall "log/#{name}.log"
    daemonize true

    start_command "bundle exec sidekiq #{opts.join ' '}"
    stop_signals [:QUIT, quit_seconds, :TERM, term_seconds, :KILL]

    checks :cpu,    every: 30, below: 100,    times: 5
    checks :memory, every: 30, below: memory, times: 5
  end
end
