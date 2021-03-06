require "active_support/core_ext/object"

class UnixCommand
  TYPE = [
    "User Commands",
    "System Calls",
    "Library Functions",
    "Devices",
    "File Formats",
    "Games and Amusements",
    "Conventions and Miscellany",
    "System Administration"
  ]

  class << self
    def all
      @@all_results ||= []
      return @@all_results if @@all_results.any?

      apropos.each do |a|
        match_data = /(.*)\((.*)\)\s*-\s(.*)/.match(a)
        if match_data.blank?
          puts("couldn't  match #{a}")
          next
        end
        command, type, description = match_data[1, 3]
        unix_command = UnixCommand.new(command, type, description)
        if @@all_results.find { |cmd| cmd == unix_command }.nil?
          @@all_results << unix_command
        end
      end
      @@all_results.sort_by! { |cmd| cmd.name }
    end

    def find_by(options = {})
      all.find { |result| result.name == options[:name] }
    end

    def sample
      all.sample
    end

    private
    def apropos
      @@apropos_results ||= `apropos .* | col -b`.split("\n")
    end
  end

  attr_reader :name, :type, :description

  def initialize(name, type, description)
    @name = name
    @type = type
    @description = description
  end

  def type_name
    TYPES[type]
  end

  def man_page
    `man #{@name} | col -b`
  end

  def ==(other_command)
    self.name == other_command.name
  end
end
