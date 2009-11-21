module Less
  class Command
    attr_accessor :source, :destination, :options

    def initialize options
      $verbose = options[:debug]
      @source = options[:source]
      @destination = (options[:destination] || options[:source]).gsub /\.(less|lss)/, '.css'
      @options = options
      @mutter = Mutter.new.clear
    end

    def watch?()    @options[:watch]    end
    def compress?() @options[:compress] end
    def debug?()    @options[:debug]    end

    # little function which allows us to
    # Ctrl-C exit inside the passed block
    def watch
      begin
        yield
      rescue Interrupt
        puts
        exit 0
      end
    end

    def run!
      if watch?
        parse(true) unless File.exist? @destination

        log "Watching for changes in #@source... Ctrl-C to abort.\n: "

        # Main watch loop
        loop do
          watch { sleep 1 }

          # File has changed
          if File.stat( @source ).mtime > File.stat( @destination ).mtime
            print Time.now.strftime("%H:%M:%S -- ") if @options[:timestamps]
            print "Change detected... "

            # Loop until error is fixed
            until parse
              log "Press [return] to continue..."
              watch { $stdin.gets }
            end
          end
        end
      else
        parse
      end
    end

    def parse new = false
      begin
        # Create a new Less object with the contents of a file
        css = Less::Engine.new(File.new(@source), @options).to_css
        css = css.delete " \n" if compress?

        File.open( @destination, "w" ) do |file|
          file.write css
        end

        act, file = (new ? 'Created' : 'Updated'), @destination.split('/').last
        print "#{o("* #{act}", :green)} #{file}\n: " if watch?
        Growl.notify "#{act} #{file}", :title => 'LESS' if @options[:growl] && @options[:verbose]
      rescue Errno::ENOENT => e
        abort "#{e}"
      rescue SyntaxError => e
        err "#{e}\n", "Syntax"
      rescue CompileError => e
        err "#{e}\n", "Compile"
      rescue MixedUnitsError => e
        err "`#{e}` you're  mixing units together! What do you expect?\n", "Mixed Units"
      rescue PathError => e
        err "`#{e}` was not found.\n", "Path"
      rescue VariableNameError => e
        err "#{o(e, :yellow)} is undefined.\n", "Variable Name"
      rescue MixinNameError => e
        err "#{o(e, :yellow)} is undefined.\n", "Mixin Name"
      else
        true
      end
    end

    # Just a logging function to avoid typing '*'
    def log s = ''
      print '* ' + s.to_s
    end

    def err s = '', type = ''
      type = type.strip + ' ' unless type.empty?
      $stderr.print "#{o("! #{type}Error", :red)}: #{s}"
      if @options[:growl]
        growl = Growl.new
        growl.title = "LESS"
        growl.message = "#{type}Error in #@source!"
        growl.run
        false
      end
    end

  private

    def o ex, *styles
      @mutter.process(ex.to_s, *(@options[:color] ? styles : []))
    end
  end
end
