BASE_DIR = File.expand_path(File.dirname(__FILE__))
REDIS_CONF = File.join(BASE_DIR, %w[config redis.conf])
REDIS_PID = File.join(BASE_DIR, %w[tmp redis.pid])

APP_PID = File.join(BASE_DIR, %w[tmp app.pid])

desc "start a pry console"
task :console do |t|
  sh "bundle exec pry -r ./app.rb"
end

# start redis server for testing
task :start_redis_server do |t|
  unless File.exist?(REDIS_PID)
    system "redis-server #{REDIS_CONF}"
  end
end

# stop redis server for testing
task :stop_redis_server do |t|
  if File.exists?(REDIS_PID)
    system "kill #{File.read(REDIS_PID)}"
    File.delete(REDIS_PID)
  end
end

# start app server for testing
task :start_app_server do |t|
  unless File.exists?(APP_PID)
    system "E2E_TEST=true nohup ./app.rb > ./tmp/app.log 2>&1 &"
  end
end

task :stop_app_server do |t|
  if File.exists?(APP_PID)
    system "kill #{File.read(APP_PID)}"
    File.delete(APP_PID)
  end
end

namespace :test do
  task :all => [:rspec, :js_unit]

  task :js_unit do |t, args|
    start_testacular(File.join(BASE_DIR, %w[config testacular.conf.js]),
                     args[:misc_options])
  end

  task :js_e2e do |t, args|
    start_testacular(File.join(BASE_DIR, %w[config testacular-e2e.conf.js]),
                     args[:misc_options])
  end

  task :rspec do |t|
    sh "rspec"
  end
end

# Original version taken from https://github.com/angular/angular.js/blob/master/Rakefile
def start_testacular(config, misc_options)
  sh "testacular start " +
    "#{config} " +
    "#{(misc_options || '').gsub('+', ',')}"
end
