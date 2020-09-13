ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' if ENV.fetch('ENABLE_BOOTSNAP', 'true') == 'true'
require 'bootsnap/setup'
