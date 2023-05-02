## leval_parser.rb v 1.0.2 Linear ruby1.0
## This parser is designed to run LinearRuby programs from script files (.lrb files).
## LinearRuby has unimplied rules that can allow programs to run on regular ruby and linear ruby,
## the rules can be broken but for the most part breaking them doesnt make sense because in 
## LinearRuby we assume classes are useless and write ruby programs in a linear series of 
## script blocks that will execute in the order we write them.
##
## These script files have a few unimplied rules you are expected to follow to create a proper 
## linear ruby file:
## 
## 1. No classes or glabals are defined, instance variables and constants replace them.
## 2. The file is composed of blocks of script seperated by '\n\n', so you cannot use it in your code in strings literally, instead use "\n"*2 .
## 3. 'jumpto' followed by an integer or instance variable jumps program flow to that block in the file, if a second instance variable or expression is included it will be the condition for the jump.
## 4. when you define methods they are always on main context
## 5. context is main for every block, the program ends when the counter reaches and runs the last block, or an 'exit' operator is found
##
##

# make sure the parser can access main if running outside rubinsystem program.
if defined?(MAIN) != "constant";  MAIN = self;  end

class LinearRubyParser
  def initialize
    @main = MAIN          ## link to outside MAIN context
    @state = "init"       ## operation state of the parser class
	@level = 0            ## recursion level for :leval also the same as program eval stack level
    @file = nil           ## path of current running script
  end
  
  def main;  return @main;  end
  def state;  return @state;  end
  def level;  return @level;  end
  def file;  return @file;  end
  
  
  #load and eval a LinearRuby file
  def load_file *args  ## path, overridecontextwith, passargs
    if File.file?(args[0].to_s) == false;  raise "No such file.";  end
	if File.readable?(args[0].to_s) == false;  raise "File read permission denied by host.";  end
    script_path = args[0].to_s	
	if args[1].to_s != "";  context = args[1];  else;  context = @main;  end
	begin;  script = File.read(script_path);  @file = script_path
	rescue;  raise "Failed to read script file."
	end
    begin; @state = "eval";  @file = ""
	  return self.leval(script,context,args[2])
	rescue => e; @state = "excep"
	  raise "Unknown exception state: "+e.to_s+"\n"+e.backtrace.join("\n")
	end
  end
  
  # eval LinearRuby script string
  def leval *args # script, overridecontextwith, passargs
	script = args[0].to_s
    if args.length == 2 and args[1] != "";  context = args[1];  else;  context = MAIN;  end
	if args.length == 3 and args[2].is_a?(Array);  script_args = args[2];  else;  script_args = [];  end
    running = true
    blocks = script.split("\n\n")
    returnval = [];  exceptions = [];  block = -1
    while running do
	  @state = "eval"; @level += 1
      block += 1
	  if blocks[block].to_s == "";  running = false;  break
	  
	  elsif blocks[block].to_s.downcase[0..11] == "dobeforenext"
	  elsif blocks[block].to_s.downcase[0..9] == "skipnextif"
	  elsif blocks[block].to_s.downcase[0..7] == "gobackif"
	  elsif blocks[block].to_s.downcase[0..5] == "jumpto"
	    
		if blocks[block].to_s[6..1].delete("\n 0123456789").empty?
		  block = ((blocks[block].to_s[6..-1].to_i)-1)
		elsif blocks[block].to_s[6..-1].to_s[0] == "@"
		  begin; var = context.instance_eval(blocks[block].to_s[6..-1])
		    if var.is_a?(Integer) == false;  raise "Error in file: "+@file.to_s+", block: "+block.to_s+", Invalid jump code, obj is not Integer.; block code: "+blocks[block].to_s;  end
			block = var-1
			next
		  rescue;  raise "Invalid jump code in file:"+@file.to_s+", line: "+block.to_s+"; block: "+"\""+blocks[block].to_s+"\""		 		  
		  end
	    end

		next
		
	  else
	    begin;  returnval << context.instance_eval(blocks[block])
	    rescue => e;  exceptions << e.to_s+"\n"+e.backtrace.join("\n")
	    end
	  end
    end;  running = false;  @state = "idle";  @level -= 1
    if exceptions == [];  return returnval
    else;  return [returnval,exceptions]
    end
  end



  def parse_file(script)
    if File.file?(script) == false;  raise "No such file.";  end
	script = File.read(script)
	self.parse(script)
  end


# i want to change the names of all variables to be purley alphanumeric in lruby
# these variable names just cause parsing complexity i dont want when i build the real parser

