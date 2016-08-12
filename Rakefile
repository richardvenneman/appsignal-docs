require "middleman-s3_sync"
require "middleman-cloudfront"

desc "Build the website from source"
task :build do
  puts "## Building website"
  status = system("bundle exec middleman build --clean")
  puts status ? "OK" : "FAILED"
end

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("bundle exec middleman server")
end

desc "Deploy website via rsync"
task :deploy do
   puts '## Syncing to S3...'
   system "bundle exec middleman s3_sync"
   puts '## Invalidating cloudfront...'
   system "bundle exec middleman invalidate"
   puts '## Deploy complete.'
end

desc "Clean up the deploy"
task :cleanup do
  puts "## Cleaning build"
  status = system("rm -rf build")
  puts status ? "OK" : "FAILED"
end

desc "Build and deploy website"
task :build_deploy => [:build, :deploy, :cleanup]
