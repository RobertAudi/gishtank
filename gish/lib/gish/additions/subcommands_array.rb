class Gish::SubcommandsArray < Array
  MAX_SUBCOMMANDS = 2

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

  def <<(item)
    unless item.nil?
      begin
        self.command = fetch(count - 1) unless empty?
      rescue Gish::Exceptions::CommandNotFoundError
        return false
      end

      unless subcommand?(item)
        if command.class.to_s =~ /\AGish::Commands::Help\Z/
          exception = Gish::Exceptions::CommandNotFoundError.new item
        else
          command_name = command.class.to_s.split("::").last.downcase
          exception = Gish::Exceptions::SubcommandNotFoundError.new command_name, item
        end

        raise exception
      end

      if count < MAX_SUBCOMMANDS
        push item.to_sym
      else
        warn "#{MAX_SUBCOMMANDS} subcommands were already added. Replacing last one."
        self[MAX_SUBCOMMANDS - 1] = item.to_sym
      end
    end
  end

  private

  def subcommands
    command.class.subcommands
  end


  def subcommand?(item)
    subcommands.include?(item.to_sym) || command.respond_to?(item.to_sym)
  end
end
