module Less
  class Command
    def initialize options
      @source, @destination = options[:source], options[:destination]
      @watch = options[:watch]
    end
    def watch?() @watch end
  
    def run!
      if watch?
        puts "} Watching for changes in #@source... Ctrl-C to abort."
        loop do
          begin
            sleep 1
          rescue Interrupt
            puts
            exit 0
           end
         
           # File has changed
           if File.stat(@source).mtime > File.stat(@destination).mtime
             begin
               print "} Change detected... "
               compile
             rescue StandardError => e
               puts "} Oh noes, an error was encountered! [#{e}]"
             end
           end
         end
      else
        compile
      end
    end
  
    def compile
      # Create a new Less object with the contents of a file
      begin
        parser = Less::Engine.new( File.read( @source ) )
        File.open( @destination, "w" ) do |file|
          file.write parser.to_css
        end
        puts "#{@destination.split('/').last} was updated!"
      rescue Errno::ENOENT => e
        abort "#{e}"
      end
    end
  end
end