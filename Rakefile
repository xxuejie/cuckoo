BASE_DIR = File.expand_path(File.dirname(__FILE__))

desc "start a pry console"
task :console do |t|
  sh "bundle exec pry -r ./app.rb"
end

namespace :test do
  task :all => [:rspec, :js_unit]

  task :js_unit do |t, args|
    start_testacular(File.join(BASE_DIR, %w[config testacular.conf.js]),
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
