require 'git'

RAILS_ROOT = "#{File.dirname(__FILE__)}/../../" unless defined?(RAILS_ROOT)
CONFIGS_PATH = "config/branch_configs"
MAPPINGS_FILE = "#{CONFIGS_PATH}/branch_mappings.yml"

if File.exists? MAPPINGS_FILE
  # TODO: get current git branch
  mappings = YAML::load(File.read(MAPPINGS_FILE))

  for key_path in mappings
    key = key_path.keys.first
    path = key_path.values.first
    key =~ /\/(.*)\//
    if $1 && Regexp.new($1).match(git_branch)
      config = path
      break
    elsif key == git_branch
      config = path
    end
  end

  puts "Git Branch Config: #{config}" if config

  unless File.exists?(config)
    puts "Git Branch Config: config file specified does not exist"
  end
end

