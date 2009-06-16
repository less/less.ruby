module Less
  class Command
    def initialize options
      @source, @destination = options[:source], options[:destination]
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
        puts " [Updated] #{@destination.split('/').last}" if watch?
      rescue Errno::ENOENT => e
        abort "#{e}"
      rescue SyntaxError
        error = debug?? $! : $!.message.split("\n")[1..-1].collect {|e| 
          e.gsub(/\(eval\)\:(\d+)\:\s/, 'line \1: ') 
        } * "\n"
        log " !! errors were found in the .less file! \n#{error}\n"
      rescue MixedUnitsError
        log "!! You're  mixing units together! what do you expect?\n"
      else
        true
      end
    end
    
    # Just a logging function to avoid typing '}'
    def log s = ''
      print '} ' + s.to_s
    end
  end
end