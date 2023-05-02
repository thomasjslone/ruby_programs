self.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4### self.rb

# ALPHABETIC CHARACTERS
ALPHA= ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
# ALPHANUMERIC CHARACTERS
ALPHANUM = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9"]
## ASCII CHARACTERS
CHARS = [] ; c = 0 ; 256.times{ CHARS << c.chr.to_s ; c += 1 }
## SYMBOL CHARACTERS

## every 8 bit binary number in cardinal order
BINARY = [] ; c = 0 ; 256.times {  b = c.to_s(2) ; until b.to_s.length == 8 ; b = "0" + b.to_s ; end ; BINARY << b ; c += 1 }

## every hexicdeimal number in order
HEX = [] ; c = 0 ; 256.times { h = c.to_s(16) ; if h.length == 1 ; h = "0" + h.to_s ; end ; HEX << h ; c += 1 }
## a list of all 8 bit byte codes for the ascii characters
#BYTES = [] ; HEX.each do |h| ; BYTES << "x" + h ; end

##system/region termonology
DAYS = ["sunday","monday","tuesday","wednesday","thursday","friday","saturday"]
MONTHS = ["january","february","march","april","may","june","july","august","september","october","november","december"]
SEASONS = ["spring","summer","autum","winter"]
# RUBY KEYWORDS
KEYWORDS = ["alias", "and", "begin", "break", "case", "class", "def", "defined?", "do", "else", "elsif", "end", "ensure",
            "false", "for", "if", "in", "module", "next", "nil", "not", "or", "redo", "rescue", "retry" "return", "self",
			"super", "then", "true", "undef", "unless" "until", "when", "while", "yield", "loop"]
# RUBY OPERATORS
OPERATORS = ["+", "-", "*" ,"/", "%", "**", "==", "!=", ">", ">=", "<", "<=", "<=>", "===", ".eql?", "equal?", "!~",
             "=~", "&", "|", "^", "~", "&&", "||"]
# RUBY DATA TYPES
DATATYPES = ["Numeric", "Integer", "Float", "BigDecimal", "Rational", "Complex", "String", "Symbol", "Array", "Hash",
             "Range", "Regexp", "Time", "Date", "DateTime", "TrueClass", "FalseClass", "NilClass"]

# GLOBAL LINKS TO DATA
$ALPHA = ALPHA
$ALPHANUM = ALPHANUM
$CHARS = CHARS
$BINARY = BINARY
$HEX = HEX
$DAYS = DAYS
$MONTHS = MONTHS
$SEASONS = SEASONS
$KEYWORDS = KEYWORDS
$OPERATORS = OPERATORS
$DATATYPES = DATATYPES


def benchmarked_load(script)
  unless File.file?(script);  raise "No such file.";  end
  begin
    t1 = Time.now
    load(script)
    t2=Time.now
    return t2-t1
  rescue => e;  return "Exception: "+e.to_s+"\n"+e.backtrace.join("\n")+"\n"
  end
end


def benchmarked_eval(script)
  unless script.is_a?(String) and script.to_s.length > 0;  raise "Invalid argument, should be String.";  end
  begin
    t1 = Time.now
    eval(script.to_s)
    t2 = Time.now
    return t2-t1
  rescue => e;  return "Exception: "+e.to_s+"\n"+e.backtrace.join("\n")+"\n"
  end
end


