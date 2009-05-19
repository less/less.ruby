module Less
  class Command
    def initialize options
      @source, @destination = options[:source], options[:destination]
      @options = options
    end
    def watch?() @options[:watch] end
    def compress?() @options[:compress] end
    
    # little function which allows us to Ctrl-C exit inside the passed block
    def watch &block
      begin
        block.call
      rescue Interrupt
        puts
        exit 0
      end
    end
      
    def run!
      if watch?
        log "Watching for changes in #@source ...Ctrl-C to abort.\n"
        #
        # Main watch loop
        #
        loop do
          watch { sleep 1 }
          
          # File has changed
          if File.stat( @source ).mtime > File.stat( @destination ).mtime
            log "Change detected... "
            #
            # Error loop
            #
            loop do
              begin
                compile
              rescue SyntaxError
                error = $!.message.split("\n")[1..-1].collect {|e| e.gsub(/\(eval\)\:\d+\:\s/, '') } * "\n"
                log " errors were found in the .less file! \n#{error}\n"
                log "Press [enter] to continue..."
                watch do
                  $stdin.gets
                  print "} "
                end
                next # continue within the error loop, until the error is fixed
              end
              break # break to main loop, as no errors were encountered
            end
          end # if
        end # loop
      else
        compile
      end
    end
    
    def compile
      begin
        # Create a new Less object with the contents of a file
        css = Less::Engine.new( File.read( @source ) ).to_css
        css = css.delete " \n" if compress?
        File.open( @destination, "w" ) do |file|
          file.write css
        end
        puts "#{@destination.split('/').last} was updated!" if watch?
      rescue Errno::ENOENT => e
        abort "#{e}"
      end
    end
    
    # Just a logging function to avoid typing '}'
    def log s = ''
      print '} ' + s.to_s
    end
  end
end