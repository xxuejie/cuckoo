BASE_DIR = File.expand_path(File.dirname(__FILE__))

namespace :test do
  task :js_tests => [:js_uint, :js_e2e]

  task :js_uint do |t, args|
    start_testacular(File.join(BASE_DIR, %w[config testacular.conf.js]),
                     args[:misc_options])
  end

  task :js_e2e do |t, args|
    start_testacular(File.join(BASE_DIR, %w[config testacular-e2e.conf.js]),
                     args[:misc_options])
  end
end

# Original version taken from https://github.com/angular/angular.js/blob/master/Rakefile
def start_testacular(config, misc_options)
  sh "testacular start " +
    "#{config} " +
    "#{(misc_options || '').gsub('+', ',')}"
end
