class Gish::OptionsArray < Gish::CommandableArray
  def parse!
    return if command.arguments.empty? || command.valid_options.nil?

    indices_to_delete = []

    command.arguments.each_with_index do |arg, index|
      if option?(arg)
        self << arg
        indices_to_delete << index
      end
    end

    unless indices_to_delete.empty?
      indices_to_delete.sort { |x, y| y <=> x }.each { |index| command.arguments.delete_at index }
    end
  end

  def <<(item)
    unless valid?(item)
      raise Gish::Exceptions::InvalidOptionsError.new options: [item]
    end

    push item
  end

  private

  def valid?(item)
    candidate_keys = [:root]
    candidate_keys << command.subcommands.first unless command.subcommands.empty?

    candidates = []
    candidate_keys.each { |ck| candidates << command.valid_options[ck] }

    candidates.flatten.include?(item)
  end
end