#####################################################################################################################################################################################
## this stuff is for objects that need their parent class to have a method or alias name, class or other objects
## basically the stuff you define here is in the context of every class object
Object.class_eval{
  def local_methods ; ms = self.methods ; mets = [] ; ms.each { |m| mets << m.to_s } ; rm = self.class.methods ; self.class.class.methods.each { |m| rm << m.to_s } ; nm = [] ; mets.each { |m| unless rm.include?(m.to_s) ; nm << m.to_s ; end } ; return nm ; end
  alias :m :methods ; alias :lm :local_methods
  alias :lv :local_variables ; alias :gv :global_variables ; alias :iv :instance_variables
  alias :ivs :instance_variable_set ;   alias :ivg :instance_variable_get   ##dont forget get/set constants and classvariables
  alias :iev :instance_eval ; alias :ev :eval
  def constants ; self.class.constants ; end ; alias :cn :constants
  
  def gets_eval *args ##multiline console input terminated with {end}
    lines=[]
    if args.length==1;cont=args[0];  else;  cont=self;  end
    loop do
      line=gets.chomp
	  if line.to_s=="{end}";  break
	  else;  lines << line.to_s
	  end
    end
    code=lines.join("\n")+"\n"
    begin;  res = cont.instance_eval(code)
    rescue => e;  res=e.to_s+"\n"+e.backtrace.join("\n")
    end
    return res
  end
    
  
  ## logic operators by name
  def _and(a,b) ; if a == 1 and b == 1 ; return 1 ; else ; return 0 ; end ; end
  def _or(a,b) ; if a == 0 and b == 0 ; return 0 ; elsif a == 1 and b == 1 ; return 1 ; else ; return 1 ; end ; end
  def _not(a,b) ; if a == 0 and b == 0 ; return 1 ; else ; return 0 ; end ; end
  def _nor(a,b) ; if a == 0 and b == 0 ; return 1 ; else ; return 0 ; end ; end
  def _nand(a,b) ; if a == 1 and b == 1 ; return 0 ; else ; return 1 ; end ; end
  def _xor(a,b) ; if a == 0 and b == 0 ; return 0 ; elsif a == 1 and b == 1 ; return 0 ; else ; return 1 ; end ; end


  ## random alphanumeric string of determined length 
  def rands(length, nonumbers=false)
    if length.to_i < 1;  raise "Invalid argument.";  end
    str = []
    if nonumbers == false;  length.times { str<<($ALPHANUM.shuffle)[0] }
    else;  length.times { str<<($ALPHA.shuffle)[0] } 
    end
    return str.join('')
  end


  def host?  ## these are laid out for more complicated checks later
    host = ''
    if File.directory?("C:/") and ENV["OS"] == "Windows_NT"
      host = "Windows"
    elsif File.directory?("/home")
      host = "Linux"
    else
      host = false
    end
    return host
  end


  def internet?  ## try to URI google
    begin;
      uri = URI.open("http://www.google.com")
      cont = uri.read
      if cont.length == 0;  raise "No content included in response.";  end
	  return true
    rescue => e;  return e
    end
  end
  
  
}#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##array.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4###array.rb
Array.class_eval{


}#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##dir.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4##dir.rb



