class Gish::CommandableArray < Array
  include Gish::Concerns::Optionable

  def initialize(cmd)
    self.command = cmd
  end

  def command=(cmd)
    if cmd.class.to_s =~ /\AGish::Commands::.*\Z/
      @command = cmd
    else
      raise Gish::Exceptions::CommandNotFoundError.new cmd if cmd =~ /\Abasiccommand\Z/i

      if Gish::Commands::LIST.include?(cmd.to_s)
        @command = Gish.const_get("Commands::#{cmd.capitalize}").new
      elsif Gish::Commands::Git::LIST.include?(cmd.to_s)
        @command = Gish.const_get("Commands::Git::#{cmd.capitalize}").new
      else
        raise Gish::Exceptions::CommandNotFoundError.new cmd
      end
    end
  rescue NameError => e
    unknown_command = e.message.split.last
    raise Gish::Exceptions::CommandNotFoundError.new(unknown_command)
  end

  def command
    @command ||= Gish::Commands::Help.new
  end
end
