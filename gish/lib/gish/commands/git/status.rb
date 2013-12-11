class Gish::Commands::Git::Status < Gish::Commands::BasicCommand
  COLORS = {
    paint_rst:    [:white,  false],  # Reset
    paint_del:    [:red,    false],  # Deleted
    paint_mod:    [:green,  false],  # Modified
    paint_new:    [:yellow, false],  # New
    paint_ren:    [:blue,   false],  # Renamed
    paint_cpy:    [:yellow, false],  # Copied
    paint_typ:    [:purple, false],  # Type change
    paint_unt:    [:cyan,   false],  # Untracked
    paint_dark:   [:black,   true],  # Grayed-out
    paint_branch: [:white,   true],  # Branch
    paint_header: [:white,  false]   # Header
  }

  GROUP_COLORS = {
    paint_staged:    :yellow,
    paint_unmerged:  :red,
    paint_unstaged:  :green,
    paint_untracked: :cyan
  }

  def initialize
    @project_root = File.directory?(File.join(Dir.getwd, ".git")) ? Dir.getwd : `\git rev-parse --show-toplevel 2> /dev/null`.strip

    raise Gish::Exceptions::Git::NotAGitRepositoryError.new directory: Dir.getwd if @project_root.empty?

    @status = `\git status --porcelain 2> /dev/null`

    git_branch = `\git branch -v 2> /dev/null`
    @branch = git_branch[/^\* (\(no branch\)|[^ ]*)/, 1]
    @ahead = git_branch[/^\* [^ ]* *[^ ]* *\[ahead ?(\d+).*\]/, 1]
    @behind = git_branch[/^\* [^ ]* *[^ ]* *\[.*behind ?(\d+)\]/, 1]

    @changes = @status.split("\n")

    if @changes.count > ENV["GISHTANK_GISH_STATUS_MAX_CHANGES"].to_i
      raise Gish::Exceptions::Git::TooManyChangesError.new changes: @changes.count
    end

    @stats = {
      :staged    => [],
      :unmerged  => [],
      :unstaged  => [],
      :untracked => []
    }

    @files_output = []
  end

  define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
    @output_files = []
    @env_counter = 0

    # Show how many commits we are ahead and/or behind origin
    difference = ["-#{@behind}", "+#{@ahead}"].select{ |diff| diff.length > 1 }.join('/')
    if difference.length > 0

      diff = ""
      diff << paint_dark(message: " | ")
      diff << paint_new(message: difference)
      difference = diff
    else
      difference = ""
    end

    output = ""
    output << paint_dark(message: "#")
    output << " On branch: "
    output << paint_branch(message: @branch)
    output << difference
    output << paint_dark(message: " | ")

    if @status.empty?
      output << paint_mod(message: "No changes (working directory clean)")
    else
      output << paint_dark(message: "[")
      output << "*"
      output << paint_dark(message: "]")
      output << " => $#{ENV["GISHTANK_GISH_GIT_ENV_CHAR"]}*\n"
      output << paint_dark(message: "#\n")
    end

    index_modification_states

    groups_spec = [
      [:staged,          'Changes to be committed'],
      [:unmerged,                 'Unmerged paths'],
      [:unstaged,  'Changes not staged for commit'],
      [:untracked,               'Untracked files']
    ]

    groups_spec.each_with_index do |data, i|
      group, heading = *data

      # Allow filtering by specific group (by string or integer)
      if arguments.empty? || arguments.first == group.to_s || arguments.first == (i + 1).to_s
        unless @stats[group].empty?
          output << send("paint_#{group}", message: "\u27A4".encode("utf-8"), bold: true)
          output << paint_header(message: "  #{heading}\n")
          output << send("paint_#{group}", message: "#")
          output << "\n"
          output << output_for(group: group)
          output << "\n"
        end
      end
    end

    # TODO: The following is only outputed if debug mode is ON
    # DEBUG MODE NEEDS TO BE IMPLEMENTED
    #
    # output << "@@filelist@@::"
    # output << @files_output.map {|f|
    #   # If file starts with a '~', treat it as a relative path.
    #   # This is important when dealing with symlinks
    #   f.start_with?("~") ? f.sub(/~/, '') : File.join(@project_root, f)
    # }.join("|")

    puts output
  end

  private

  COLORS.each do |color, color_spec|
    define_method color do |message: ""|
      send(color_spec.first, message: message, bold: color_spec.last)
    end
  end

  GROUP_COLORS.each do |group, color|
    define_method group do |message: "", bold: false|
      send(color, message: message, bold: bold)
    end
  end

  def has_modules?
    @has_modules ||= File.exists?(File.join(@project_root, '.gitmodules'))
  end

  def index_modification_states
    @changes.each do |change|
      # FIXME: Rename x and y to something more meaningful
      x, y, file = change[0, 1], change[1, 1], change[3..-1]

      # Fetch the long git status once, but only if any submodules have changed
      if @long_status.nil? && has_modules?
        @submodules ||= File.read(File.join(@project_root, '.gitmodules'))

        # If changed 'file' is actually a git submodule
        if @submodules.include?(file)
          # Parse long git status for submodule summaries
          @long_status = `\git status`
        end
      end

      message, colour, group = case change[0..1]
      when "DD"; ["   both deleted",  :paint_del, :unmerged]
      when "AU"; ["    added by us",  :paint_new, :unmerged]
      when "UD"; ["deleted by them",  :paint_del, :unmerged]
      when "UA"; ["  added by them",  :paint_new, :unmerged]
      when "DU"; ["  deleted by us",  :paint_del, :unmerged]
      when "AA"; ["     both added",  :paint_new, :unmerged]
      when "UU"; ["  both modified",  :paint_mod, :unmerged]
      when /M./; ["  modified",       :paint_mod, :staged]
      when /A./; ["  new file",       :paint_new, :staged]
      when /D./; ["   deleted",       :paint_del, :staged]
      when /R./; ["   renamed",       :paint_ren, :staged]
      when /C./; ["    copied",       :paint_cpy, :staged]
      when /T./; ["typechange",       :paint_typ, :staged]
      when "??"; [" untracked",       :paint_unt, :untracked]
      end


      # Store data
      @stats[group] << { message: message, colour: colour, file: file } if message

      # Work tree modification states
      if y == "M"
        @stats[:unstaged] << { message: "  modified", colour: :paint_mod, file: file }
      elsif y == "D" && x != "D" && x != "U"
        # Don't show deleted 'y' during a merge conflict.
        @stats[:unstaged] << { message: "   deleted", colour: :paint_del, file: file }
      elsif y == "T"
        @stats[:unstaged] << { message: "typechange", colour: :paint_typ, file: file }
      end
    end
  end

  def relative_path(base, target)
    back = ""

    while target.sub(base,'') == target
      base = base.sub(/\/[^\/]*$/, '')
      back = "../#{back}"
    end

    "#{back}#{target.sub("#{base}/",'')}"
  end

  # Output files
  def output_for(group: "")
    # TODO: Raise custom exception
    raise if group.empty?

    output = ""

    # Print colored hashes & files based on modification groups
    # c_group = "\033[0;#{@group_c[group]}"

    @stats[group].each do |stat|
      @env_counter += 1
      padding = (@env_counter < 10 && @changes.size >= 10) ? " " : ""

      # Find relative path, i.e. ../../lib/path/to/file
      relative_file = relative_path(Dir.pwd, File.join(@project_root, stat[:file]))

      # If some submodules have changed, parse their summaries from long git status
      sub_stat = nil
      unless @long_status.nil?
        sub_stat = @long_status[/#{stat[:file]} \((.*)\)/, 1]

        unless sub_stat.nil?
          # Format summary with parantheses
          sub_stat = "(#{submodule_stat})"
        end
      end

      output << send("paint_#{group}", message: "#     ")
      output << send(stat[:colour], message: stat[:message])
      output << ":#{padding}"
      output << paint_dark(message: " [")
      output << @env_counter.to_s
      output << paint_dark(message: "] ")
      output << send("paint_#{group}", message: relative_file)
      output << " #{sub_stat}\n"

      # Save the ordered list of output files
      # fetch first file (in the case of oldFile -> newFile) and remove quotes
      if stat[:message] =~ /typechange/
        # Only use relative paths for 'typechange' modifications.
        @files_output << "~#{relative_file}"
      elsif stat[:file] =~ /^"([^\\"]*(\\.[^"]*)*)"/
        # Handle the regex above..
        @files_output << $1.gsub(/\\(.)/,'\1')
      else
        # Else, strip file
        @files_output << stat[:file].strip
      end
    end

    output << send("paint_#{group}", message: "#")
    output
  end
end
