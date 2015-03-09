require 'clockwork'

if ENV['RAILS_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load('.env.local')
end

module Clockwork
  handler do |job|
    puts "[gci] #{DateTime.now.utc.iso8601} Clockwork job #{job} started"
    result =
      case
        when job == 'process_commits'
          system('bin/rails runner lib/jobs/run_process_commits.rb')
        when job == 'backfill_ref_commits'
          system('bin/rails runner lib/jobs/run_backfill_ref_commits.rb')
        else
          raise "[gci] #{DateTime.now.utc.iso8601} Unknown Clockwork job '#{job}'"
      end
    if result
      puts "[gci] #{DateTime.now.utc.iso8601} Clockwork job #{job} finished"
    else
      raise "[gci] #{DateTime.now.utc.iso8601} Clockwork job #{job} failed"
    end
  end

  process_commits_interval =
    ENV['PROCESS_COMMITS_INTERVAL'] ? ENV['PROCESS_COMMITS_INTERVAL'].to_i : 15
  every(process_commits_interval.seconds, 'process_commits')

  backfill_ref_commits_interval =
    ENV['BACKFILL_REF_COMMITS_INTERVAL'] ? ENV['BACKFILL_REF_COMMITS_INTERVAL'].to_i : 30
  every(backfill_ref_commits_interval.seconds, 'backfill_ref_commits')
end