Dir.instance_eval{

  def exist? inp ## exist in dir should link to File.exist? since it checks both files and  dirs
    File.exist?(inp)
  end


  def dir *args ## gets/sets workdir
    if args.length==0;return Dir.getwd.to_s
    elsif args[0].is_a?(String)
      if File.directory?(args[0]) ; Dir.chdir(args[0]) ; return Dir.getwd.to_s
      elsif File.directory?(Dir.getwd.to_s + "/" + args[0].to_s) ; Dir.chdir(Dir.getwd.to_s + "/" + args[0].to_s) ; return Dir.getwd.to_s
	  else ; raise "No such directory."
      end
    end
  end
  
  def view *args ## prints directory contents to screen
    if args[0] == nil
	  dir = Dir.getwd.to_s
    elsif File.directory?(args[0].to_s)
      dir = args[0].to_s  
    elsif File.directory?(Dir.getwd + args[0])
      dir = Dir.getwd + args[0]
    else
      dir = false
    end
    if dir == false ; raise "No such directory: " + args[0].to_s
    else 
	    cont = Dir.entries(dir.to_s) ; cont.delete(".") ; cont.delete("..") ; bt = 0
		if cont.length == 0 ; return  "Directory is empty" 
	    else
		  str = [] ; fi = [] ; fo = []
		  cont.each do |p|
		    if File.file?(dir.to_s + "/" + p.to_s)
		              begin ; s = File.size?(dir.to_s + "/" + p.to_s).to_s ; rescue ; s = "" ; end
			  fi << "File: " + p.to_s + "    Size: " + s.to_s
		    elsif File.directory?(dir.to_s + "/" + p.to_s)
			  fo << "Dir:  " + p.to_s + ""
			end
		  end
		  str << "Directory:   \"" + dir.to_s + "\"   Files: " + fi.length.to_s + ", Folders: " + fo.length.to_s
		  str << "#############################################"
		  fo.each { |f| str << f.to_s } ; fi.each { |f| str << f.to_s }
		  str << "#############################################\n"
		  puts str.join("\n").to_s
		end
    end
  end
  
  
  def map(dir)
    dir = File.join(Dir.getwd, dir) unless File.directory?(dir) 
    cur = nil;  rem = [dir]
    fi = [];  fo = [];  ex = []
    until rem.empty?
      cur = rem.shift 
      begin
        Dir.foreach(cur) { |p|
          next if p == '.' || p == '..'
          path = File.join(cur, p)
          if File.stat(path).file?;  fi.push(path)
          elsif File.stat(path).directory?;  fo.push(path);  rem.push(path)
          end
		}
      rescue;  ex.push(cur)
      end
    end
    if ex.empty?;  return [fi, fo]
    else;  return [fi, fo, ex]
    end
    rescue Errno::ENOTDIR;  "Argument is a file."
    rescue Errno::ENOENT;  raise "No such directory"
  end

  
  def size?(dir)
    raise "No such file or directory." unless File.exist?(dir)
    raise "#{dir} is a file. size? returns the size of directories, not files." if File.file?(dir)
    total_size = 0
    Dir.glob(File.join(dir, '**', '*')).each do |path|
      total_size += File.size(path) if File.file?(path)
    end
    total_size
  end
  
  def empty?(dir)
    raise "No such file or directory." unless File.exist?(dir)
    raise "#{dir} is a file. empty? returns true for empty directories, not files." if File.file?(dir)
    (Dir.entries(dir) - %w[. ..]).empty?
  end
  


  def empty!(dir)
    failed = []
    Dir.glob("#{dir}/*").each do |path|
      begin
        if File.file?(path);  File.delete(path)
        elsif File.directory?(path);  empty!(path);  Dir.delete(path)
        end
      rescue => e;  failed << [path, "#{e.message}"]
      end
    end
    if failed.empty?;  return  true
    else;  return failed
    end
  end


  def delete!(dir)
    if self.empty?(dir);  self.delete(dir);  return true
	else
	  if self.empty!(dir);  Dir.delete(dir);  return true
	  else;return false
	  end
	end
  end

  def copy(dir,newdir) ## copy utility
    if File.directory?(dir)
      if File.directory?(newdir.to_s + "/" + dir.to_s.split("/")[-1].to_s) == false
	    m = Dir.map(dir.to_s)
		if m == [[],[]]
		  Dir.mkdir(newdir.to_s + "/" + dir.to_s.split("/")[-1].to_s)
		else ; Dir.mkdir(newdir.to_s + "/" + dir.to_s.split("/")[-1].to_s)
		  if m[1].length > 0
		    m[1].each do |d|
			  nd = newdir.to_s + "/" + d.to_s.split(dir.to_s)[1].to_s
			  Dir.mkdir(nd.to_s)
			end
		  end
		  if m[0].length > 0
		    m[0].each do |p|
			  fi = File.open(p.to_s,"r") ; cont = fi.read.to_s ; fi.close
			  np = newdir.to_s + "/" + p.to_s.split(dir.to_s)[1].to_s
			  fi = File.open(np.to_s,"w") ; fi.write(cont.to_s) ; fi.close
			end
		  end
		end
	    return true
	  else ; return "Target directory already contains a directory with the same name as the one you're copying."
	  end
	else ; return "No such directory."
	end
  end
  
  def move(dir,newdir) ## move utility
    if File.directory?(dir)
      if File.directory?(newdir)
	    if File.directory?(newdir.to_s + "/" + dir.to_s.split("/")[-1].to_s) == false
		  Dir.mkdir(newdir.to_s + "/" + dir.to_s.split("/")[-1].to_s)
		  img = Dir.img(dir.to_s)
		 if img == [[],[],[]] ; Dir.delete(dir.to_s) ; return true
		  else
		    Dir.copy(dir.to_s,newdir.to_s)
		    if img[0].length > 0
			  img[0].each { |f| File.delete(f.to_s) }
			end
		    if img[1].length > 0
			  img[1].each { |d| Dir.delete(d.to_s) }
			end
			Dir.delete(dir.to_s)
			return true
		  end
		else ; return "Cannot move because target directory already exists."
		end
	  elsif File.file?(newdir) ; return "Target directory is actually an existing file!"
      else ; return "Target directory does not exist."
      end	  
	elsif File.file?(dir) ; return "Dir.move is for directories only, use File.move for files."
    else ; return "No such directory."
	end
  end


  def rename(dir, newname)
    if File.directory?(dir)
      newpath = File.join(File.dirname(dir), newname)
      if File.directory?(newpath)
        return "Cannot rename because target directory already exists."
      end
      Dir.mkdir(newpath)
      Dir.foreach(dir) do |filename|
        next if filename == "." || filename == ".."
        filepath = File.join(dir, filename)
        newfilepath = File.join(newpath, newname + File.extname(filepath))
        File.rename(filepath, newfilepath)
      end
      begin
        Dir.delete(dir)
      rescue SystemCallError
        # If the directory couldn't be deleted, try to clean it up manually
        Dir.foreach(dir) do |filename|
          next if filename == "." || filename == ".."
          filepath = File.join(dir, filename)
          File.delete(filepath)
        end
        Dir.delete(dir)
      end
      return true
    else
      return "No such directory."
    end
  end

  
  def search(dir, name)
    unless File.directory?(dir);  return "No such directory.";  end
    results = Dir.glob(File.join(dir, '**', "*#{name}*"), File::FNM_CASEFOLD)
    if results.empty?;  return false
    else;  return results
    end 
  end


  def locate(dir, name, case_sensitive = false)
    unless File.directory?(dir);  return "No such directory.";  end
    if case_sensitive;  results = Dir.glob(File.join(dir, '**', name)).select { |path| File.basename(path) == name }
    else;  results = Dir.glob(File.join(dir, '**', "*#{name}*"), File::FNM_CASEFOLD).select { |path| File.basename(path).downcase == name.downcase }
    end
    if results.empty?;  return false
    else;  return results
    end
  end


  def clones?(directory)
    unless File.directory?(directory);  raise "No such directory.";  end
    files = Dir.glob("#{directory}/*").select { |f| File.file?(f) }
    if files.empty?;  raise "Target directory is empty.";  end
    duplicates = [];  hash_to_files = {}
    files.each do |file|
      file_contents = File.read(file);  file_hash = Digest::SHA256.hexdigest(file_contents)
      if hash_to_files.key?(file_hash);  duplicates << [file, hash_to_files[file_hash]]
      else;  hash_to_files[file_hash] = file
      end
    end
    if duplicates.empty?;  return false
    else;  return duplicates
    end
  end

   

  alias :make :mkdir
}

