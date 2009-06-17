module Less
  class Command
    CSS = '.css'

    attr_accessor :source, :destination, :options

    def initialize options
      @source = options[:source]
      @destination = (options[:destination] || options[:source]).gsub /\.(less|lss)/, CSS
      @options = options
    end


    def watch?()    @options[:watch]    end
    def compress?() @options[:compress] end
    def debug?()    @options[:debug]    end

    # little function which allows us to
    # Ctrl-C exit inside the passed block
    def watch &block
      begin
        block.call
      rescue Interrupt
        puts
        exit 0
      end
    end

    def run!
      compile(true) unless File.exist? @destination

      if watch?
        log "Watching for changes in #@source ...Ctrl-C to abort.\n"

        # Main watch loop
        loop do
          watch { sleep 1 }

          # File has changed
          if File.stat( @source ).mtime > File.stat( @destination ).mtime
            log "Change detected... "

            # Loop until error is fixed
            until compile
              log "Press [enter] to continue..."
              watch { $stdin.gets }
            end
          end
        end
      else
        compile
      end
    end

    def compile new = false
      begin
        # Create a new Less object with the contents of a file
        css = Less::Engine.new( File.read( @source ) ).to_css @options[:inheritance]
        css = css.delete " \n" if compress?

        File.open( @destination, "w" ) do |file|
          file.write css
        end
        puts "#{new ? '* [Created]' : ' [Updated]'} #{@destination.split('/').last}" if watch?
      rescue Errno::ENOENT => e
        abort "#{e}"
      rescue SyntaxError
        error = debug?? $! : $!.message.split("\n")[1..-1].collect {|e|
          e.gsub(/\(eval\)\:(\d+)\:\s/, 'line \1: ')
        } * "\n"
        err "errors were found in the .less file! \n#{error}\n"
      rescue MixedUnitsError => e
        err "`#{e}` you're  mixing units together! What do you expect?\n"
      rescue PathError => e
        err "`#{e}` was not found.\n"
      else
        true
      end
    end

    # Just a logging function to avoid typing '}'
    def log s = ''
      print '* ' + s.to_s
    end

    def err s = ''
      print "!! #{s}"
    end
  end
end