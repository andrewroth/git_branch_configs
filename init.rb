require 'git'

unless defined?(GitBranchConfigs)
  class GitBranchConfigs
    RAILS_ROOT = "#{File.dirname(__FILE__)}/../../" unless defined?(RAILS_ROOT)
    CONFIGS_PATH = "config/branch_configs"
    MAPPINGS_FILE = "#{CONFIGS_PATH}/branch_mappings.yml"

    def self.init
      if File.exists? MAPPINGS_FILE
        mappings = YAML::load(File.read(MAPPINGS_FILE))

        if mappings.class == Array

          g = Git.init
          git_branch = g.lib.branch_current

          # special case to handle specific checkout of an sha
          head = g.object('HEAD').sha
          if git_branch == "(no branch)" || git_branch == "deploy"
            for branch in (g.branches.remote + g.branches.local)
              if branch.gcommit.sha == head
                git_branch = branch.name
                break
              end
            end
          end

          for key_path in mappings
            key = key_path.keys.first
            path = key_path.values.first
            key =~ /\/(.*)\//
              if $1 && Regexp.new($1).match(git_branch)
                config_path = path
                break
              elsif key == git_branch
                config_path = path
              end
          end

          if config_path
            full_config_path = "#{CONFIGS_PATH}/#{config_path}"
            puts "Git Branch Config: #{git_branch} -> #{full_config_path}"
          else
            puts "Git Branch Config: no match"
          end

          if config_path && File.exists?(full_config_path)
            require full_config_path
          elsif config_path
            puts "Git Branch Config: config file specified does not exist"
          end
        end

      end

      true
    end
  end

  GitBranchConfigs.init
end
