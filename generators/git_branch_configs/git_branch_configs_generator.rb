class DatabaseGitProxyGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "config/branch_configs"
      m.file "config_mappings.yml", "config/branch_configs/branch_mappings.yml"
    end
  end
end