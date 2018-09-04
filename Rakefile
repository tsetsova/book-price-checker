require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec

task default: [:spec]

task :list do
  system('ruby lib/main.rb -l | jq')
end

task :refresh do
  system('ruby lib/main.rb -r | jq')
end
