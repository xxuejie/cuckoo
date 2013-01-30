basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'public/lib/angular/angular.js',
  'public/lib/angular/angular-*.js',
  'test/lib/angular/angular-mocks.js',
  'public/js/**/*.js',
  'test/unit/**/*.js',
  'public/lib/moment.min.js'
];

autoWatch = true;

browsers = ['Chrome'];

singleRun = true;

junitReporter = {
  outputFile: 'test_out/unit.xml',
  suite: 'unit'
};
