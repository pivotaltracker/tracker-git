class ProcessCommits
  def process
    return if ENV['DISABLE_PROCESS_COMMITS'] == 'true'
    puts "#{DateTime.now.utc.iso8601} [Clockwork ProcessCommits] Started Running"
    pushes = Push.where(commits_processed: false)
    commit_count = 0
    pushes.each do |push|
      ActiveRecord::Base.transaction do
        push.commits_hashes_from_payload.each do |push_commit_hash|
          CommitFactory.new.create(push_commit_hash.fetch('id'),push.id)
          commit_count += 1
        end
        push.update_attributes!(commits_processed: true)
      end
    end

    puts "#{DateTime.now.utc.iso8601} [Clockwork ProcessCommits] Finished Running, processed #{pushes.size} pushes and #{commit_count} commits."
  end
end