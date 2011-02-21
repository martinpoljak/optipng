# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "command-builder"
require "pipe-run"
require "unix/whereis"

##
# The +optipng+ tool command frontend.
# @see http://optipng.sourceforge.net/
#

module Optipng

    ##
    # Holds +optipng+ command.
    #
    
    COMMAND = :optipng
    
    ##
    # Result structure.
    #
    
    Result = Struct::new(:succeed, :errors)
    
    ##
    # Holds output matchers.
    #
    
    MATCHERS = [
        /^Processing\:\s*(.*)/,
        /^Error:\s*(.*)/,
        /(\d+\.\d+)%/,
        /already optimized\.$/,
    ]

    ##
    # Checks if +jpegoptim+ is available.
    # @return [Boolean] +true+ if it is, +false+ in otherwise
    #
    
    def self.available?
        return Whereis.available? self::COMMAND 
    end
    
    ##
    # Performs optimizations above file or set of files.
    #
    # @param [String, Array] paths file path or array of paths for optimizing
    # @param [Hash] options options 
    # @option options [Integer] :level optimization level (0-7)
    # @option options [Boolean] :debug turn on debugging mode, so command will be put out to the +STDERR+
    # @return [Struct] see {Result}
    #
    
    def self.optimize(paths, options = { })
    
        # Command
        cmd = CommandBuilder::new(self::COMMAND)
        
        # Max
        if options[:level].kind_of? Integer
            cmd.arg(:o, options[:level].to_i)
        end
        
        # Files
        if paths.kind_of? String
            paths = [paths]
        end
        
        # Runs the command
        cmd << paths
        
        if options[:debug] == true
            STDERR.write cmd.to_s + "\n"
        end
        
        output = Pipe.run(cmd.to_s)
        
        # Parses output
        succeed, errors = __parse_output(output)
        return self::Result::new(succeed, errors)
        
    end
    
    
    private
    
    ##
    # Parses output.
    #
    
    def self.__parse_output(output)
        errors = [ ]
        succeed = { }

        output.split("**").each do |section|
            section.strip!
            if section.start_with? "Processing:"
            
                # Scans each line
                filename = nil
                
                section.each_line do |line|
                    if m = line.match(self::MATCHERS[0])
                        filename = m[1]
                    elsif m = line.match(self::MATCHERS[1])
                        errors << [filename, m[1]]
                        next
                    elsif m = line.match(self::MATCHERS[2])
                        succeed[filename] = -1 * m[1].to_f
                        next
                    elsif m = line.match(self::MATCHERS[3])
                        succeed[filename] = 0.0
                    end
                end
                
            end
        end
        
        return [succeed, errors]
    end
end
