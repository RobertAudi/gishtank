class Gish::SubcommandsArray < Gish::CommandableArray
  MAX_SUBCOMMANDS = 2

  def <<(item)
    unless item.nil? || option?(item) || !has_subcommands?
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

  def has_subcommands?
    command.class.has_subcommands?
  end

  def subcommands
    command.class.subcommands
  end


  def subcommand?(item)
    subcommands.include?(item.to_sym) || command.respond_to?(item.to_sym)
  end
end
