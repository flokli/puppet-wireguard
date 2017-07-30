require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

puppetlint_ignore_paths = [
  "bundle/**/*.pp",
  "pkg/**/*.pp",
  "spec/**/*.pp",
  "tests/**/*.pp",
  "types/**/*.pp",
  "vendor/**/*.pp",
]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new(:lint) do |config|
  config.fail_on_warnings = true
  config.disable_checks = ['80chars', 'documentation']
  config.ignore_paths = puppetlint_ignore_paths
end
PuppetLint::RakeTask.new(:lint_fix) do |config|
  config.fail_on_warnings = true
  config.fix = true
  config.disable_checks = ['80chars', 'documentation']
  config.ignore_paths = puppetlint_ignore_paths
end
# vim: syntax=ruby
