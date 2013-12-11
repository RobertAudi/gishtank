class Gish::Exceptions::Git::TooManyChangesError < SystemStackError
  def initialize(message: "", changes: 0)
    raise ArgumentError if !message.empty? && changes > 0

    if message.empty?
      message << "gish: Too many changes "

      if changes.abs == 0
        message << "(over #{ENV["GISHTANK_GISH_STATUS_MAX_CHANGES"]} changes)"
      else
        message << "(#{changes.abs} changes, max: #{ENV["GISHTANK_GISH_STATUS_MAX_CHANGES"]} changes)"
      end
    end

    super message
  end
end
