# frozen_string_literal: true

require 'spec_helper'

module ShellInjectionCheck
  REPO_ROOT = File.expand_path('../..', __dir__)

  SOURCE_DIRS = %w[
    lib/greeter/domain
    lib/greeter/adapters
    lib/greeter/ports
  ].freeze

  # Each entry: [label, regexp]
  FORBIDDEN = [
    ['backtick operator',               /`/],
    ['Kernel#system',                   /\bsystem\s*[(\s]/],
    ['%x{} shell expansion',            /%x[{(|!\/]/],
    ['Kernel#exec',                     /\bexec\s*[(\s]/],
    ['Kernel#eval / BasicObject#eval',  /\beval\s*[(\s]/],
    ['Open3 / IO.popen',                /\bpopen\b/],
    ['spawn',                           /\bspawn\s*[(\s]/]
  ].freeze

  def self.source_files
    SOURCE_DIRS.flat_map do |dir|
      Dir[File.join(REPO_ROOT, dir, '**', '*.rb')]
    end
  end
end

RSpec.describe 'No shell injection primitives in domain and adapter source' do
  let(:source_files) { ShellInjectionCheck.source_files }

  it 'finds at least one source file to inspect' do
    expect(source_files).not_to be_empty
  end

  ShellInjectionCheck.source_files.each do |path|
    relative = path.sub("#{ShellInjectionCheck::REPO_ROOT}/", '')
    source   = File.read(path)

    ShellInjectionCheck::FORBIDDEN.each do |label, pattern|
      it "#{relative} contains no #{label}" do
        expect(source).not_to match(pattern),
                              "#{relative} contains forbidden pattern '#{label}' (#{pattern.inspect})"
      end
    end
  end
end
