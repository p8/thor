require 'thor/shell/basic'

class Thor
  module Shell
    # Set color in the output. Got color values from HighLine.
    #
    class Color < Basic
      # Embed in a String to clear all previous ANSI sequences.
      CLEAR      = "\e[0m"
      # The start of an ANSI bold sequence.
      BOLD       = "\e[1m"

      # Set the terminal's foreground ANSI color to black.
      BLACK      = "\e[30m"
      # Set the terminal's foreground ANSI color to red.
      RED        = "\e[31m"
      # Set the terminal's foreground ANSI color to green.
      GREEN      = "\e[32m"
      # Set the terminal's foreground ANSI color to yellow.
      YELLOW     = "\e[33m"
      # Set the terminal's foreground ANSI color to blue.
      BLUE       = "\e[34m"
      # Set the terminal's foreground ANSI color to magenta.
      MAGENTA    = "\e[35m"
      # Set the terminal's foreground ANSI color to cyan.
      CYAN       = "\e[36m"
      # Set the terminal's foreground ANSI color to white.
      WHITE      = "\e[37m"

      # Set the terminal's background ANSI color to black.
      ON_BLACK   = "\e[40m"
      # Set the terminal's background ANSI color to red.
      ON_RED     = "\e[41m"
      # Set the terminal's background ANSI color to green.
      ON_GREEN   = "\e[42m"
      # Set the terminal's background ANSI color to yellow.
      ON_YELLOW  = "\e[43m"
      # Set the terminal's background ANSI color to blue.
      ON_BLUE    = "\e[44m"
      # Set the terminal's background ANSI color to magenta.
      ON_MAGENTA = "\e[45m"
      # Set the terminal's background ANSI color to cyan.
      ON_CYAN    = "\e[46m"
      # Set the terminal's background ANSI color to white.
      ON_WHITE   = "\e[47m"

      protected

        # Set color by using a string or one of the defined constants. Based
        # on Highline implementation. CLEAR is automatically be embedded to
        # the end of the returned String.
        #
        def set_color(string, color, bold=false)
          color = self.class.const_get(color.to_s.upcase) if color.is_a?(Symbol)
          bold  = bold ? BOLD : ""
          "#{bold}#{color}#{string}#{CLEAR}"
        end

        # Overwrite show_diff to show diff with colors if Diff::LCS is
        # available.
        #
        def show_diff(destination, content)
          if diff_lcs_loaded?
            actual  = File.read(destination).to_s.split("\n")
            content = content.to_s.split("\n")

            Diff::LCS.sdiff(actual, content).each do |diff|
              output_diff_line(diff)
            end
          else
            super
          end
        end

        def output_diff_line(diff)
          case diff.action
            when '-'
              say "- #{diff.old_element.chomp}", :red
            when '+'
              say "+ #{diff.new_element.chomp}", :green
            when '!'
              say "- #{diff.old_element.chomp}", :red
              say "+ #{diff.new_element.chomp}", :green
            else
              say "  #{diff.old_element.chomp}"
          end
        end

        # Check if Diff::LCS is loaded. If it is, use it to create pretty output
        # for diff.
        #
        def diff_lcs_loaded?
          return true  if defined?(Diff::LCS)
          return @diff_lcs_loaded unless @diff_lcs_loaded.nil?

          @diff_lcs_loaded = begin
            require 'diff/lcs'
            true
          rescue LoadError
            false
          end
        end

    end
  end
end