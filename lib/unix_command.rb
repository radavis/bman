class UnixCommand
  TYPE = [
    "User Commands",
    "System Calls",
    "Library functions",
    "Devices",
    "File formats",
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
        command, type, description = match_data[1, 3]
        unix_command = UnixCommand.new(command, type, description)
        @@all_results << unix_command
      end
      @@all_results.sort_by! { |cmd| cmd.name }
    end

    def find_by(options = {})
      all.find { |result| result.name == options[:name] }
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
end
