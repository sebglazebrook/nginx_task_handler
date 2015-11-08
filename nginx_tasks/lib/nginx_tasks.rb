require 'nginx_tasks/version.rb'
require "pathname"

module Nginx
  class Config

    def self.add_server(application_name, server_ip, server_port)
      application = Nginx::Application.find_by_name(application_name)
      application.add_upstream_server(server_ip, server_port)
    end

    def self.remove_server(application_name, server_ip, server_port)
      application = Nginx::Application.find_by_name(application_name)
      application.remove_upstream_server(server_ip, server_port)

    end

  end

  class Application

    attr_reader :name

    def self.find_by_name(name)
      if config_exists_for?(name)
        Application.new(name)
      else
        raise "Application '#{name}' not found!"
      end
    end

    def self.config_exists_for?(name)
      Pathname.new("/etc/nginx/sites-available/#{name}.conf").exist?
    end

    def initialize(name)
      @name = name
      @config_path = Pathname.new("/etc/nginx/sites-available/#{name}.conf")
    end

    def add_upstream_server(server_ip, server_port)
      current_contents = File.read(@config_path)
      new_contents = current_contents.gsub(/}/, "  server #{server_ip}:#{server_port};\n}")
      File.open(@config_path, "w") { |file| file.write(new_contents) }
    end

    def remove_upstream_server(server_ip, server_port)
      current_contents = File.read(@config_path)
      new_contents = current_contents.gsub(/^\s*server\s+#{server_ip}:#{server_port};\s*$\n/, "")
      File.open(@config_path, "w") { |file| file.write(new_contents) }
    end

  end
end
