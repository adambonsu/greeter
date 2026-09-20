# frozen_string_literal: true

source "https://rubygems.org"
ruby "4.0.7"

gem "aws-sdk-dynamodb", "~> 1"

group :development, :test do
  gem "rspec", "~> 3.13"
  gem "cucumber", "~> 9.2"
  gem "rack-test"
  gem "rubocop", require: false
  gem "rubocop-rspec", require: false
  gem "brakeman", require: false        # static security analysis
  gem "bundler-audit", require: false   # dependency CVE audit
  gem "benchmark-ips"                   # micro-benchmarks
  gem "simplecov", require: false
end

# gem "rails"
