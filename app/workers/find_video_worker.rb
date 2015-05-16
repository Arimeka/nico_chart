class FindVideoWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, unique: true, unique_job_expiration: 2 * 60 * 60

  def perform(id)
    begin
      Timeout.timeout(60) do
        Video.find(id).find_video
      end
    rescue => e
      Sidekiq.logger.error "[FindVideoWorker] #{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR: #{e.message}"
    end
  end
end