#[:$-a, :$-p, :$-l, :$@, :$;, :$-F, :$?, :$$, :$&, :$`, :$', :$+, :$=, :$VERBOSE,
# :$-v, :$stdin, :$stdout, :$>, :$stderr, :$-W, :$DEBUG, :$-w, :$0, :$PROGRAM_NAME,
# :$-d, :$_, :$~, :$!, :$/, :$,, :$\, :$-0, :$., :$<, :$FILENAME, :$-i, :$*, :$-I, :$:, 
# :$", :$LOAD_PATH, :$LOADED_FEATURES]

## parser needs to be loaded with a default list of ruby
## classes and globals and their methods so when parsing code they can be recognised
## apart from defined object calls


  # parse processes a script with out evaluating it
  def parse(script)
    blocks = script.split("\n\n")
    stack_keywords = ["def", "if", "case", "class","loop", "while", "for", "begin","{"]
    stack_open = [0, 0, 0, 0, 0, 0, 0,0]
    last_opened = []
    stack_trace = [] ## keeps track of keywords opened and the ends after them
    line_no = 0
    defined_classes = []
    defined_methods = []
    global_vars = []
    instance_vars = []
    local_vars = []
    statements = []  ## contains an array for each keyword block containing any statements from the block
    unexpected_end = []
    script_ok = true

    blocks.each do |block|
      if block.to_s.downcase[0..5] == "jumpto"
        # Handle jump statements
      elsif block.to_s == "exit"
        # Handle exit statement
	    break # done parsing after exit
      else
        lines = block.split(";").join("\n").split("\n")
        lines.each do |line| ; line_no += 1
	 	  line = line.gsub(/\s+/, " ")
          if line[0] == " ";  line = line[1..-1];  end
		
          if line[0] == "#"
		    ##comment line
          elsif line[0..3] == "def "
		
            stack_open[0] += 1
            last_opened << "def";  stack_trace << "def "+line.split(" ")[1..-1].join(" ")
            defined_methods << line.split(" ")[1]
          elsif line[0..2] == "if "
            stack_open[1] += 1
            last_opened << "if";  stack_trace << "if "+line.split(" ")[1..-1].join(" ")
          elsif line[0..4] == "case "
            stack_open[2] += 1
            last_opened << "case";  stack_trace << "case "+line.split(" ")[1..-1].join(" ")
          elsif line[0..5] == "class "
            stack_open[3] += 1
            last_opened << "class";  stack_trace << "class "+line.split(" ")[1..-1].join(" ")
            defined_classes << line.split(" ")[1]	  
          
		  elsif line[0..4] == "loop"
            stack_open[4] += 1
            last_opened << "loop"; stack_trace << "loop "+line.split(" ")[1..-1].join(" ")
            last_opened << "{"; stack_trace << "loop "+line.split(" ")[1..-1].join(" ")
          
		  elsif line =~ /^loop.*\{.*\}\s*$/
            stack_open[4] += 1
            last_opened << "loop"
            stack_trace << "loop "+line.split(" ")[1..-1].join(" ")

		  elsif line[0..4] == "while"
            stack_open[5] += 1
            last_opened << "while"; stack_trace << "while "+line.split(" ")[1..-1].join(" ")
          
		  elsif line[0..2] == "for"
            stack_open[6] += 1
            last_opened << "for"; stack_trace << "for "+line.split(" ")[1..-1].join(" ")
			
  		  elsif line[0..4] == "begin"
		    stack_open[7] += 1
		    last_opened << "begin"; stack_trace << "begin"
          elsif line[0..5] == "rescue"
		  
          elsif line[0..5] == "else"
          
		  elsif line[0..5] == "next"
          
		  elsif line[0..5] == "break"

          elsif line =~ /^@\w+\b\s*==/
            # instance variable with == operator
          elsif line =~ /^@\w+\b\s*\./
            # instance variable with dot operator
          elsif line =~ /^@\w+\b\s*>=/
            # instance variable with >= operator
          elsif line =~ /^@\w+\b\s*<=/
            # instance variable with <= operator
          elsif line =~ /^@\w+\b\s*\+=/
            # instance variable with += operator
          elsif line =~ /^@\w+\b\s*\-=/ 
            # instance variable with -= operator
          elsif line =~ /^@\w+\b\s*=/  # instance variable declaration
            var_name = line.split("=")[0][1..-1] # remove the @ from the var name
            instance_vars << "@"+var_name unless instance_vars.include?("@"+var_name)
			
          elsif line =~ /^\$\w+\b\s*==/
            # global variable with == operator
          elsif line =~ /^\$\w+\b\s*\./
            # global variable with dot operator
          elsif line =~ /^\$\w+\b\s*>=/
            # global variable with >= operator
          elsif line =~ /^\$\w+\b\s*<=/
            # global variable with <= operator
          elsif line =~ /^\$\w+\b\s*\+=/
            # global variable with += operator
          elsif line =~ /^\$\w+\b\s*\-=/ 
            # global variable with -= operator			
          elsif line =~ /^\$\w+\b\s*=/  # global variable declaration
            var_name = line.split("=")[0][1..-1] # remove the $ from the var name
            global_vars << "$"+var_name unless global_vars.include?("$"+var_name)
			
			
		 elsif line =~ /^\w+\b\s*==/
            # instance variable with == operator
          elsif line =~ /^\w+\b\s*\./
            # instance variable with dot operator
          elsif line =~ /^\w+\b\s*>=/
            # instance variable with >= operator
          elsif line =~ /^\w+\b\s*<=/
            # instance variable with <= operator
          elsif line =~ /^\w+\b\s*\+=/
            # instance variable with += operator
          elsif line =~ /^\w+\b\s*\-=/ 
            # instance variable with -= operator
          elsif line =~ /^\w+\b\s*=/ # local variable declaration
            var_name = line.split("=")[0].strip         
		    local_vars << var_name unless local_vars.include?(var_name)




          elsif line.downcase.strip == "end"
            # Close the most recent open block
            stack_trace << "end"
		    if last_opened.any?
              stack_open[stack_keywords.index(last_opened.last)] -= 1
              last_opened.pop
            else; unexpected_end << last_opened[-1].to_s+" @ line "+line_no.to_s
		    end
		  
          else
            # Handle other statements  
		  
          end
        end
	  
        # Add a separator to the local variables array between blocks
        local_vars << "" unless local_vars.empty?
        instance_vars << "" unless instance_vars.empty?
        global_vars << "" unless global_vars.empty?
        defined_classes << "" unless defined_classes.empty?
        defined_methods << "" unless defined_methods.empty?
	  
      end
    end

   puts "#####################################################################"
   puts script.to_s
   puts "#####################################################################"

    # Check for stack errors
    s=stack_open; s.delete(0)
    if s.include?(1)
	  stack_keywords.each do |k|
	    if stack_open[stack_keywords.index(k)] == 1
		  puts "ERROR: Stack left open for keyword: "+k.to_s
		  script_ok  = false
	    end
	  end
    end 
    if unexpected_end != []
      puts "ERROR: Unexpected 'end' in stack keywords: "+unexpected_end.to_s
	  script_ok = false
    end
    defined_classesl = defined_classes; defined_classesl.delete(""); defined_classesl = defined_classesl.length
    defined_methodsl = defined_methods; defined_methodsl.delete(""); defined_methodsl = defined_methodsl.length
    global_varsl = global_vars;  global_varsl.delete("");  global_varsl = global_varsl.length 
    instance_varsl = instance_vars;  instance_varsl.delete("");  instance_varsl = instance_varsl.length
    local_varsl = local_vars;  local_varsl.delete("");  local_varsl = local_varsl.length
    puts "\nParse Results for file: "
    puts "Blocks: "+blocks.length.to_s + " Logical Lines: "+line_no.to_s+"\n"
    puts "Size: "+script.to_s.length.to_s+" bytes\n"
    puts ""
    if defined_classesl > 0
      puts "Defined classes: "+defined_classesl.to_s+": "+defined_classes.join(", ")+"\n"
      puts ""
    end
    if global_varsl > 0
      puts "Global variables: "+global_varsl.to_s+": "+global_vars.join(", ")+"\n"
      puts ""
    end
    puts "Defined methods: "+defined_methodsl.to_s+": "+defined_methods.join(", ")+"\n"
    puts ""
    puts "Instance variables: "+instance_varsl.to_s+": "+instance_vars.join(", ")+"\n"
    puts ""
    puts "Local variables: "+local_varsl.to_s+": "+local_vars.join(", ")+"\n"
    puts ""
    puts "Stack trace: "+stack_trace.length.to_s+" :"+stack_trace.to_s+"\n"
    puts ""
    puts "Script pass: "+script_ok.to_s
  end

 
end

Parser = LinearRubyParser.new