##this is the same context as self but self is usually defined first and these depend on this class so they have to be after it
def dir *args ; Dir.dir *args ; end
def viewdir *args ; puts Dir.view *args ; end
alias :vd :viewdir
#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##file.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4##file.rb
File.instance_eval{
  
  def view(path)
    if File.file?(path.to_s) == false;  raise "No such file.";  end
    if File.readable?(path.to_s) == false;  raise "File read permission denied by host.";  end
    begin; cont = File.read(path.to_s)
	rescue; raise "Unable to read file."
	end
    print "\n"+cont.to_s+"\n\n"
	if path.to_s.include?("/");  path.split("/")[-1].to_s;  else; p = path.to_s;  end
	return "File: "+p.to_s+"  Location: "+path.to_s
  end
  
  def make(path)
    if path.to_s.include?("/");  dir = path.to_s.split("/")[0..-2].join("/");  name = path.to_s.split("/")[-1]
	else;  dir = Dir.getwd; name = path.to_s
	end
	if File.directory?(dir) == false;  raise "No such dir: "+dir.to_s;  end
	if File.directory?(dir+"/"+name) == true;  raise "File path is already a dir: "+dir+"/"+name;  end
	if File.file?(dir+"/"+name) == true;  raise "File already exists.";  end
	if File.writable?(dir) == false;  raise "File write permission denied by host.";  end
	begin;  f = File.open(dir+"/"+name,"w");  f.close
	rescue;  raise "Unable to write file."
	end
	return true
  end
  
  def prepend(path,str)
	if File.file?(path.to_s) == false;  raise "No such file.";  end
	if str.to_s.length == 0;  raise "Invalid arguments: args[1] \"str\", should be a string of positive length.";  end
	if File.writable?(path.to_s) == false;  raise "File write permission denied by host.";  end
	begin;  cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end
	begin;  File.write(str.to_s+cont)
	rescue;  raise "Unable to write file."
	end
	return true
  end
    
  def append(path,str)
	if File.file?(path.to_s) == false;  raise "No such file.";  end
	if str.to_s.length == 0;  raise "Invalid arguments: args[1] \"str\", should be a string of positive length.";  end
	if File.writable?(path.to_s) == false;  raise "File write permission denied by host.";  end
	begin;  cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end
	begin;  File.write(cont+str)
	rescue;  raise "Unable to write file."
	end
	return true
  end


  def insert(path,pos,str)
    if File.file?(path.to_s) == false;  raise "No such file.";  end
	if pos.is_a?(Integer) == false;  raise "Invalid arguments: args[1] \"pos\", should be Integer.";  end
	if str.to_s.length == 0;  raise "Invalid arguements: args[2] \"str\", should be String of positive length.";  end
	if File.writable?(path.to_s) == false;  raise "File write permission denied by host.";  end
	begin;  cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end
	cont = cont.split("")
	cont.insert(pos,str.to_s)
	cont = cont.join("")
	begin;  File.write(path.to_s, cont)
	rescue;  raise "Unable to write file."
	end
	return true
  end
  
  def lines(path)     ## WINDOWS LINEBREAKS ONLY
    if File.file?(path.to_s) == false;  raise "No such file.";  end
	if File.readable?(path.to_s) == false; raise "File read permission denied by host.";  end
	begin; cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end
	return cont.split("\n")
  end
  
  def write_line(path,pos,str)
	if File.file?(path.to_s) == false;  raise "No such file.";  end
	if File.writable?(path.to_s) == false; raise "File write permission denied by host.";  end
	if pos.is_a?(Integer) == false and pos.is_a?(Range) == false;  raise "Invalid arguemnts: args[1]: \"pos\", should be Integer or Range";  end 
	if str.to_s.length == 0;  raise "Invalid arguments: args[2]: \"str\", should be String of positive length.";  end
	begin; cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end
	cont = cont.split("\n")
	if pos.is_a?(Integer) == true
	   cont[pos] = str.to_s
	else
      pos.each { |i| cont[i] = str.to_s }
	end
	cont = cont.join("\n")
	begin;  File.write(path.to_s, cont)
	rescue;  raise "Unable to write file."
	end
	return true
  end 
  
  
 def insert_line(path,pos,str)
	if File.file?(path.to_s) == false;  raise "No such file.";  end
	if File.writable?(path.to_s) == false; raise "File write permission denied by host.";  end
	if pos.is_a?(Integer) == false;  raise "Invalid arguemnts: args[1]: \"pos\", should be Integer.";  end 
	if str.to_s.length == 0;  raise "Invalid arguments: args[2]: \"str\", should be String of positive length.";  end
    begin;  cont = File.read(path.to_s)
    rescue;  raise "Unable to read filw."
	end
    cont = cont.split("\n")
	cont.insert(pos,str.to_s)
	cont = cont.join("\n")
	begin;  File.write(path.to_s,cont)
	rescue; raise "Unable to write file."
	end
	return true
  end	
	

  def delete_line(path,pos)
	if File.file?(path.to_s) == false;  raise "No such file.";  end
	if File.writable?(path.to_s) == false; raise "File write permission denied by host.";  end
	if pos.is_a?(Integer) == false and pos.is_a?(Range) == false;  raise "Invalid arguemnts: args[1]: \"pos\", should be Integer or Range";  end 
	begin; cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end	
	cont = cont.split("\n")
	if pos.is_a?(Integer) == true
	   cont[pos] = ""
	else
      pos.each { |i| cont[i] = "" }
	end
	cont = cont.join("\n")
	begin;  File.write(path.to_s, cont)
	rescue;  raise "Unable to write file."
	end
	return true
  end 


 def include? *args  ## path, str, matchcase
	if File.file?(args[0].to_s) == false;  raise "No such file.";  end
	if File.readable?(args[0].to_s) == false; raise "File read permission denied by host.";  end
	if args[1].to_s.length == 0;  raise "Invalid arguments: args[2]: \"str\", should be String of positive length.";  end
    begin;  cont = File.read(path.to_s)
	rescue;  raise "Unable to read file."
	end	
	if args[2] != true;  cont = cont.downcase; tag = args[1].to_s.downcase
	else;  tag = args[2].to_s
	end
    return cont.include?(tag)
  end


  def empty?(path)
	if File.file?(args[0].to_s) == false;  raise "No such file.";  end
	if File.readable?(args[0].to_s) == false; raise "File read permission denied by host.";  end
    empty = nil
	begin;  if File.size?(path.to_s) > 0;  empty = false;  else;  empty = true;  end
    rescue;  raise "Unable to read file."
    end
    return empty
  end

  def empty!(path)
	if File.file?(args[0].to_s) == false;  raise "No such file.";  end
	if File.writable?(args[0].to_s) == false; raise "File write permission denied by host.";  end
    begin;  File.write(path.to_s,"")
	rescue;  raise "Failed to write file."
	end
	return true
  end
  

  def copy *args #path, newpath
    if File.file?(args[0].to_s)
	  if File.directory?(args[1].to_s)
	    if File.file?(args[1].to_s + "/" + args[0].to_s.split("/")[-1].to_s) == false
	      fi = File.open(args[0].to_s,"rb") ; cont = fi.read.to_s ; fi.close
		  fi = File.open(args[1].to_s + "/" + args[0].to_s.split("/")[-1].to_s,"wb") ; fi.write(cont.to_s) ; fi.close
          return true		  
		else ; return "Target directory already contains a file with the same name."
		end
	  else ; return "Input target directory is invalid."
	  end
	else ; return "No such file."
	end  
  end
  

  def move *args #path, newpath
    if File.file?(args[0].to_s)             
	  if File.directory?(args[1].to_s)
	    if File.file?(args[1].to_s + "/" + args[0].to_s.split("/")[-1].to_s) == false
	      fi = File.open(args[0].to_s,"rb") ; cont = fi.read.to_s ; fi.close
		  fi = File.open(args[1].to_s + "/" + args[0].to_s.split("/")[-1].to_s,"wb") ; fi.write(cont.to_s) ; fi.close
		  File.delete(args[0].to_s)
          return true		  
		else ; return "Target directory already contains a file with the same name."
		end
	  else ; return "Input target directory is invalid."
	  end
	else ; return "No such file."
	end  
  end 
  
  
  def generate_certificate(filepath)
    file_size = File.size(filepath)                             # Get the size of the file
    total = file_size                                 # Iterate over every byte of the file and add its value to the size
    File.open(filepath, "rb") do |file|
      while byte = file.read(1)
        total += byte.unpack('C').first
      end
    end
    certificate = total.to_f / file_size           # Divide the total by the size of the file to create the certificate
    return certificate.to_s
  end
  
  
  alias :dir? :directory?
}#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##integer.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4##integer.rb
Integer.class_eval{


  def exponate
    number = self;  base = 2;  exponent = 2
    while base <= number
      exponent = 2
      while exponent < number
        if base**exponent == number;  return [base, exponent];  end
        exponent += 1
      end
      base += 1
    end
  end


  def factors
    n = self;  factor1 = 1;  factor2 = n
    (2..Math.sqrt(n)).each do |factor|
      if n % factor == 0
        factor1 = factor
        factor2 = n / factor
        break
      end
    end
    [factor1, factor2]
  end

  
  ## if a number upto the sqrt isnt devisable, no number is 
  def prime?
    return false if self <= 1
    (2..Math.sqrt(self)).each do |i|
      return false if self % i == 0
    end
    return true
  end

  
  def surname *args
    if args.length == 0;  int=self.to_s	;  else;  int=args[0].to_s;  end
	if int.to_s=="0";int="0"
	elsif int[-2..-1]=="11" or int[-2..-1] =="12" or int[-2..-1] =="13";int<<"th"
    elsif int[-1]=="1";int<<"st"
    elsif int[-1]=="2";int<<"nd"
    elsif int[-1]=="3";int<<"rd"
	else;int<<"th"
	end
    return int
  end
  
  def commas;  self.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse;  end
  

}

