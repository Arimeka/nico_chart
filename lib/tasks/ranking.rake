namespace :ranking do
  desc 'Aggregate rankings from NicoVideo'
  task aggreagte: :environment do
    begin
      Ranking.aggregate_rank('daily')
    rescue => e
      Rails.logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} AGGREGATE: daily ranking error: #{e.message}"
    end

    begin
      Ranking.aggregate_rank('weekly')
    rescue => e
      Rails.logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} AGGREGATE: weekly ranking error: #{e.message}"
    end

    begin
      Ranking.aggregate_rank('monthly')
    rescue => e
      Rails.logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} AGGREGATE: monthly ranking error: #{e.message}"
    end

    begin
      Ranking.aggregate_rank('total')
    rescue => e
      Rails.logger.error "#{Time.now.strftime("%Y.%m.%d %H:%M:%S")} AGGREGATE: total ranking error: #{e.message}"
    end
  end
end