Integer.instance_eval{

}


#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##string.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4##string.rb
String.class_eval{

  def shuffle ; return self.split('').shuffle.join('').to_s ; end
  alias :scramble :shuffle
  def base10? ; self.delete("0123456789").empty? ; end
  alias :only_numbers? :base10?
  def base16? ; self.upcase.delete("0123456789ABCDEF").empty? ; end
  alias :only_hex? :base16?
  def base36? ; self.upcase.delete("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").empty? ; end
  def only_letters? ; self.upcase.delete("ABCDEFGHIJKLMNOPQRSTUVWXYZ").empty? ; end  
  def to_binary ##returns a list of the binary byte form of the string from utf8 only(cause ruby)
    b = [] ; s = self.to_s.split('')
	s.each do |ch|
	  b << BINARY[CHARS.index(ch.to_s)]	
	end
	return b.join.to_s
  end
  def from_binary ## works on strings used with .to_b restoring them to ascii characters
    bytes = [] ; s = self.to_s
	until s.to_s.length == 0
	  b = s[0..7].to_s ; s = s[8..-1]
	  bytes << b.to_s
	end
	str = ''
	bytes.each do |b|
      str << CHARS[BINARY.index(b.to_s).to_i].to_s
	end
	return str.to_s
  end 

  alias :ew? :end_with?
  alias :sw? :start_with?
  
  ##in building it this way, i can take this and make an actual code parser 
  def splice(b,e)  
    if b.is_a?(String) == false or e.is_a?(String) == false;  raise "Arguements require String type."
	elsif b.to_s=="" or e.to_s == "";  raise "Arguements cannot be nilstring."
	end
	s=self  ## self inside the loop will not be the string
    if s.length<=(b.to_s.length+e.to_s.length);  raise "Base string is too small.";  end
    pos=0;  stack = false;  list=[]
    if b.length > e.length ;  buffer_length = b.length;  else;  buffer_length = e.length;  end
    buffer = []; buffer_length.times{ buffer << "" }
    empty_buffer=[]; buffer_length.times{ empty_buffer << "" }  ## again, in the loop we can only refer to vars
    empty_buffer2=[]; buffer_length.times{ empty_buffer2 << "" } ## im really not sure why but id love to know
    tag1=empty_buffer; b.split('').each { |ch| empty_buffer << ch ;  empty_buffer.delete_at(0) }
    tag2=empty_buffer2; e.split('').each { |ch| empty_buffer2 << ch ;  empty_buffer2.delete_at(0) }
    loop do ## in this loop s will be self and tag1 & 2 will point to the buffers we want to work with
      if s[pos].to_s=="";  break;  end	
      buffer << s[pos];  buffer.delete_at(0)
	  if stack;  list << s[pos];  end
	  str=buffer.join('');  tag = tag1.join('')
      m=true;  i=0
      tag.reverse.split('').each{ |ch| if ch.to_s!=str.reverse[i].to_s and ch.to_s != ""; m=false; break; end; i+=1 }	
      if m == true;  stack = true;  end
	  tag = tag2.join('')
      m=true;  i=0
      tag.reverse.split('').each{ |ch| if ch.to_s!=str.reverse[i].to_s and ch.to_s != ""; m=false; break; end; i+=1 }	
	  if m == true;  stack = false;  end
	  pos+=1
    end
    if list.length == 0;  return nil  ##not nilstring so we can tell the difference on return side
    else;  return list.join('')[0..("-"+(e.length+1).to_s).to_i]
    end 
  end

# def splice(b, e)
  # if !b.is_a?(String) || !e.is_a?(String)
    # raise "Arguments require String type."
  # elsif b.empty? || e.empty?
    # raise "Arguments cannot be empty."
  # end
  
  # s_copy = self.dup
  # if s_copy.length <= (b.length + e.length)
    # raise "Base string is too small."
  # end
  
  # pos = 0
  # stack = false
  # list = []
  
  # if b.length > e.length
    # buffer_length = b.length
  # else
    # buffer_length = e.length
  # end
  
  # buffer = Array.new(buffer_length, "")
  # empty_buffer = Array.new(buffer_length, "")
  # empty_buffer2 = Array.new(buffer_length, "")
  
  # tag1 = empty_buffer
  # b.split('').each do |ch|
    # empty_buffer << ch
    # empty_buffer.delete_at(0)
  # end
  
  # tag2 = empty_buffer2
  # e.split('').each do |ch|
    # empty_buffer2 << ch
    # empty_buffer2.delete_at(0)
  # end
  
  # loop do
    # if s_copy[pos].nil?
      # break
    # end
    
    # buffer << s_copy[pos]
    # buffer.delete_at(0)
    
    # if stack
      # list << s_copy[pos]
    # end
    
    # str = buffer.join('')
    # tag = tag1.join('').reverse
    
    # m = true
    # i = 0
    
    # tag.split('').each do |ch|
      # if ch != str.reverse[i] && ch != ""
        # m = false
        # break
      # end
      
      # i += 1
    # end
    
    # if m
      # stack = true
    # end
    
    # tag = tag2.join('').reverse
    
    # m = true
    # i = 0
    
    # tag.split('').each do |ch|
      # if ch != str.reverse[i] && ch != ""
        # m = false
        # break
      # end
      
      # i += 1
    # end
    
    # if m
      # stack = false
    # end
    
    # pos += 1
  # end
  
  # if list.empty?
    # return nil
  # else
    # return list.join('')[0..("-#{e.length + 1}").to_i]
  # end 
# end
#$str = "hello there<a> asshole</a> fuck you."
  
  def numerize
    str=self;  numbers=[]
	str.split('').each{ |ch| 
	  n = CHARS.index(ch).to_s
      loop do
	    if n.to_s.length < 3;  n="0"+n
		else;  break
		end
	  end
      numbers << n
	}
    return numbers.join('')  
  end
  
  def denumerize
    chars=[]
	str=self.split('')
    loop do
	  if str.length == 0;  break;  end
	  chars<<CHARS[str[0..2].join('').to_i]
	  3.times{ str.delete_at(0) }
	end
    return chars.join('')
  end
 
  alias :sp :split


  def parse_array *args
    if args.length > 0 ;  str = args[0]
    else;  str = self
    end
	if str.to_s == "[]";  return [];  end
	
	str = str.strip.gsub(/^\[|\]$/, '')
    elements = [];  current_element = '';  nested_level = 0
  
    str.each_char do |c|
      if c == ',' && nested_level == 0
        elements << current_element.strip
        current_element = ''
      else
        current_element += c
        if c == '[';  nested_level += 1
        elsif c == ']';  nested_level -= 1
        end
      end
    end
  
    elements << current_element.strip
  
    elements.map do |element|
      if element.start_with?('"') && element.end_with?('"')
        element.gsub(/^"|"$/, '')
      elsif element.start_with?("'") && element.end_with?("'")
        element.gsub(/^'|'$/, '')
      elsif element =~ /\A\d+\z/
        element.to_i
      elsif element =~ /\A\d+\.\d+\z/
        element.to_f
      elsif element == 'true' || element == 'false'
        element == 'true'
      elsif element.start_with?('[') && element.end_with?(']')
        self.parse_array(element)
      elsif element.start_with?('{') && element.end_with?('}')
        self.parse_hash(element)
      else
        element
      end
    end
  end


  def parse_hash *args
    if args.length == 0;  str = self
    else;  str = args[0]
    end
    if str.to_s == "{}";  return {};  end
	
    str = str.strip.gsub(/^\{|\}$/, '')
    pairs = [];  current_key = '';   current_value = '';  nested_level = 0

    str.each_char do |c|
      if c == '>' && nested_level == 0
        current_key = current_value.gsub(/['":]\s*(\w+)\s*['":]?/, '\1');  current_key = current_key.delete(" =")
        current_value = ''
      elsif c == ',' && nested_level == 0
        pairs << [current_key, current_value.strip]
        current_key = ''
        current_value = ''
      else
        current_value += c
        if c == '{' || c == '['
          nested_level += 1
        elsif c == '}' || c == ']'
          nested_level -= 1
        end
      end
    end

    pairs << [current_key, current_value.strip]

    hash = {}
    pairs.each do |pair|
      key = pair[0]
      value = pair[1]

      if value.start_with?('{') && value.end_with?('}')
        hash[key] = value.parse_hash
      elsif value.start_with?('[') && value.end_with?(']')
        hash[key] = value.parse_array
      elsif value == 'true'
        hash[key] = true
      elsif value == 'false'
        hash[key] = false
      elsif value =~ /\A\d+\z/
        hash[key] = value.to_i
      elsif value =~ /\A\d+\.\d+\z/
        hash[key] = value.to_f
      else
        hash[key] = value.gsub(/^\"|\"$/, '')
      end
    end
	
    return hash
  end



}

String.instance_eval{
  def numerize(str)
    numbers=[]
	str.split('').each{ |ch| 
	  n = CHARS.index(ch).to_s
      loop do
	    if n.to_s.length < 3;  n="0"+n
		else;  break
		end
	  end
      numbers << n
	}
    return numbers.join('')  
  end
  
  def denumerize(str)
    chars=[]
	str=str.split('')
    loop do
	  if str.length == 0;  break;  end
	  chars<<CHARS[str[0..2].join('').to_i]
	  3.times{ str.delete_at(0) }
	end
    return chars.join('')
  end

  ## these copies of parse hash and array exist to allow calls like String.parse_hash ""
  
  def parse_array(str)
    if str.to_s == "[]";  return [];  end
    str = str.strip.gsub(/^\[|\]$/, '')
	elements = [];  current_element = '';  nested_level = 0
  
    str.each_char do |c|
      if c == ',' && nested_level == 0
        elements << current_element.strip
        current_element = ''
      else
        current_element += c
        if c == '[';  nested_level += 1
        elsif c == ']';  nested_level -= 1
        end
      end
    end
  
    elements << current_element.strip
  
    elements.map do |element|
      if element.start_with?('"') && element.end_with?('"')
        element.gsub(/^"|"$/, '')
      elsif element.start_with?("'") && element.end_with?("'")
        element.gsub(/^'|'$/, '')
      elsif element =~ /\A\d+\z/
        element.to_i
      elsif element =~ /\A\d+\.\d+\z/
        element.to_f
      elsif element == 'true' || element == 'false'
        element == 'true'
      elsif element.start_with?('[') && element.end_with?(']')
        self.parse_array(element)
      elsif element.start_with?('{') && element.end_with?('}')
        self.parse_hash(element)
      else
        element
      end
    end
  end


  def parse_hash(str)
    if str.to_s == "{}";  return {};  end
    str = args[0].strip.gsub(/^\{|\}$/, '')
    pairs = [];  current_key = '';   current_value = '';  nested_level = 0

    str.each_char do |c|
      if c == '>' && nested_level == 0
        current_key = current_value.gsub(/['":]\s*(\w+)\s*['":]?/, '\1');  current_key = current_key.delete(" =")
        current_value = ''
      elsif c == ',' && nested_level == 0
        pairs << [current_key, current_value.strip]
        current_key = ''
        current_value = ''
      else
        current_value += c
        if c == '{' || c == '['
          nested_level += 1
        elsif c == '}' || c == ']'
          nested_level -= 1
        end
      end
    end

    pairs << [current_key, current_value.strip]

    hash = {}
    pairs.each do |pair|
      key = pair[0]
      value = pair[1]

      if value.start_with?('{') && value.end_with?('}')
        hash[key] = value.parse_hash
      elsif value.start_with?('[') && value.end_with?(']')
        hash[key] = value.parse_array
      elsif value == 'true'
        hash[key] = true
      elsif value == 'false'
        hash[key] = false
      elsif value =~ /\A\d+\z/
        hash[key] = value.to_i
      elsif value =~ /\A\d+\.\d+\z/
        hash[key] = value.to_f
      else
        hash[key] = value.gsub(/^\"|\"$/, '')
      end
    end
	
    return hash
  end


}


#8#;#3#;#5#;#3#;#1#;#8#;#3#;#5#;#3#;#8#;#5##time.rb#5#;#6#;#9#;#9#;#4#;#5#;#6#;#7#;#9#;#6#;#4##time.rb
Time.class.class.class_eval{

  def parse_seconds(s)
    s = s.to_i
    if s < 60 ;  [0, 0, s]
    elsif s < 3600 ; [0, s / 60, s % 60]
    elsif s < 86400 ; [s / 3600, (s / 60) % 60, s % 60]
    else
      days = s / 86400
      hours = (s / 3600) % 24
      minutes = (s / 60) % 60
      seconds = s % 60
      [days, hours, minutes, seconds]
    end
  end


  def stamp(time = Time.now, delimiter = '.')
    if time.is_a?(Time)
      [time.year.to_s, format("%02d", time.month), format("%02d", time.day),
       format("%02d", time.hour), format("%02d", time.min), format("%02d", time.sec)].join(delimiter)
    elsif time.is_a?(String)
      t = time.split(delimiter)
      Time.new(t[0], t[1], t[2], t[3], t[4], t[5])
    end
  end

}
