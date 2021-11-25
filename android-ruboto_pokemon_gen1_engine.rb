##i wrote this shit homeless in a desert shack with solar power, thats why its gui is for android, the engine is like 60%
##complete, i remember making pokemon data objects, a party system, a bag, a settings menu and a good part of the battle
##core code but the version i build takes a list of moves for both teems and calculates the battle in one go, but its
##good base code for a real battle system that hangs for a gui, maybe in the next year or so ill find time to come back
## and finish the pure ruby gen1 pokemon engine.


def ivg(o,vn)
  o.instance_variable_get(vn.to_s)
end

def splice(b,e,str) ## for extracting tags, such as html
    res = []
	loop do
	  p = str[/#{b}(.*?)#{e}/m, 1].to_s
	  if p.to_s.length == 0
		break
	  else
		res << p
		str = str.split(b + p + e)[-1].to_s
	  end
	end
	return res
  end
  def rands(digits) ## returns a random string which can contain multicase letters and numbers
      key = ""
      digits.times do
         key << rand(10**8..10**9).to_s(36).to_s[rand(6).to_i].to_s
      end
      return key.to_s 
  end
  def numeric?(s) ## string has numbers only then true
     return s !~ /\D/
  end
  def fnum(n) ## put commas in large numbers for readability
    str = ''
    s = n.to_s.split("").reverse
    i=0
    s.each do |nc|
      if i == 2
        i=0
        str << nc.to_s + ","
      else
        str << nc.to_s
        i+=1
      end
    end
    if str.to_s[-1].to_s == ","
      str = str.reverse.to_s.split("")[1..-1].join("").to_s
    else
      str = str.reverse.to_s
    end
      return str
  end
  def list_spacer(spaces,left,right)  ## give two arrays of words of varying lengths, and determine how far they should be spaced apart, they will descend down the sccreen next to each other at a set distance from eachother , use with the same array to build morw than two rows
            width = spaces .to_i+ 5
	str = ''
	left.each do |l|
	  spacer = ""
	  t = width - l.length.to_i
	  t.to_i.times { spacer << " " }
	  str << l.to_s + spacer.to_s + right[left.index(l)].to_s + "\n"
	end
            return str.to_s
  end
  def numerize(str) ## turn any string into positive only numbers that never start with zero
    if str == ""
      return 0
    else
    chbytes = ["97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "126", "96", "33", "64", "35", "36", "37", "94", "38", "42", "40", "41", "45", "95", "61", "43", "91", "93", "123", "125", "59", "58", "34", "39", "92", "47", "124", "63", "60", "62", "44", "46", "32", "9", "10"]
    ch_inds = []
    str.to_s.split("").each { |ch| ch_inds << chbytes.index(ch.to_s.ord.to_s) }
	enc = []
	ch_inds.each do |ch|
      code = ch.to_i + 1
	  if code.to_s.length == 1
	    code = "0" + code.to_s
	  else
	    code = code.to_s
	  end
	  enc << code.to_s
	end
	enc = enc.join("").to_s
	if enc.to_s[0].to_s == "0"
	  enc = enc[1..-1].to_s
	end
	return enc.to_s
    end
  end
  def denumerize(str)  ## get your old string back from the numbers you generated
       kbchars = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","~","`","!","@","#","$","%","^","&","*","(",")","-","_","=","+","[","]","{","}",";",":","\"","'","\\","/","|","?","<",">",",","."," ","\t","\n"]
	if str.to_s.length.odd?
	  str = "0" + str.to_s
	end
	str_codes = []
	i = 0
	hold = ""
	str.to_s.split("").each do |num|
	  if i.to_i == 0
	    hold << num.to_s
		i += 1
	  elsif i.to_i == 1
	    hold << num.to_s
		i = 0
	    str_codes << hold.to_s
		hold = ""
	  end
	end
	str = str_codes
	str_codes = []
	str.each do |c|
	  str_codes << c.to_i - 1
	end
    dec_str = ""
    str_codes.each { |c| dec_str << kbchars[c.to_i].to_s }
	return dec_str.to_s
  end
  def exponate(n)  ## take the given number and calculate up for exponets which would result in it, stay below five digits
   c=2
   e=2
   r = [0,0]
    until c > n
	   e = 2
	   until e >= n
         if c**e == n
	       return [c,e]
	     end
         e += 1
       end
	   c += 1
     end
  end
  def factors(n) ## get two numbers that which multiplied together would result in the given value, stay below 4 digits
    p = [2]
    vn = 2
    until vn == n
      vn += 1
      p << vn
    end
    p.delete_at(-1)
    f1 = 0
    f2 = 0
    pd = []
    p.each do |pn|
      s = n.to_f / pn.to_f
      if s.to_s[-2..-1].to_s == ".0"
         pd << pn
      end
    end
    pd.each do |p|
      if p * p == n
         f1, f2 = p, p
     else
         cd = pd
         cd.delete(p)
         cd.each do |pr|
            if p * pr == n
               f1, f2 = p, pr
	break
           end
         end
      end
    end
    return [f1,f2]
  end


## this methods is for game data table building, it takes the global arrays i currently use
## to intup pokemon move and item data, and it builds custom hash table classes to 
## provide the data back to the effect processor, bag and battle systems when needed,
## these tables stills stay as global objects but when the data tables are complete
## the original global arrays of strings can be removed, pokemon, items and moves
## shall be accessed by their name from now on rather and array index number

  def make_table(dex,name)  ## class syntax will be placed in jruby directory for pasting back here at a later time
     keydex = []
     dex.each do |di|
         keydex << di.to_s.split(",")[0].to_s
      end   
     str = ""
     str << "class " + name.to_s.capitalize + "_Data\n"
     str << "  def initialize()\n"
     str << "    @keydex = " + keydex.to_s + "\n"
     str << "    @datadex = " +  dex.to_s + "\n"
     str << "  end\n"
     str << "  def get(key)\n"
     str << "      return @datadex[@keydex.index(key)]\n"
     str << "   end\n"
     str << "end\n"
     file = File.open(name.to_s.downcase + "_datadex.rb","w")
     file.write(str.to_s)
     file.close
     return [Dir.getwd.to_s + "/" +  name.to_s.downcase  + "_datadex.rb",dex.length.to_i]
  end



class VDrive
##  V1.2.2
##  Methods:
## - file_exist?(STRING)                                            path  returns boolean
## - folder_exist?(STRING)                                       path  returns boolean
## - ftype?(STRING)                                                   path  returns "FILE" , "FOLDER" , "CORRUPTED OBJ"
## - read_file(STRING)                                               path  returns string contained in file
## - write_file(STRING,STRING)                               path, content   returns string written, if file does not exist it will be created, otherwise it will be overwritten
## - insert_file(STRING,STRING,INTEGER)            path, content, character_index   returns text inserted, file must exist, if not will raise exception
## - copy_file(STRING,STRING)                                path, newpath   returns true
## - create_folder(STRING)                                        path    returns true
## - copy_folder(STRING,STRING)                           path, newpatj    returns true
## - delete_file(STRING)                                            path   returns true
## - delete_folder(STRING)                                        path   returns true
## - rename_file(STRING,STRING)                           path, newname    returns true
## - rename_folder(STRING,STRING)                      path, newname     returns true
## - import_file(STRING,STRING)                             vdrive_path, os_filepath   return location of imported file
## - export_file(STRING,STRING)                             vdrive_path, os_filepath    returns os path file exported to
## - import_folder(STRING,STRING)                        vdrive_path, os_folderpath  returns location of folder imported
## - export_folder(STRING,STRING)                        vdrive_path, os_filepath
## - backup_disk(path,password)                          os_filepath     returns true     
## - restore_disk(path,password)                           os_filepath    returns true
## - save_disk                                                                
## - load_disk                                                                
## - format_disk                                                           formats disk to brandnew then saves it
## - disk_size                                                                counts the amount of integers it takes to represent your disk
 def initialize
###DISK DATA BELOW###
@disk = '228466060966615358545554555458932284661612012505187606091205760194040120665861586158615859586158595861595458615860586258585861586158615859586158595861586158615861586158605861585958625856595558595861586258615954586158595861585959555859586258585861586158615859586158595861595458615860586158625861586058625858586258585861586258615860586258585861585958615953586158595861595558615859586159535862585758615953586158595861595358615860586258585861586058615861586158605862585858615859586159535861585958615953586258575861595358615860586159545861586058615954586158605861595458615859586158625861585958615862586158615861595458625857586159535861586058615955586158595861586258615859586158625861585958615862586158605862585858615860586258585861586058625858586258575861595358615954586159555861595458615955586159545861595558615954586159555861595558615861586159555861586158615955586158615861595558615861586159545862585658625858586158625861595458615953586258575861595358615954586159535862585758615953586159545861595358625857586159535861595458615953586258575861595358615954586159535862585858615862586159545861595358615954586158625862585758615953586159545862585793228466161201250518760401200194040120665953595559545861585658575857595558575955595458615955585959555861586158605955585959555861595458615861585958615953586158605861586258625858586158625861595358615860595458615955585959555861595458615954586159555859595558615861585959555859595558615861585959555859595558615953595559535955595458565955585959555861595458615954586159555859595558615953595559545856595558595955586159535955586158615955585959555861586158605955585959555861586158625954585659545856595558595955586159545861586258565862585858625857586159545862585658625858586258575862585658625857586159545861595458615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861595358615955586158615862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615955586158595861586058615860586158615861586058625858586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159535862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458625857586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159535861595558615861586158595862585858615861586158615861586058625858586159545861595458615954586258575861585958625858586158615861586158615860586258585861595558615860586158595862585858615861586158615861586058625858586159545861595358615954586258585862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615862586158595861595458615861586158615861586058625858586159545861586258615859586159545861586158615861586158605862585858615954586158625861585958615954586158615861586158615860586258585861595458615862586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595862585658615860586258575861586058615954586158615861586258615860586158615861586058615862586158615861586158615861586158595861585958615860586158595861586258615860586158605861586058615861586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159545861595458615862586158605861595558615860586159555861595458615955586159545862585758625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159545861595458615862586158595861586258615954586258575861586058615955586159545861595558615954586258575862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615955586158595861586058615860586158615861586058625858586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586159555861585958615860586158605861586158615860586258585861585958615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595861595558615859586158605861586058615861586158605862585858615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615860586158605862585858615860586258585862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615862586159545862585658615954586159535861595458615955586159555861586158615954586159555861595458625856586159545861595358625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159535861595458625857586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158605861595358615860586159545861586058615953586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586158625862585758625856586258575861595458625857586158595862585758615954586258585861586258625858586159545862585758615954586258565862585858625857586258565862585758615954586159545861595358625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586158615861586158615860586158605861586158615859586158615861586158615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861595558615954586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615955586158595861586058615860586158615861586058625858586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159535862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615953586159545862585758625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586158625862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615953586159545861586258615859586258585861586158615861586158605862585858615955586158595861585958625858586158615861586158615860586258585861595458615954586159545862585758615859586258585861586158615861586158605862585858615954586159535861595458615862586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258615859586159545861586158615861586158605862585858615954586158625861585958615954586158615861586158615860586258585861595458615862586158595861595458615861586158615861586058625858586159545861586258625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586258565861586058625857586158605861595458615861586158625861586058615861586158605861586258615861586158615861586158615859586158595861586058615859586158625861586058615860586158605861586158615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615954586159545861586258615860586159555861586058615955586159545861595558615954586258575862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615954586159545861586258615859586158625861595458625857586158605861595558615954586159555861595458625857586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595861595558615859586158605861586058615861586158605862585858615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615955586158595861586058615860586158615861586058625858586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586159555861585958615860586158605861586158615860586258585861585958615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595861586058615860586258585861586058625858586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258615954586258565861595458615953586159545861595558615955586158615861595458615955586159545862585658615954586159535862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615953586159545861586258625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615860586159535861586058615954586158605861595358615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615862586258575862585658625857586159545862585758615859586258575861595458625858586158625862585858615954586258575861595458625856586258585862585758625856586258575861595458615954586159555862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595558615859586159545862585858625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586159555861585958615860586158605861586158615860586258585861585958615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861595358625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159545861595558615859586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615954586159545861595558615861586158595862585858615861586158615861586058625858586159545861595358615954586258565861585958625858586158615861586158615860586258585861595458615955586159545861595358615859586258585861586158615861586158605862585858615954586159535861595558615860586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258615859586159545861586158615861586158605862585858615954586158625861585958615954586158615861586158615860586258585861595458615862586158595861595458615861586158615861586058625858586159545861586258625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586258565861586058625857586158605861595458615861586158625861586058615861586158605861586258615861586158615861586158615859586158595861586058615859586158625861586058615860586158605861586158615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615954586159545861586258615860586159555861586058615955586159545861595558615954586258575862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615954586159545861586258615859586158625861595458625857586158605861595558615954586159555861595458625857586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595861595558615859586158605861586058615861586158605862585858615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861585958615955586158595861586058615860586158615861586058625858586158595861595458625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615859586159555861585958615860586158605861586158615860586258585861585958615954586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586158595861586058615860586258585861586058625858586258575862585658625857586159545862585858615862586258585861595458625857586258565862585758615954586159545861586258615954586258565861595458615953586159545861595558615955586158615861595458615955586159545862585658615954586159535862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615953586159545862585858625857586258565862585758615954586258585861586258625858586159545862585758625856586258575861595458615860586159535861586058615954586158605861595358615859586159545862585758625856586258575861595458625858586158625862585858615954586258575862585658625857586159545861595458615862586258575862585658625857586159545862585758615859586258575861595458625858586158625862585858615954586258575861595458615859586159545861586058615862586158605861595558615861586158595861586158615954586258575861595458625858586158625862585858615954586258575861595458615859586159545861586058615862586158605861595558615861586158595861586158615954586258575861595458625858586158625862585858615954586258575861595458615859586159545861586058615862586158605861595558615861586158595861586158615954586258575861595458625857586158595954586159555859595558615953595559535955595458615856595558585856585658615857585958575955595458615954585659555859595558615953595559545861585758625857586158585856585659555857586158575860595458615955585959555861595458615857586258575861585758575856586158565858585658575857585858575858595458615955585959555861595458615856585758575860585858565856595558565860585758615858585658565861595458615955585959555861595458615857586158575954585658575857586059555861585658585856586158575954585759545858586159545861595558595955586159545861585658575857595558575955585659545857586158575858585658615955586158565858585658615857595458575954585858615954586159555859595558615954586158605862585959555955586158595858586059535954586159555859595558615954586158575859585658575857595558585856585658615857595458565858585658575858585658565955585758605856595359555861585658585856585758575858585758585954586159555859595558615954586158585857585759545856585758575860585858575857595559545861595558595955586159545861585858565857595458565861585658615857595559545861595558595955586159545861585658605856595558575954585858565954586159555859595558615954586158565858585758585856585758575955585858565856586158575954595458615955585959555861595458615857586058565955585659535856595358565861585759545954586159555859595558615954586158565953585858575857586059545861595558595955586159545861585958585858595358595953585958575955586158595856585958615858595558595953595458615955585959555861595458615858595458605857586058575860585758605857585859545861585759545861595458565955585959555861595359555861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059555859595558615861586059545856595558595955586159535955586159545861585959555859595558615862585858625858595458565954585659555859595558615857586058565955585758585955585959555861585758605856595558575858595558595955586158575860585659555857585859555859595558615857586058565955585758585955585959555861595458615861586158615859586158605862585659535861586158595861586059535861586158615861585959555861586158615861586259545860586159535861585959545860586158595861585959555861595358615861585958625856586158595861585959545861595458566767672284'
###DISK DATA ABOVE###
  load_disk
  end
  def file_exist?(loc)
    found = false ; i = 0
    @files.each do |f|
        if f.to_s.split("@")[0].to_s + "/" + f.to_s.split("@")[1].to_s == loc.to_s
          found = i ; break
        end
        i += 1
    end
    return found
  end
  def folder_exist?(loc)
    if @folders.include?(loc)
      @folders.index(loc)
    else
       false
    end
  end
  def ftype?(loc) 
     if @folders.include?(loc.to_s)
        return "FOLDER"
     else     
        found = false
        i = 0
        @files.each do |f|
           if f.split("@")[0].to_s + "/" + f.split("@")[1].to_s == loc.to_s
             found = i ; break
           else
             i += 1
          end
       end
       if found != false
         return "FILE"
       end
     end
  end
  def read_file(loc)
     found = false ; i = 0
     @files.each do |f|
        if f.split("@")[0].to_s + "/" + f.split("@")[1].to_s == loc.to_s
          found = i ; break
        else
          i += 1
       end
     end    
    if found != false
      return denumerize(@files[found].to_s.split("@")[2].to_s).to_s
    else
      raise "FILE NO EXIST ERROR"
    end
  end
  def write_file(loc,dat) ## enter valid folder path and append a file name, if it doesnt exist it will be created
    if @folders.include?(loc.to_s.split("/")[0..-2].join("/").to_s)
       found = false ; i = 0
       @files.each do |f|
         if f.split("@")[0].to_s + "/" + f.split("@")[1].to_s == loc.to_s
           found = i ; break
         else
           i += 1
         end
       end    
       if found != false ## overwrite existing file
         @files[found] = @files[found].to_s.split("@")[0..1].join("@").to_s + "@" + numerize(dat.to_s).to_s
       else ## write to new file
         @files << loc.to_s.split("/")[0..-2].join("/").to_s + "@" + loc.to_s.split("/")[-1].to_s + "@" + numerize(dat.to_s).to_s  
       end
       save_disk ; return dat.to_s
    else
      raise "DIRECTORY NON-EXISTENT: " + loc.to_s.split("/")[0..-2].join("/").to_s
    end
  end
  def delete_file(loc)
    found = false ; i = 0
    @files.each do |f|
      if f.split("@")[0].to_s + "/" + f.split("@")[1].to_s == loc.to_s
     found = i ; break
      else
        i += 1
      end
    end
     if found != false
       @files.delete_at(found)
       save_disk
       true
     else
       raise "FILE NON-EXISTENT"
     end
  end
  def read_folder(loc)  ## returns raw data for files and variables in folder and all its sub folders
    if @folders.include?(loc)
      cfiles = [] ; csubfolders = []
      @files.each do |f|
        if f.to_s.split("@")[0].to_s == loc.to_s
          cfiles << f.to_s
        end
      end
      @folders.each do |f|
        if f.to_s.split("/")[0..-2].join("/").to_s == loc.to_s
          csubfolders << f.to_s
        end
      end
      if cfiles.length == 0 and csubfolders.length == 0
        return "empty"
      elsif cfiles.length == 0 and csubfolders.length > 0
        return ["empty",csubfolders]
      elsif cfiles.length > 0 and csubfolders.length == 0
        return [cfiles,"empty"]
      else
         return [cfiles,csubfolders] 
      end
    else
      rasie "FOLDER NON-EXISTENT"
    end
  end
  def folder_contents(loc)  ## returns list of paths of subfolders and files contained in given folder path
    if @folders.include?(loc)
      @files.each do |f|
         if f.to_s.split("@")[0].to_s == loc.to_s
           contents << f.to_s.split("@")[0].to_s + "/" + f.to_s.split("@")[1].to_s
        end
      end
      @folders.each do |f|
          if f.to_s.split("/")[0..-2].join("/").to_s == loc.to_s
            contents << f.to_s
         end
      end
      if contents.length == 0
        return "empty"
      else
       return contents 
     end
   else
     raise "FOLDER NON-EXISTENT"
   end
  end
  def create_folder(loc)
    if loc.to_s[0..2] == ("v:/") 
       if @folders.include?(loc.to_s.split("/")[0..-2].join("/").to_s)
         @folders << loc.to_s
         save_disk(generate_image(files,folders))
         loc.to_s
       else
         raise "BASE FOLDER DOES NOT EXIST"
       end     
    else
      raise "MUST CREATE FOLDERS WITHIN V:/"
    end
  end
  def delete_folder(loc)
      cfiles = [] ; cfolders = [] ; remaining_folders = [loc]
      until remaining_folders.length == 0
        cont = read_folder(remaining_folders[0]) ; cfolders << remaining_folders[0] ; remaining_folders.delete_at(0)
        unless cont.to_s == "empty"
           unless cont[0].to_s == "empty" 
             cont[0].each { |c| cfiles << c.to_s }
           end
           unless cont[1].to_s == "empty"                  
             cont[1].each { |c| remaining_folders << c.to_s }
          end
        end
      end
      unless cfiles.length < 1
        cfiles.each { |f| @files.delete(f.to_s) }
      end
      unless cfolders.length < 1
        cfolders.each { |f| @folders.delete(f.to_s) }
      end
      save_disk
      true
  end
  def rename_file(loc,newname)
    found = false ; i = 0 ; @files.each do |f| ; if f.split("@")[0].to_s + "/" + f.split("@")[1].to_s == loc.to_s ; found = i ; break ; else ; i += 1 ; end ; end    
    if found != false
      @files[found] = @files[found].to_s.split("@")[0].to_s + "@" + newname.to_s + "@" + files[found].to_s.split("@")[2].to_s
      save_disk
    else
      raise "FILE NON-EXISENT"
    end
  end
  def rename_folder(loc,newname)
  end

  def import_file(loc,os_file_path)
  end
  def export_file(loc,os_file_path)
  end
  def import_folder(loc,os_file_path)
  end
  def export_folder(loc,os_file_path)
  end
  def backup_disk(diskfilepath,password)
    if password == nil or password == "" or password == "0" or password == 0
      pv = 0
    else
      pv = numerize(password.to_s).to_i
    end
    img = numerize(numerize(@files.join(",") + "###" + @folders.join(","))).to_i * pv - diskfilepath.to_s.length.to_i
    file = File.new(diskfilepath,"w")
    file.write(img.to_s) ; file.close
    diskfilepath.to_s
  end
  def restore_disk(diskfilepath,password)
    if password == nil or password == '' or password == 0
      pv = 0
    else
      pv = numerize(password.to_s).to_i
    end
    file = File.open(diskfilepath,"r")
    img = file.read.to_s ; file.close
    img = img.to_i / pv.to_i + diskfilepath.length.to_i
    @files = denumerize(img.to_s).to_s.split("###")[0].to_s.split(",")
    @folders = denumerize(img.to_s).to_s.split("###")[1].to_s.split(",")
  end
  def load_disk
    file = File.open(__FILE__,"r")
    fcont = file.read.to_s ; file.close
    disk = []
    fcont.to_s.split("###DISK " + "DATA BELOW###")[-1].to_s.split("###DISK " + "DATA ABOVE###")[0].to_s.split("@disk = '")[-1].to_s[0..-3].to_s.split('').each do |ch|
       unless ch.to_s == "\n"
         disk << ch.to_s
       end
    end
    img = disk.join('').to_s
    @files = denumerize(img.to_s).to_s.split("###")[0].to_s.split(",")
    @folders = denumerize(img.to_s).to_s.split("###")[1].to_s.split(",")
  end
  def save_disk
   img = numerize(@files.join(",") + "###" + @folders.join(",")) 
   file = File.open(__FILE__,"r")
    fcont = file.read.to_s ; file.close
    first = fcont.to_s.split("###DISK " + "DATA BELOW###")[0].to_s + "###DISK " + "DATA BELOW###"
    middle = "@disk = '" + img.to_s + "'"
    last = "###DISK " + "DATA ABOVE###" + fcont.to_s.split("###DISK " + "DATA ABOVE###")[-1].to_s
    file = File.open(__FILE__,"w") ; file.write(first.to_s + "\n" + middle.to_s + "\n" + last.to_s) ; file.close
    true
  end
  def format_disk
     @files = [] ; @folders = ['v:'] ; save_disk
  end
  def disk_size
    s = @files.join('').to_s + @folders.join('').to_s ; return s.length.to_i
  end
end






######
#
######

## general stat value formula

#gen 1 hp

# ((b + iv ) x 2 + (ev / 4 ) )
#__________________________ + lv + 10
#               100
#

#gen 1 stat

# (( b + iv ) x 2 + ( ev / 4 ) )
#__________________________ + 5
#               100
#
#

###
##  Static Game Data
###


# name , dexno , type1 , type2, bhp , battk , bdef , bspd , ev lv, ev dn, base exp , growth rate , ability , gender restrictions , learnset
  $pkmn_datadex = [   ## here is our global data array, which is soon to be replaced by hash tables
"bulbasaur,1,grass,nil,15,15,15,15,16,2,steady,overgrow,nil,tackle@1:growl@1",
"ivysaur,2,grass,nil,25,25,25,21,36,3steady,overgrow,nil,tackle@1:growl@1",
"venusaur,3,grass,nil,45,38,40,28,null,null,steady,overgrow,nil,tackle@1:growl@1"
]
class Pkmn_DataDex  ## here is the hash table, im not typing in all that crap, thus you see the make_hash_syntax method
  def initialize()
    @keydex = ["bulbasaur", "ivysaur", "venusaur"]
    @datadex = ["bulbasaur,1,grass,nil,15,15,15,15,16,2,steady,overgrow,nil,tackle@1:growl@1", "ivysaur,2,grass,nil,25,25,25,21,36,3steady,overgrow,nil,tackle@1:growl@1", "venusaur,3,grass,nil,45,38,40,28,null,null,steady,overgrow,nil,tackle@1:growl@1"]
  end
  def get(key)
      return @datadex[@keydex.index(key)].to_s.split(",").to_a
   end
  def getd(dexno)
      i = dexno.to_i - 1
      return @datadex[i].to_s.split(",").to_a
  end
end
$pkmn_datadex = Pkmn_DataDex.new()
## note to self: dont add animation code to this list because the effect processor will return a nested list of animation codes and corresponding messages
## name , power, accuracy, critica, def pp, max ppl, type, base, effect code
$move_datadex = [
"splash,0,100,0,20,40normal,physical,splash",
"struggle,30,80,0,0,0,normal,physical,struggle",
"tackle,40,100,25,35,40,normal,physical,tackle",
"pound,40,100,35,40,normal,physical,pound",
"growl,0,100,0,20,30,normal,status,growl",
"tail whip,0,100,0,35,50,normal,status,tail whip",
"quick attack,40,95,20,35,45,normal,physical,quick attack",
]
class Moves_Data
  def initialize()
    @keydex = ["splash", "struggle", "tackle", "pound", "growl", "tail whip", "quick attack"]
    @datadex = ["splash,0,100,0,20,40,normal,physical,splash", "struggle,30,80,0,0,0,normal,physical,struggle", "tackle,40,100,25,35,40,normal,physical,tackle", "pound,40,100,35,40,normal,physical,pound", "growl,0,100,0,20,30,normal,status,growl", "tail whip,0,100,0,35,50,normal,status,tail whip", "quick attack,40,95,20,35,45,normal,physical,quick attack"]
  end
  def get(move)
      return @datadex[@keydex.index(move)].to_s.split(",").to_a
   end
end
$move_datadex = Moves_Data.new

# a few notes
#
#  now use scenario and use protocol allows the bag to determine if
# it should allow items to be used and what to pass to the efc once 
# an item is being used, i.e. using a potion the eft will want the host pokemon, then return it with restored health
# or the item might be mail, which runs a diolog to initialize before passing to the mail storage system which tracks pokemon and pc mail and its contents
#
## name, pocket , value , disposable , sellable , effect code , description, use condition , use scenario
$item_datadex = [
"potion,items,200,true,true,potion,Restores 20 HP to a pokemon.,['field','battle'],party_select",
"super potion,items,200,true,super potion,00fc,Restores 20 HP to a pokemon.,dual",
"hyper potion,items,200,true,true,hyper potion,Restores 50 HP to a pokemon.,dual",
"max potion,items,200,true,true,max potion,Restores 200 HP to a pokemon.,dual",
"full restore,items,200,true,true,full restore,Restores all HP to a pokemon.,dual",
"full heal,items,200,true,true,full heal,heals a pokemon of any status condition.,dual",
"revive,items,200,true,true,revive,Revives a fainted pokemon restoring half its HP.,dual",
"max revive,items,200,true,true,max revive,Revives a fainted pokemon restoring all its HP.,dual",
"ether,items,200,true,true,ether,Restores some PP to a selected move.,dual",
"max ether,items,200,true,true,max ether,Fully restores the PP of a selected move.,dual",
"elixer,items,200,true,true,elixer,Restores some PP to a pokemons moves.,dual",
"max elixer,items,200,true,true,max elixer,Fully restores the PP of a pokemons moves.,dual",
"antidote,items,200,true,true,antidote,heals a poisoned pokemon.,dual",
"paralyz heal,items,200,true,true,paralyz heal,Heals a paralyzed pokemon.,dual",
"burn heal,items,200,true,true,burn heal,Heals pokemon with burns.,dual",
"ice heal,items,200,true,true,ice heal,Defrosts frozen pokemon.,dual",
"awakening,items,200,true,true,awakening,Wakes sleeping pokemon.,dual",
"lava cookie,items,200,true,true,lava cookie,Restores the status of a pokemon.,dual",
"castella cone,items,200,true,true,castellia cone,Restores the status of a pokemon.,dual",
"old cheatu,items,200,true,true,old cheatu,Restores the status of a pokemon.,dual",
"fresh water,items,200,true,true,fresh water,Restores 50 HP to a pokemon.,dual",
"soda pop,items,200,true,true,soda pop,Restores 80 HP to a pokemon.,dual",
"lemonade,items,200,true,true,lemonade,Restores 100 HP to a pokemon.,dual",
"energy powder,items,200,true,true,energy powder,A bitter tasting powder that restores 80 HP to a pokemon.,dual",
"energy root,items,200,true,true,energy root,A dense root packed with energy, it will restore 200 HP to a pokemon.,dual",
"revival herb,items,200,true,true,revival herb,Revives a fainted pokemon and fully restores its hp, taste very bitter however.,dual",
"x attack,items,200,true,true,x attack,Raise the attack of a pokemon in battle.,battle",
"x defend,items,200,true,true,x defend,Raise the defense of a pokemon in battle.,battle",
"dire hit,items,200,true,true,dire hit,Raise the cirtical hit ratio of a pokemon in battle.,battle",
"x accuracy,items,200,true,true,x accuracy,Raise the accuracy of a pokemon in battle.,battle",
"rare candy,items,200,true,true,rare candy,Increases the level of a pokemon by one.,bag",
"protine,items,200,true,true,protine,Increses the attack stat of a pokemon.,bag",
"iron,items,200,true,true,iron,Increases the defense stat of a pokemon.,bag",
"zinc,items,200,true,true,zinc,Increases the special defense stat of a pokemon.,bag",
"carbos,items,200,true,true,carbos,increases the speed stat of a pokemon.,bag",
"hp up,items,200,true,true,hp up,Increases the HP stat of a pokemon.,bag",
"pp up,items,200,true,true,pp up,increases the PP of a pokemons move.,bag",
"pp max,items,200,true,true,pp max,maximizes the PP of a pokemons move.,bag"
]
class Item_DataDex
  def initialize()
    @keydex = ["potion", "super potion", "hyper potion", "max potion", "full restore", "full heal", "revive", "max revive", "ether", "max ether", "elixer", "max elixer", "antidote", "paralyz heal", "burn heal", "ice heal", "awakening", "lava cookie", "castella cone", "old cheatu", "fresh water", "soda pop", "lemonade", "energy powder", "energy root", "revival herb", "x attack", "x defend", "dire hit", "x accuracy", "rare candy", "protine", "iron", "zinc", "carbos", "hp up", "pp up", "pp max"]
    @datadex = ["potion,items,200,true,true,potion,Restores 20 HP to a pokemon.,dual", "super potion,items,200,true,super potion,00fc,Restores 20 HP to a pokemon.,dual", "hyper potion,items,200,true,true,hyper potion,Restores 50 HP to a pokemon.,dual", "max potion,items,200,true,true,max potion,Restores 200 HP to a pokemon.,dual", "full restore,items,200,true,true,full restore,Restores all HP to a pokemon.,dual", "full heal,items,200,true,true,full heal,heals a pokemon of any status condition.,dual", "revive,items,200,true,true,revive,Revives a fainted pokemon restoring half its HP.,dual", "max revive,items,200,true,true,max revive,Revives a fainted pokemon restoring all its HP.,dual", "ether,items,200,true,true,ether,Restores some PP to a selected move.,dual", "max ether,items,200,true,true,max ether,Fully restores the PP of a selected move.,dual", "elixer,items,200,true,true,elixer,Restores some PP to a pokemons moves.,dual", "max elixer,items,200,true,true,max elixer,Fully restores the PP of a pokemons moves.,dual", "antidote,items,200,true,true,antidote,heals a poisoned pokemon.,dual", "paralyz heal,items,200,true,true,paralyz heal,Heals a paralyzed pokemon.,dual", "burn heal,items,200,true,true,burn heal,Heals pokemon with burns.,dual", "ice heal,items,200,true,true,ice heal,Defrosts frozen pokemon.,dual", "awakening,items,200,true,true,awakening,Wakes sleeping pokemon.,dual", "lava cookie,items,200,true,true,lava cookie,Restores the status of a pokemon.,dual", "castella cone,items,200,true,true,castellia cone,Restores the status of a pokemon.,dual", "old cheatu,items,200,true,true,old cheatu,Restores the status of a pokemon.,dual", "fresh water,items,200,true,true,fresh water,Restores 50 HP to a pokemon.,dual", "soda pop,items,200,true,true,soda pop,Restores 80 HP to a pokemon.,dual", "lemonade,items,200,true,true,lemonade,Restores 100 HP to a pokemon.,dual", "energy powder,items,200,true,true,energy powder,A bitter tasting powder that restores 80 HP to a pokemon.,dual", "energy root,items,200,true,true,energy root,A dense root packed with energy, it will restore 200 HP to a pokemon.,dual", "revival herb,items,200,true,true,revival herb,Revives a fainted pokemon and fully restores its hp, taste very bitter however.,dual", "x attack,items,200,true,true,x attack,Raise the attack of a pokemon in battle.,battle", "x defend,items,200,true,true,x defend,Raise the defense of a pokemon in battle.,battle", "dire hit,items,200,true,true,dire hit,Raise the cirtical hit ratio of a pokemon in battle.,battle", "x accuracy,items,200,true,true,x accuracy,Raise the accuracy of a pokemon in battle.,battle", "rare candy,items,200,true,true,rare candy,Increases the level of a pokemon by one.,bag", "protine,items,200,true,true,protine,Increses the attack stat of a pokemon.,bag", "iron,items,200,true,true,iron,Increases the defense stat of a pokemon.,bag", "zinc,items,200,true,true,zinc,Increases the special defense stat of a pokemon.,bag", "carbos,items,200,true,true,carbos,increases the speed stat of a pokemon.,bag", "hp up,items,200,true,true,hp up,Increases the HP stat of a pokemon.,bag", "pp up,items,200,true,true,pp up,increases the PP of a pokemons move.,bag", "pp max,items,200,true,true,pp max,maximizes the PP of a pokemons move.,bag"]
  end
  def get(key)
      if @keydex.include?(key.to_s)
         return @datadex[@keydex.index(key)].split(",")
      else
          return false
      end
   end
end
$item_datadex = Item_DataDex.new

## POKEMON, MOVES, and ITEMS are the main things with static data being queeried by the game system
## 
## any additional static game data like encounters, maps, trainers would go below 
## we can start with types, type effect values, natures and  such
##

## name , weak againts, strong against
$types = [
"normal",
"fighting",
"rock",
"ground",
"steel",
"bug",
"grass",
"fire",
"water",
"flying",
"dragon",
"dark",
"psychic",
"poison",
"electric",
"ice",
"fairy"
]

$type_datadex = [
"water>ground",
"water>fire",
"water<grass",
]
## this above is about to be followed by a hash table that returns the proper decimal value modifier for type combinations provided by the battle system

## name ,  modifiers
$nature_datadex = [
"shy,attack=0.7:speed=1.3",
"timid,",
"hasty,",
"bold,",
"hardy,",
"adamant,",
"jolly,",
"gentle,",
"careful,",
"quirky,",
"finicky,",
"55,",
"66,",
"rash,",
"harsh,",
"77,",
"88,",
]
##
## About the Pokemon Object
##
##  This object class represents a real, live pokemon. it does not hold 
##   things like dex number or type, those are static data which never change.
##   it only holds changing values, like stats, moves, happieness, ect.
##
##  when initializing it you can make a new pokemon and set its level, name, gender and egg state
## or load a string of data from another pokemon object
##
class Pokemon_Object
  # pokemon object methods below:  

  # screen_name?                                           # returns the nickname, or the species name if no nick name, its for display use
  # nickname?                                                 # returns nickname or false if none
  # change_nickname(new_name)            # returns true if player can rename pokemon 
  # species_name?                                        # returns pokemon dex name as string
  # level?                                                          # returns level integer
  # dexno?                                                       # returns dex number integer
  # types?                                                        # returns an array containing either one or two type names as strings
  # ability?                                             # returns ability name as string
  # nature?                                            # returns nature name as string
  # held_item?                                # returns held item name or false of no item
  # give_item(i)                               # item_name, returns nil
  # take_item                                  # returns item_name
  # can_evolve?                             # returns true if the pokemon has an evolution path in the pokedex
  # ot?                                                     # returns ot name as string
  # idno?                                                 # returns id number as string
  # shiney?     not implemented yet
  # pokerus? not implemented yet

  # exp_to_next_level?
  # cur_exp?
  # max_exp?
  # gain_exp(n)

  # move_set?                                # returns an array containing move names as strings
  # restore_pp                                # returns nil
  # deplete_pp(move)                  # move : move name , returns nil
  # recover_pp(move,n)               # returns nil
  # lose_pp(move,n)                     # returns nil
  # cur_pp?                                     # returns array of integers for moveset
  # max_pp?                                   # returns array of integers for moveset
  # teach_move(move)                 # returns false if no more room to learn a move, true other wise
  # forget_move(move)               # returns true

  # status?                                      # returns false if no status
  # fainted?                                     # returns true if cur_hp is less than 1
  # set_status(status)                  # burn , poison, frozen, sleep, paralyzed, confused , attracted    , returns nil
  # full_recovery                             # returns nil
  # restore_hp                                # returns nil
  # deplete_hp                               # returns nil
  # recover_hp(n)                          # returns actual amount restored as integer 
  # lose_hp(n)                                # returns nil 
  # max_hp?                                            # returns max hp for the pokemon as integer
  # cur_hp?                                             # returns the actual health remaining of pokemon as integer
  # attack?                                              # returns attack stat for pokemon as integer
  # defense?                     
  # speed?
  # accuracy?
  # evasion?

  # recover_stat_level(stat)         # attack defense speed accuracy evasion, returns true if stat had room to be raised, false otherwise
  # restore_stat_levels                 # returns nil
  # raise_stat_level(stat)              # attack defense speed accuracy evasion 
  # lower_stat_level(stat)            # attack defense speed accuracy evasion, returns true if stat had room to be lowered, and false other wise
  #pokemon object methods above
  #pokemon object data variables below:
  #
  # @dexno
  # @nickname
  # @status
  # @gender
  # @held_item
  # @level
  # @ivs = []
  # @evs = []
  # @exp
  # @cur_hp
  # @move_set
  # @move_power
  # @cur_pp
  # @egg ( @steps if true )
  # @shiney
  # @pokerus
  # @ot_name
   # @idno
  # @nature
  # @ribbons
  # @happieness
  # pokemon object variables above
  def initialize(mode,data)
      if mode == "new"     # dat: dexno, level, nickname, gender, eggstate
        @dexno = data[0].to_i
        if data[2].to_s == "nil" or data[2].to_s == ""
           @nickname = ""
        elsif data[2].to_s.length >= 1
           @nickname = data[2].to_s
       end
        @status = false
        if data[3].to_s != ""
           @gender = data[3].to_i
        else
           if $pkmn_datadex.getd(@dexno)[13].to_s == "nil"
             @gender = rand(2).to_s
           elsif $pkmn_datadex.getd(@dexno)[13].to_s == "0"
             @gender = 1
          elsif $pkmn_datadex.getd(@dexno)[13].to_s == "1"
             @gender = 0
          elsif $pkmn_datadex.getd(@dexno)[13].to_s == "true"
             @gender = nil
          end
        end
        @held_item = nil
        @level = data[1].to_i
        @exp = $pkmn_datadex.getd(@dexno)[10].to_i
        @ivs = []
        4.times do 
          @ivs << rand(33).to_i 
        end
        @evs = [0,0,0,0]      
       learnset = $pkmn_datadex.getd(@dexno)[-1].to_s.split(":")
       learnable = []
       learnset.each do |move|
         if move.to_s.split("@")[-1].to_i <= @level.to_i
            learnable << move.split("@")[0].to_s
         end
       end
       @cur_hp = max_hp?
       @move_set = []
        [learnable[-1].to_s,learnable[-2].to_s,learnable[-3].to_s,learnable[-4].to_s].each do |m|
         if m.to_s != ""
           @move_set << m.to_s
         end
       end
       @cur_pp = []
       @move_power = []
       @move_set.each do |move|
         if move.to_s != ""
           @move_power << $move_datadex.get(move.to_s)[4].to_i
         end
      end
       @cur_pp = @move_power 
       if data[4].to_s == "true" # egg state
          @egg = true
          @steps = 1#(steps to hatch)
        else
          @egg = false
        end
        if rand(100) == rand(100)
          @shiney = true
        else 
          @shiney = false
        end
        if rand(45) == rand(45)
          @pokerus = true
        else
          @pokerus = false  
        end
        @ot = ""
        @idno = ""
        @nature = rand(17)
        @ribbons = ["none"]
        @happiness = 0
     elsif mode == "load" ## data : use 'get_data_object' to get data to put here
       set_data(data)
     end
     @attack_level = 1
     @defense_level = 1
     @speed_level = 1
     @accuracy_level = 1
     @evasion_level = 1
  end
  def get_data
     dat = [] 
     dat << @dexno.to_s
     dat << @nickname.to_s 
     dat << @cur_hp.to_s
     dat << @status.to_s
     dat << @gender.to_s
     dat << @held_item.to_s
     dat << @level.to_s
     dat << @exp.to_s
     ivs = [] ; @ivs.each { |i| ivs << i.to_s }
     dat << ivs.join("ivs").to_s
     evs = [] ; @evs.each { |e| evs << e.to_s }
     dat << evs.join("evs").to_s
     dat << @move_set.join("mv").to_s
     mp = [] ; @move_power.each { |m| mp << m.to_s }
     dat << mp.join("pp").to_s
     cp = [] ; @cur_pp.each { |p| cp << p.to_s }
     dat << cp.join("c5p").to_s
     dat << @egg.to_s
     dat << @shiney.to_s
     dat << @pokerus.to_s
     dat << @ot.to_s
     dat << @idno.to_s
     dat << @nature.to_s
     dat << @ribbons.join("rbb00").to_s
     dat << @happiness.to_s
     return dat
  end
  def set_data(d)
       @dexno = d[0].to_i
       @nickname = d[1].to_s
       @cur_hp = d[2].to_i
       if d[3].to_s == "false"
         @status = false 
       else
         @status =  d[3].to_s
       end
       if d[4].to_s == "false"    
          @gender = false
       else
         @gender = d[4].to_s
       end
       if d[5].to_s == "false"
          @held_item = false
      else       
          @held_item = d[5].to_s
      end
       @level = d[6].to_i
       @exp = d[7].to_i
       @ivs = [] ; d[8].to_s.split("ivs").each { |iv| @ivs << iv.to_i }
       @evs = [] ; d[9].to_s.split("evs").each { |ev| @evs <<ev.to_i }
       @move_set = d[10].to_s.split("mv")
       @move_power = [] ; d[11].to_s.split("pp").each { |mp| @move_power << mp.to_i }
       @cur_pp = [] ; d[12].to_s.split("c5p").each { |cp| @cur_pp <<cp.to_i }
       if d[13].to_s == "true"
         @egg = true
       else
         @egg = false
       end
       if d[14].to_s == "true"
         @shiney = true
       else
          @shiney = false
       end
       if d[15].to_s == "true"
         @pokerus = true
      else
         @pokerus = false
      end       
      @ot = d[16].to_s
      @idno = d[17].to_s
      @nature = d[18].to_s
      @ribbons = d[19].to_s.split("rbb00")
      @happiness = d[20].to_i
      self
  end

  def recover_stat_level(stat)
     if stat.to_s == "attack"
       @attack_level = 1
     elsif stat.to_s == "defense"    
       @defense_level = 1
     elsif stat.to_s == "speed"
       @speed_level = 1
     elsif stat.to_s == "accuracy"     
       @accuracy_level = 1
     elsif stat.to_s == "evasion"
      @evasion_level = 1
     end
  end


  def restore_stat_levels
     @attack_level = 1
     @defense_level = 1
     @speed_level = 1
     @accuracy_level = 1
     @evasion_level = 1
  end

  def raise_stat_level(stat)
     if stat.to_s == "attack"
       if @attack_level.to_i < 6
          @attack_level = @attack_level + 1
          return true
       else
          return false
       end
     elsif stat.to_s == "defense"
        if @defense_level.to_i < 6
           @defense_level = @defense_level + 1
           return true
        else
           return false
        end
     elsif stat.to_s == "speed"
       if @speed_level.to_i < 6
          @speed_level = @speed_level + 1
          return true
       else
          return false
       end
     elsif stat.to_s == "accuracy"
       if @accuracy_level.to_i < 6
          @accuracy_level = @accuracy_level + 1
          return true
       else
          return false
       end
     elsif stat.to_s == "evasion"
       if @evasion_level.to_i < 6
          @evasion_level = @evasion_level + 1
          return true
       else
          return false
       end
     end
  end

  def lower_stat_level(stat)
    if stat.to_s == "attack"
       if @attack_level.to_i > -6
          @attack_level = @attack_level - 1
          return true
       else
          return false
       end
    elsif stat.to_s == "defense"
       if @defense_level.to_i > -6
          @defense_level = @defense_level - 1
          return true
       else
          return false
       end
    elsif stat.to_s == "speed"
       if @speed_level.to_i > -6
          @speed_level = @speed_level - 1
          return true
       else
          return false
       end
    elsif stat.to_s == "accuracy"
       if @accuracy_level.to_i > -6
          @accuracy_level = @accuracy_level - 1
          return true
       else
          return false
       end
    elsif stat.to_s == "evasion"
       if @evasion_level.to_i > -6
          @evasion_level = @evasion_level - 1
          return true
       else
          return false
       end
    end
  end


  def restore_hp
    @cur_hp = max_hp?
  end
  def deplete_hp
    @cur_hp = 0
  end
  def recover_hp(v)
    if @cur_hp + v >= max_hp?
      restore_hp
    else
       @cur_hp = @cur_hp + v
    end
  end
  def lose_hp(v)
    if v >= @cur_hp
       @cur_hp = 0
    else
       @cur_hp = @cur_hp - v
    end
  end
  def restore_pp
    @cur_pp = @move_power
  end
  def deplete_pp(m)
     i = @move_set.index(m.to_s).to_i
     @cur_pp[i] = 0
  end  
  def recover_pp(m,v)
    i = @move_set.index(m.to_s)    
    if @cur_pp[i] + v >= @move_power[i]
      @cur_pp[i] = @move_power[i]
    else
      @cur_pp[i] = @cur_pp[i] + v
    end
  end
  def lose_pp(m,v)
    i = @move_set.index(m.to_s).to_i
    if @cur_pp[i] - v <= 0
      @cur_pp[i] = 0
    else
      @cur_pp[i] = @cur_pp[i] - v
    end
  end
  def cur_pp?
    return @cur_pp
  end
  def max_pp?
     return @move_power
  end
  def status?
    return @status
  end
  def set_status(s)
    @status = s.to_s
  end
  def heal_status
    @status = false
  end

  def full_recovery
    restore_hp
    restore_pp
    heal_status
  end
  def held_item?
     return @held_item
  end
  def give_item(i)
     @held_item = i.to_s
  end
  def take_item
     i = @held_item ; @held_item = false
     return i.to_s
  end
  def fainted?
     if @cur_hp > 0
       false
    else
       true
    end
  end
  def level?
    return @level.to_i
  end
  def dexno?
    return @dexno.to_i
  end
  def types?
    d = @dexno - 1    
    t1 = $pkmn_datadex.getd(@dexno)[2].to_s
    t2 = $pkmn_datadex.getd(@dexno)[3].to_s      
    return [t1,t2]
  end
  def move_set?
     return @move_set
  end
  def teach_move(move) ## add move replacement value since this wont be called until after the ui gives us the info
     if @move_set.length < 4
       @move_set << move.to_s
       @move_power << $move_datadex.get(move)[4].to_i
        @cur_pp << @move_power[-1].to_i
       return true
     else
       return false
     end
  end
  def auto_learn_move(move)
  end
  def forget_move(move)
    i = @move_set.index(move)
    @move_set.delete_at(i) ; @move_power.delete_at(i) ; @cur_pp.delete_at(i)
    true
  end
  def can_evolve?
    d = @dexno - 1
    if $pkmn_datadex.getd(@dexno)[0].to_s == "false"
      return false
    else
        return true
    end
  end
  def screen_name?
    if nickname? == false
       return species_name?.to_s.capitalize
    else
       return @nickname.to_s
    end
  end
  def nickname?
     if @nickname.to_s == ""
       return false
    else
       return @nickname.to_s
    end
  end
  def change_nickname(newname)
    if @idno.to_s == $player.get_data[2].to_s and @ot == $player.get_data[0].to_s
      @nickname = newname.to_s
      return true
    else  ## you didnt catch it / you arent the first trainer
      return false
    end
  end
  def species_name?
    return $pkmn_datadex.getd(@dexno)[0].to_s
  end
  def ability?
    return $pkmn_datadex.getd(@dexno)[12].to_s
  end
  def hidden_ability?
  end
  def nature?
     return $nature_datadex.get(@nature.to_s)[0].to_s
  end
  def ot?
     return @ot.to_s
  end
  def idno?
     return @idno.to_s
  end
  def max_hp?
    base_hp = $pkmn_datadex.getd(@dexno)[4].to_i
    hp_iv = @ivs[0].to_i
    hp_ev = @evs[0].to_i
    hp = ((( base_hp + hp_iv ) * 2 + ( hp_ev / 4 )) * @level.to_i ) / 100 + @level.to_i + 10
    return hp.to_i
  end
  def cur_hp?
    return @cur_hp.to_i
  end
  def attack?
    base_attk = $pkmn_datadex.getd(@dexno)[5].to_i
    attk_iv = @ivs[1].to_i
    attk_ev = @evs[1].to_i
    attk = ((( base_attk + attk_iv ) * 2 + ( attk_ev / 4 )) * @level.to_i ) / 100 + 5
    return attk.to_i
  end
  def defense?
    base_def = $pkmn_datadex.getd(@dexno)[6].to_i
    def_iv = @ivs[2].to_i
    def_ev = @evs[2].to_i
    defe = ((( base_def + def_iv ) * 2 + ( def_ev / 4 )) * @level.to_i ) / 100 + 5
    return defe.to_i
  end

  def special_attack?
  end
  def special_defense?
  end

  def speed?
    base_spd = $pkmn_datadex.getd(@dexno)[7].to_i
    spd_iv = @ivs[1].to_i
    spd_ev = @evs[1].to_i
    spd = ((( base_spd + spd_iv ) * 2 + ( spd_ev / 4 )) * @level.to_i ) / 100 + 5
    return spd.to_i
  end
  def accuracy?
  end
  def evasion?
  end

end

##
##  Party object, battle system can process battle using two party objects
##
class Party
  def initialize
      @slot_one = "empty"
      @slot_two = "empty"
      @slot_three = "empty"
      @slot_four = "empty"
      @slot_five = "empty"
      @slot_six = "empty"
   end
   def deposit_obj(obj)
     if obj.instance_variable_get("@ot").to_s == ""
       obj.instance_variable_set("@ot",$player.get_data[0].to_s)
       obj.instance_variable_set("@idno",$player.get_data[2].to_s)
     end
     ##set "met at route/level" here
     if @slot_one != "empty"
       if @slot_two != "empty"
         if @slot_three != "empty"
           if @slot_four != "empty"
              if @slot_five != "empty"
                if @slot_six != "empty"
                  #r = $pokemon_storage_system.field_deposit(obj)#attempt pc field deposit, if fails return false and no add pokedex info
                  r = fasle
                else
                  @slot_six = obj
                  r = true 
                end
              else
                @slot_five = obj
                r = true
              end
           else
             @slot_four = obj
             r = true
           end
         else
           @slot_three = obj
           r = true
         end
       else
         @slot_two = obj
         r = true
       end
     else
       @slot_one = obj
       r = true
     end
     if r 
       $player.pokedex.obtained_pokemon(obj.dexno?) ; true
     else
        false
     end
   end
   def withdraw_obj(i) # treat party as an array when withdrawing pokemon objects
     if i == 0
       o = @slot_one ; @slot_one = @slot_two ; @slot_two = @slot_three ; @slot_three = @slot_four ; @slot_five = @slot_six ; @slot_six = nil ; o
     elsif i == 1
       o = @slot_two ; @slot_two = @slot_three ; @slot_three = @slot_four ; @slot_four = @slot_five ; @slot_fivve = @slot_six ; o
     elsif i == 2
       o = @slot_three ; @slot_three = @slot_four ; @slot_four = @slot_five ; @slot_five = @slot_six ; o
     elsif i == 3
       o = @slot_four ; @slot_four = @slot_five ; @slot_five = @slot_six ; o
     elsif i == 4
       o = @slot_five ; @slot_five = @slot_six ; o
     elsif i == 5
       o = @slot_six ; @slot_six = nil ; o
     end
   end
  def count
     i = 0
     if @slot_one != "empty"
       i += 1
     end
     if @slot_two != "empty"
       i += 1
     end
     if @slot_three != "empty"
       i += 1
     end
     if @slot_four != "empty"
       i += 1
     end
     if @slot_five != "empty"
       i += 1
     end
     if @slot_six != "empty"
       i += 1
     end
     return i.to_i
  end

  def pokemon_summary(s)
    if s == 0
       s = @slot_one
    elsif s == 1
       s = @slot_two
    elsif s == 2
       s = @slot_three
    elsif s == 3
       s = @slot_four
    elsif s == 4
       s = @slot_five
    elsif s == 5
       s = @slot_six
    end
    if s.nickname?.  == ""
      n = s.screen_name?.to_s
    else
      n = s.screen_name?.to_s + " - " + s.species_name?.to_s.capitalize
    end
    if s.types?.length == 2
       t = s.types?[0].to_s + "/" + s.types?[1].to_s
     else
       t = s.types?[0].to_s
     end
     g = ""
     if s.instance_variable_get("@gender").to_s == "0"
       g = "Female"
     elsif s.instance_variable_get("@gender").to_s == "1"
       g = "Male"
     end
    str = "## Summary #########\n"
    str << " Name: " +   n.to_s + "\n"
    str << " Dexno. " + s.instance_variable_get("@dexno").to_s + "\n"
    str << " Level : " + s.level?.to_s
    str << "Exp: " #+ s.exp?.to_s
    str << "\n"
    str << "Nature: " + $natures[s.instance_variable_get("@nature").to_i].to_s.capitalize + "\n"
    str << "\n"
    str << "Type : " + t.to_s + "\n"
    str << "\n"
    str << "Hp: " + s.cur_hp?.to_s + "/" + s.max_hp?.to_s + "\n"
    str << "Attack: " + s.attack?.to_s + "\n"
    str << "Defense: " + s.defense?.to_s + "\n"
    str << "Speed: " + s.speed?.to_s + "\n"
    str << "\n"
    str << "Moves:\n"
    if s.move_set?[0].to_s == ""
      str << "-----\n"
   else
     #str << s.move_set?[0].to_s.capitalize +" " + s.cur_pp(0).to_s +"/" + s.max_pp?(s.move_set?[0]).to_s + " Type: "+  $move_datadex.get(s.move_set?[0]).to_s.split(",")[3].to_s + " Power: "+ $move_datadex.get(s.move_set?[0]).to_s.split(",")[4].to_s + " Accuracy: " + $move_datadex.get(s.move_set?[0]).to_s.split(",")[5].to_s + " Base: " + $move_datadex.get(s.move_set?[0]).to_s.split(",")[6].to_s
   end
    str << " \n"
    str << "\n"

    return str.to_s
  end

  def summary
    str = ""
    get_data.each do |p|
      if p.to_s == "empty"
        str << "-----\n"
      else
        if p.status?.to_s != "false"
          s = ", " + p.status.to_s
       end
       if p.held_item?.to_s != "false"
         i = ", " + p.held_item?.to_s
       end
        str << p.screen_name?.to_s + " Lv. " + p.level?.to_s + s.to_s + i.to_s + "\n"
      end
    end
    return str.to_s
  end





  def get_data
    return [@slot_one,@slot_two,@slot_three,@slot_four,@slot_five,@slot_six]
  end
  def set_data(da)
      @slot_one = da[0]
      @slot_two = da[1]
      @slot_three = da[2]
      @slot_four =  da[3]
      @slot_five =  da[4]
      @slot_six = da[5]
  end
  def get_image
     dat = []
     get_data.each do |p|
        if p == "empty"
           dat <<"empty"
        else
          dat << p.get_data.to_s
        end
     end
   return numerize(dat.to_s)
  end
  def set_image(img)
     img = eval(denumerize(img).to_s)
     p = []
     img.each do |f|
        if f.to_s == "empty"
          p << "empty"
       else
          d = eval(f).to_a
          p << Pokemon_Object.new("load",d)
       end
     end
     self.set_data(p)
  end
end

         
class Pokemon_Storage_System
  def initialize
    @boxes = []
    @empty_box = []
    30.times { @empty_box << "empty" }
    24.times { @boxes << @empty_box}
  end
  def get_box(i)
    return @boxes[i]
  end
  def set_box(i,b)
     @boxes[i] = b
  end
  def get_boxes
    return @boxes
  end
  def set_boxes(b)
    @boxes = b
  end

  def get_image
  end
  def set_image(img)
  end

end


class Item_Storage_System
  def initialize
  end
  def get_data
  end
  def set_data(dat)
  end
  def get_image
  end
  def set_image(img)
  end
end


class Pokegear
  def initialize
  end
  def get_data
  end
  def set_data(dat)
  end
  def get_image
  end
  def set_image(img)
  end
end

class Pokedex
  def initialize
     @region_modes = ["national","kanto","jhoto","hoenn","sinnoh","unova","x/y","sun/moon"]    
     @region_values = ["0-150","151-293","294-306","","","",""]
     @modes_unlocked = []
     @mode = nil
     @seen = [] ; @paged = []
  end

  def seen_pokemon(indexno) ## any time facing a pokemon in battle, viewing a pokemon in trade negotiations , or from pokedex page sharing from npc or linked player
     unless @seen.include?(indexno)
        @seen << indexno
     end
  end
  def obtained_pokemon(indexno) #any time a pokemon is added to the party, or pc this check is performed, this way hack obtained pokemon can get paged too
     unless @paged.include?(indexno)
       @paged << indexno
     end
  end

  def seen?
     @seen.length
  end
  def obtained?
     @paged.length
  end


  def get_data
     return [@modes_unlocked,@mode,@seen,@paged]
  end
  def set_data(dat)
     @modes_unlocked = dat[0]
     @mode = dat[1].to_s
     @seen = dat[2]
     @paged = dat[3]
  end
  def get_image
     return numerize(get_data.to_s).to_s
  end
  def set_image(img)
     set_data(eval(denumerize(img)).to_a)
  end
end

class Player_Record_System
  def initialize
    @battles = 0
    @battles_won = 0
    @battle_ties = 0
    @battles_forfieted = 0
    @wild_battles = 0
    @wild_battles_won = 0
    @wild_battles_ties = 0
    @wild_battles_fled_from = 0
    @trainer_battles = 0
    @trainer_battles_won = 0
    @trainer_battles_forfieted = 0
    @trainer_battle_ties = 0
    @shineys_seen = 0
    @wild_shineys_defeated = 0
    @wild_shineys_caught = 0
    @trainers_shineys_battled = 0    
    @link_battles = 0
    @link_battles_won = 0
    @link_trades = 0    
    @items_recieved_via_trade = 0
    @items_given_via_trade = 0
    @shineys_given_via_trade = 0
    @shineys_recieved_via_trade = 0 
    @money_earned = 0
  end
  def get_data
  end
  def set_data(dat)
  end
  def get_image
  end
  def set_image(img)
  end
end

class Link_Battle_System
  def initialize
  end
end

class CPU_Battle_System
  def initialize
  end
  def process_turn(move) ## move name lliterally
  end
end

class Wild_Battle_System  ## simple battle system processes fight between party slot 1 and a foe object
  def initialize(party,foe_type,dat) 
    $player.pokedex.seen_pokemon(dat[0])
    @party = party
     if foe_type == "general" #dat: dexno, lv
       @foe = Pokemon_Object.new("new",[dat[0].to_i,dat[1].to_s,"",false])
    elsif foe_type == "custom" #dat: pokemon_object_data
       @foe = Pokemon_Object.new("load",dat)
    end
   @switch_flag = false  ## not really nessicary but can make things more easy for the effect processor puling off moves like roar, dragon tail or whirlwind, this flag just tells the gui to run the switch pokemon dialog, like if the first pokrmon is ofund to have 0 hp at the end of the turn process method
  end
  def process_turn(move)
    animation_sequence = []
    message_sequence = []
    if @party.get_data[0].speed? > @foe.speed?
       @party.get_data[0].lose_pp(move,1)
       if rand(101) < $move_datadex.get(move).to_s.split(",")[2].to_i * @party.get_data[0].accuracy? * @foe.evasion?
         @foe.lose_hp(calculate_damage(@party.get_data[0],move,@foe))
         message_sequence << @party.get_data[0].screen_name?.to_s + " used " + move.to_s ; animation_sequence << ""
       else
          message_sequence <<  @party.get_data[0].screen_name?.to_s + "'s attack missed." ; animation_sequence << ""
       end
       wild_move = @foe.move_set?[rand(5).to_s].to_s
       @foe.lose_pp(wild_move,1)
       if rand(101) <= $move_datadex.get(wild_move).to_s.split(",")[2].to_i * @foe.accuracy? * @party.get_data[0].evasion?
          @party.get_data[0].lose_hp(calculate_damage(@foe,wild_move,@party.get_data[0]))
          message_sequence << @foe.screen_name?.to_s + " used " + wild_move.to_s ; animation_sequence << ""
      else
          message_sequence << "Foe " + @foe.screen_name.to_s + "'s attack missed." ; animation_sequence << ""
      end
   else  ## foe is quicker than head pokemon  
     wild_move = @foe.move_set?[rand(5).to_s].to_s
      @foe.lose_pp(wild_move,1)
      if rand(101) <= $move_datadex.get(wild_move).to_s.split(",")[2].to_i * @foe.accuracy? * @party.get_data[0].evasion?
         @party.get_data[0].lose_hp(calculate_damage(@foe,wild_move,@party.get_data[0]))
         message_sequence << @foe.screen_name?.to_s + " used " + wild_move.to_s ; animation_sequence << ""
      else
         message_sequence << "Foe " + @foe.screen_name.to_s + "'s attack missed." ; animation_sequence << ""
      end
      @party.get_data[0].lose_pp(move,1)
      if rand(101) < $move_datadex.get(move).to_s.split(",")[2].to_i * @party.get_data[0].accuracy? * @foe.evasion?
         @foe.lose_hp(calculate_damage(@party.get_data[0],move,@foe))
         message_sequence << @party.get_data[0].screen_name?.to_s + " used " + move.to_s ; animation_sequence << ""      
     else
         message_sequence <<  @party.get_data[0].screen_name?.to_s + "'s attack missed." ; animation_sequence << ""
     end
   end
     if @party.get_data[0].fainted? and @party.active?
       @switch_flag = true
     elsif @party.get_data[0].fainted? and @party.active? == false
     elsif @party.get_data[0].fainted? == false and @foe.fainted? == true
     elsif @party.get_data[0].fainted? == true and @foe.fainted? == true
     end
     return [animation_sequence,message_sequence]
 end
  def calculate_damage(attacker,move,defendant)
     move_power = $move_datadex.get(move).to_s.split(",")[4].to_i  
     move_type = $move_datadex.get(move).to_s.split(",")[1].to_s
     type_effect == $type_datadex.get(move_type.to_s + ">>" + defendant.type1?.to_s + ":" + defendant.type2?.to_s).to_f
     if attacker.type1? == move_type or attacker.type2? == move_type
       stab = 1.5
     else
       stab = 1
     end
     return  ( ( ( ( 2 * attacker.level? / 5 + 2 ) * attacker.attack? * move_power / defendant.defense? ) / 50 ) + 2 )  * stab * type_effect * rand(85..101) / 100
  end 
end






class Effect_Processor
  def process_affect(efc,scenario,objs) ## efc : effect code , scenario : field / battle , objs : objects being affected are given in, then you get them back so you can replace your unaffected instances with the updated objects
    if ecf.to_s == "potion"
    elsif efc.to_s == "growl"
    elsif efc.to_s == ""
    end   
  end
 
end

class CPU_Trade_System
  def initialize
  end
  def trade(party,offeree)

  end
end
class Link_Trade_System
end


class Real_Time_Clock
  def time
    return Time.now.to_s.split(" ")[0..1].join(".").split(":").join(".").split("-").join(".").to_s
  end
  def light_cycle
    if self.time.split(".")[3].to_i >= 1 and self.time.split(".")[3].to_i <= 11
      return "am"
    elsif self.time.split(".")[3].to_i >= 12 and self.time.split(".")[3].to_i <= 23
      return "pm"
    end
  end 
  def day_name?
    return Time.now.strftime("%A").to_s.downcase
  end
  def month_name?
    if self.time.split(".")[1].to_i == 1
      return "january"
    elsif self.time.split(".")[1].to_i == 2
      return "february"
    elsif self.time.split(".")[1].to_i == 3
      return "march"
    elsif self.time.split(".")[1].to_i == 4
      return "april"
    elsif self.time.split(".")[1].to_i == 5
      return "may"
    elsif self.time.split(".")[1].to_i == 6
      return "june"
    elsif self.time.split(".")[1].to_i == 7
      return "july"
    elsif self.time.split(".")[1].to_i == 8
      return "august" 
    elsif self.time.split(".")[1].to_i == 9
      return "september"
    elsif self.time.split(".")[1].to_i == 10
      return "october"
    elsif self.time.split(".")[1].to_i == 11
      return "november"
    elsif self.time.split(".")[1].to_i == 12
      return "december"
    end
  end
  def season_name?
    if self.time.split(".")[1].to_i >= 2 and self.time.split(".")[1].to_i <= 5
      return "spring"
    elsif self.time.split(".")[1].to_i >= 6 and self.time.split(".")[1].to_i <= 7    
      return "summer"
    elsif self.time.split(".")[1].to_i >= 8 and self.time.split(".")[1].to_i <= 11
      return "fall"
    elsif self.time.split(".")[1].to_i >= 12 and self.time.split(".")[1].to_i <= 1
      return "winter"
    end
  end
  def is_morning?
    if self.time.split(".")[3].to_i >= 2 and self.time.split(".")[3].to_i <= 11
      return true
    else
      return false
    end
  end
  def is_afternoon?
    if self.time.split(".")[3].to_i >= 12 and self.time.split(".")[3].to_i <= 17
      return true
    else
      return false
    end
  end
  def is_evening?
     if self.time.split(".")[3].to_i >= 18 and self.time.split(".")[3].to_i <= 21
      return true
    else
      return false
    end
  end
  def is_night?
     if self.time.split(".")[3].to_i >= 22 and self.time.split(".")[3].to_i <= 1
      return true
    else
      return false
    end
  end
end




class Bag
  def initialize()
    @pockets = ["items"]
    @items = []
    @quanities = []
    @limit = [50,99]
   end
   def deposit_item(i,q)
    if @items.include?(i)
      if @quanities[@items.index(i)].to_i + q.to_i <= @limit[0].to_i
        @quanities[@items.index(i)] = @quanities[@items.index(i)].to_i + q.to_i
        true
      else
        false
      end
    else
      if @items.length < @limit[1].to_i
        if q.to_i <= @limit[0].to_i
          @items << i.to_s ; @quanities << q.to_i
          true
        else
          false
        end
      else
        false
      end
    end
  end
  def withdraw_item(i,q)
    if @items.include?(i)
      if @quanities[@items.index(i)].to_i > q.to_i
        @quanities[@items.index(i)] = @quanities[@items.index(i)].to_i - q.to_i
        true
      elsif @quanities[@items.index(i)].to_i == q.to_i
        @quanities.delete_at(@items.index(i)) ; @items.delete(i)
        true
      else
        false
      end
    else
       false
    end
  end
  def have_item?(i,q)
    if @items.include?(i) and @quanities[@items.index(i)].to_i >= q.to_i
      true
    else
     false
    end
  end
  def get_data
    return [@pockets,@items,@quanities,@limit]
  end
  def set_data(dat)
    @pockets = dat[0] ; @items = dat[1] ; @quanities = dat[2] ; @limit = dat[3]
  end
  def get_image
    q = [] ; @quanities.each { |qq| q << qq.to_s } ; l = [] ; @limit.each { |ll| l << ll.to_s }
    return numerize(@pockets.join(":") + "," + @items.join(":") + "," + q.join(":").to_s + "," + l.join(":").to_s)
  end
  def set_image(img)
    img = denumerize(img).to_s.split(",")
    @pockets = img[0].to_s.split(":")
    @items = img[1].to_s.split(":")
    @quanities = [] ; img[2].to_s.split(":").each { |q| @quanities << q.to_i }
    @limit = [] ; img[3].to_s.split(":").each { |l| @limit << l.to_i }
  end
end



class Player
  def initialize
    @name = ""
    @gender = nil
    @idno = ""
    @secret_idno = ""
    @money = 0
    @badges = 0
    @pokedex = Pokedex.new()
    @party = Party.new()
    @bag = Bag.new()
    @pokegear = Pokegear.new()
    @pokemon_storage_system = Pokemon_Storage_System.new()
    @item_storage_system = Item_Storage_System.new()
    @player_record_system = Player_Record_System.new()
    @file_dob = nil
  end
  def get_data
    return [@name,@gender,@idno,@secret_idno,@money,@badges,@pokedex.get_data,@party.get_data,@bag.get_data,@pokegear.get_data,@pokemon_storage_system.get_data,@item_storage_system.get_data,@player_record_system.get_data,@file_dob]
  end
  def set_data(dat)
     @name = dat[0].to_s ; @gender = dat[1].to_i ; @idno = dat[2].to_s ; @secret_idno = dat[3].to_s ; @money = dat[4].to_i ; @badges = dat[5].to_i ; @pokedex.set_data(dat[6]) ; @party.set_data(dat[7]) ; @bag.set_data(dat[8]) ; @pokegear.set_data(dat[9]) ; @pokemon_storage_system.set_data(dat[10]) ; @item_storage_system.set_data(dat[11]) ; @player_record_system.set_data(dat[12]) ; @file_dob = dat[13]
  end

  def get_data_for_file
    return [@name,@gender,@idno,@secret_idno,@money,@badges,@pokedex.get_data,@party.get_image,@bag.get_data,@pokegear.get_data,@pokemon_storage_system.get_image,@item_storage_system.get_data,@player_record_system.get_data,@file_dob]
  end
  def set_data_from_file(dat)
     @name = dat[0].to_s ; @gender = dat[1].to_i ; @idno = dat[2].to_s ; @secret_idno = dat[3].to_s ; @money = dat[4].to_i ; @badges = dat[5].to_i ; @pokedex.set_data(dat[6]) ; @party.set_image(dat[7]) ; @bag.set_data(dat[8]) ; @pokegear.set_data(dat[9]) ; @pokemon_storage_system.set_image(dat[10]) ; @item_storage_system.set_data(dat[11]) ; @player_record_system.set_data(dat[12]) ; @file_dob = dat[13]
  end



  def get_image
     return numerize(get_data_for_file.to_s)
  end
  def set_image(img)
     set_data_from_file(eval(denumerize(img).to_s).to_a)
  end
  def pokedex
    @pokedex
  end
  def pokegear
    @pokegear
  end
  def party
    @party
  end
  def bag
    @bag
  end
  def pokemon_storage_system
    @pokmon_storage_system
  end
  def item_storage_system
    @item_storage_system
  end
  def player_record_system
    @player_record_system
  end
end


  

 

require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/util/toast'
ruboto_import_widgets :TextView, :LinearLayout, :Button, :ListView, :EditText


class Engine_Activity
  def on_create(b)
    super
    $vdr = VDrive.new()
   
    $cpu_battle_system = nil         
    $link_battle_system = nil
    $cpu_trade_system = nil
    $link_trade_system = nil
    
    $efc = Effect_Processor.new()
    $rtc = Real_Time_Clock.new()

   
    $player = Player.new()
    
    $debug = false

    @file = false
    @screen = ""
    @previous_screen = ""
     prep_env("game")
     if $debug
       load_file ; goto("shell")
     else
       goto("title")
     end
  end
  
  def load_file
     @file = true ; $player = Player.new() ; $player.set_image($vdr.read_file("v:/player_data.dat").to_s)
     true
  end
  def save_animation
    setTitle "Saving... Do not power off or remove sdcard!" ;  set_content_view(text_view :text => "Please wait while your game is saved.") 
  end
  def save_file
    $vdr.write_file("v:/player_data.dat",$player.get_image.to_s)
  end
  def delete_file
    $vdr.delete_file("v:/player_data.dat")
    true
  end
  def check_file ## returns true if player file data exists
     $vdr.file_exist?("v:/player_data.dat").is_a? Integer
  end
  def file_info
     p = Player.new() ; p.set_data(eval(denumerize($vdr.read_file("v:/player_data.dat").to_s)).to_a)
     return [p.get_data[0],p.get_data[5],p.get_data[6][3].length]     
  end

  def restart
    $vdr = VDrive.new()
    $cpu_battle_system = nil         
    $link_battle_system = nil
    $cpu_trade_system = nil
    $link_trade_system = nil
    $efc = Effect_Processor.new()
    $rtc = Real_Time_Clock.new()   
    $player = Player.new()
    @file = false ; @previous_screen = nil ; @screen = "title" ; update_screen
  end

  def goto(scr)
     @previous_screen = @screen ; @screen = scr.to_s ; update_screen
  end

  def prep_env(env)
    if env == "game"
        scl = 10 ; $scl = scl - scl - scl ; @sc1 = $scl ; @sc2 = -1 ; $display_lines = [] ; scl.times { $display_lines << "" } ; @wrap_length = 100 
        @isc1 = 0 ; @isc2 = 9 ; @sel = 0 ; @selected_item = false ; @selected = false   #inventory
       @bag_select = false ; @bag_field = "field"
      
    elsif env == ""

    elsif env == "free stuff"
       $player.party.deposit_obj(Pokemon_Object.new("new",[2,5,"",1,false]))
       $player.party.deposit_obj(Pokemon_Object.new("new",[1,15,"bulby",1,false]))
       $player.party.deposit_obj(Pokemon_Object.new("new",[3,27,"",1,false]))
       $player.bag.deposit_item("potion",1)
       $player.bag.deposit_item("pokeball",1)
       $player.bag.deposit_item("antidote",1)
       $player.bag.deposit_item("oran berry",1)
       $player.bag.deposit_item("asshole berry",1)
       $player.bag.deposit_item("TM FU",1)
       $player.bag.deposit_item("masterbating ball",1)
       $player.bag.deposit_item("uranus",1)
       $player.bag.deposit_item("trees",1)
       $player.bag.deposit_item("dirt",1)
       $player.bag.deposit_item("blaster",1)
       $player.bag.deposit_item("nigger",1)
       $player.bag.deposit_item("gun",1)
       $player.bag.deposit_item("FAKE DICK",1)
       $player.bag.deposit_item("BOOOOBY",1)
    end
  end

  def update_screen
    if @screen.to_s == "shell" ## SHELL
      setTitle 'Welcome'
      set_content_view(linear_layout(:orientation => :vertical) do
        @display = text_view :text => $display_lines.join("\n")
        set_content_view(linear_layout(:orientation => :horizontal) do
           text_view :text => "<:"
           @input_bar = edit_text
           button :text => "E", :on_click_listener => (proc{forward_input}) , :height => 60 , :width => 40
        end) 
    end)
   
   elsif @screen.to_s == "pokedex"

      setTitle 'Pokedex'
      set_content_view(linear_layout(:orientation => :vertical) do
           button :text => "^", :on_click_listener => (proc{ }) , :width => 200 , :height => 40
           @pkd_display = text_view :text => ""
           button :text => "v", :on_click_listener => (proc{ }) , :width => 200 , :height => 40
           linear_layout(:orientation => :horizontal) do
               button :text => "View", :on_click_listener => (proc{ }) , :width => 80 , :height => 47 , :y => -10
               button :text => " Cancel ", :on_click_listener => (proc{ goto(@previous_screen) ; pshell("") }), :height => 47 , :width => 100 , :y => -10
           end
       end) 


   elsif @screen.to_s == "pokegear"

      setTitle 'Pokegear'
      set_content_view(linear_layout(:orientation => :vertical) do
        text_view :text => ""
        button :text => " Cancel ", :on_click_listener => (proc{ goto(@previous_screen) ; pshell("") }), :height => 47 , :width => 100 , :y => -10
      end)


  elsif @screen.to_s == "inventory" ## INVENTORY
      setTitle 'Bag'
      set_content_view(linear_layout(:orientation => :vertical) do
          linear_layout(:orientation => :horizontal) do
             linear_layout(:orientation => :vertical) do
                  button :text => "^", :on_click_listener => (proc{ inv_scrollar_up } ) , :width => 200 , :height => 40
                  @inv_display = text_view :text => ""
                  button :text => "v", :on_click_listener => (proc{ inv_scrollar_down } ) , :width => 200 , :height => 40
            end            
              linear_layout(:orientation => :horizontal) do
                  @item_description_label = text_view :text => ""
                  ##if useable
                    ## determine use secuence i.e on party / on foe(pokeball) / field event
                   use_condition = $item_datadex.get(@selected_item)[7].to_s
                   if use_condition.to_s == "dual"
                      can_use = true
                   else
                      if use_condition.to_s == @bag_field.to_s
                         can_use = true                        
                      else
                        can_use = false
                      end
                   end
                  if can_use
                     button :text => "Use", :on_click_listener => (proc{ 

  scenario = $item_datadex.get(@selected_item)[8].to_s
  if scenario.to_s == "party_select"
    ## run party select then use item on selected pokemon unless cancele was selected,then update inventory display, and then screen
  elsif scenario.to_s == "wild_balluse"
  elsif scenario.to_s == "throw_item" ## might be trainer or the throwing item move or bait/rock in safari battle

  elsif scenario.to_s == "event" ## here we can load extra script from item data and execute it

  end

} ) , :width => 80 , :height => 47 
                  end
                  if ["items","pokeballs","tmshms","berries"].include?($item_datadex.get(@selected_item)[8].to_s)   
                     button :text => "Give", :on_click_listener => (proc{ } ) , :width => 80, :height => 47
                     button :text => "Toss", :on_click_listener => (proc{ } ) , :width => 80 , :height => 47
                 end
              end
          end
             button :text => " Cancel ", :on_click_listener => (proc{ goto(@previous_screen) ; pshell("") }), :height => 47 , :width => 100 , :y => -10

       end)
       update_inventory_display
   elsif @screen.to_s == "player"
     setTitle $player.instance_variable_get("@name").to_s + ";s Trainer Card"
     set_content_view(linear_layout(:orientation => :vertical) do
             text_view :text => "Player Name:            " + $player.get_data[0].to_s
             text_view :text => "Id No.                         " + $player.get_data[2].to_s
             text_view :text => "Pokedex Caught:     " + $player.get_data[6][3].length.to_s
             text_view :text => "Pokedex Seen:         " + $player.get_data[6][2].length.to_s

             text_view :text => "Money:                      " + $player.get_data[4].to_s
             button :text => "Back", :on_click_listener => (proc{ goto(@previous_screen) ; pshell("") }) , :height => 47 , :width => 80
     end)

   elsif @screen.to_s == "load file" ## LOAD FILE
          if check_file
            setTitle "Load Game"
          else
            setTitle "Start a new game"
          end
          set_content_view(linear_layout(:orientation => :vertical) do
             if check_file 
                 text_view :text => "Player: " + file_info[0].to_s + "\nPokedex: "  + file_info[2].to_s + "\nBadges: " + file_info[1].to_s
                 button :text => "Continue" , :on_click_listener => proc{ load_file ; goto(@previous_screen) ; pshell(":> Welcome back to the game.") } , :height => 47 , :width => 120
             end
             button :text => "New Game " , :on_click_listener => proc{ $player = Player.new ; $player.instance_variable_set("@file_dob",Time.now.to_s) ; @screen = "intro" ; update_screen } , :height => 47 , :width => 130 , :y => -10
           end)        

   elsif @screen.to_s == "party"
           setTitle "Party"
           @party_select = nil
           set_content_view(linear_layout(:orientation => :vertical) do
              if $player.party.get_data[0] != "empty"
                 button :text => $player.party.get_data[0].screen_name? + ", Lv. " + $player.party.get_data[0].level?.to_s , :on_click_listener => proc{  @party_select = 0 ; @screen = "party summary" ; update_screen } , :height => 47
              else
                 button :text => " - - - - - " , :height => 47
              end
              if $player.party.get_data[1] != "empty"
                 button :text => $player.party.get_data[1].screen_name? + ", Lv. " + $player.party.get_data[1].level?.to_s , :on_click_listener => proc{  @party_select = 1 ; @screen ="party summary" ; update_screen } , :height => 47 , :y => -10
              else
                 button :text => " - - - - - " , :height => 47 , :y => -10
              end
              if $player.party.get_data[2] != "empty"
                 button :text => $player.party.get_data[2].screen_name? + ", Lv. " + $player.party.get_data[2].level?.to_s , :on_click_listener => proc{  @party_select = 2 ; @screen = "party summary" ; update_screen }  , :height => 47 , :y => -20
              else
                 button :text => " - - - - - " , :height => 47 , :y => -20
              end
              if $player.party.get_data[3] != "empty"
                 button :text => $player.party.get_data[3].screen_name? + ", Lv. " + $player.party.get_data[3].level?.to_s , :on_click_listener => proc{  @party_select = 3 ; @screen = "party summary" ; update_screen } , :height => 47 , :y => -30
              else
                 button :text => " - - - - - " , :height => 47 , :y => -30
              end
              if $player.party.get_data[4] != "empty"
                 button :text => $player.party.get_data[4].screen_name? + ", Lv. " + $player.party.get_data[4].level?.to_s , :on_click_listener => proc{  @party_select = 4 ; @screen = "party summary" ; update_screen } , :height => 47 , :y => -40
              else
                 button :text => " - - - - - " , :height => 47 , :y => -40
              end
              if $player.party.get_data[5] != "empty"
                 button :text => $player.party.get_data[5].screen_name? + ", Lv. " + $player.party.get_data[5].level?.to_s , :on_click_listener => proc{  @party_select = 5 ; @screen = "party summary" ; update_screen } , :height => 47 , :y => -50
              else
                 button :text => " - - - - - " , :height => 47 , :y => -50
              end 
              button :text => "Cancel" , :on_click_listener => proc{ goto(@previous_screen) ; pshell("") } , :height => 47 , :y => -60
           end)
   elsif @screen.to_s == "party summary"    
     setTitle $player.party.get_data[@party_select.to_i].screen_name?.to_s +  "'s Summary"
     set_content_view(linear_layout(:orientation => :vertical) do
        linear_layout(:orientation => :horizontal) do
            button :text => " Back " , :on_click_listener => proc{  @screen = "party" ; update_screen }  , :height => 47 , :width => 80
            text_view :text => "Oooo" 
            button :text => " > " , :on_click_listener => proc{  @screen = "party summary 2" ; update_screen }  , :height => 47 , :width => 50
        end        
        if $player.party.get_data[@party_select].nickname?.to_s == "false" 
            n = $player.party.get_data[@party_select].species_name?.to_s
        else
           n = $player.party.get_data[@party_select].screen_name?.to_s + " / " + $player.party.get_data[0].species_name?.to_s
        end
        text_view :text => "Name: " +  n.to_s
        text_view :text => "Dexno. " + $player.party.get_data[@party_select].dexno?.to_s
        text_view :text => "Level: " + $player.party.get_data[@party_select].level?.to_s
        text_view :text => "  " 
        text_view :text => "Hp: " + $player.party.get_data[@party_select].cur_hp?.to_s + "/" + $player.party.get_data[@party_select].max_hp?.to_s 
        s = $player.party.get_data[@party_select].status? ; if s.to_s == "false" ; s = "none" ; end
        text_view :text => "Status: " + s.to_s

        text_view :text => "IDno.   "  + $player.party.get_data[@party_select].idno?.to_s
        text_view :text => "OT:       " + $player.party.get_data[@party_select].ot?.to_s
     end)

   elsif @screen.to_s == "party summary 2"
     setTitle $player.party.get_data[@party_select].screen_name?.to_s +  "'s Stats"
     set_content_view(linear_layout(:orientation => :vertical) do
        linear_layout(:orientation => :horizontal) do
            button :text => " Back " , :on_click_listener => proc{  @screen = "party" ; update_screen }  , :height => 47 , :width => 80
            button :text => " < " , :on_click_listener => proc{  @screen = "party summary" ; update_screen }   , :height => 47 , :width => 50
            text_view :text => "oOoo" 
            button :text => " > " , :on_click_listener => proc{  @screen = "party summary 3" ; update_screen }  , :height => 47 , :width => 50
        end        

        text_view :text => "Level:                        " + $player.party.get_data[@party_select].level?.to_s
        text_view :text => "Hp:                            " + $player.party.get_data[@party_select].cur_hp?.to_s + "/" + $player.party.get_data[@party_select].max_hp?.to_s  ; s = $player.party.get_data[@party_select].status? ; if s == false ; s = "none" ; end
        text_view :text => "Attack:                     " + $player.party.get_data[@party_select].attack?.to_s
        text_view :text => "Defense:                  "  + $player.party.get_data[@party_select].defense?.to_s
        text_view :text => "Special Attack:       " + $player.party.get_data[@party_select].special_attack?.to_s
        text_view :text => "Special Defense:    "  + $player.party.get_data[@party_select].special_defense?.to_s
        text_view :text => "Speed:                      "  + $player.party.get_data[@party_select].speed?.to_s
        text_view :text => "Exp Total:                " + ""
        text_view :text => "Exp to next lv:         " + ""
     end)


   elsif @screen.to_s == "party summary 3"
     setTitle $player.party.get_data[@party_select].screen_name?.to_s + "'s Moveset"
       set_content_view(linear_layout(:orientation => :vertical) do
        linear_layout(:orientation => :horizontal) do
            button :text => " Back " , :on_click_listener => proc{  @screen = "party" ; update_screen }  , :height => 47 , :width => 80
            button :text => " < " , :on_click_listener => proc{  @screen = "party summary 2" ; update_screen }   , :height => 47 , :width => 50
            text_view :text => "ooOo" 
            button :text => " > " , :on_click_listener => proc{  @screen = "party summary 4" ; update_screen }   , :height => 47 , :width => 50
        end        
        ms = $player.party.get_data[@party_select].move_set?
        if ms[0].to_s != ""
           text_view :text => ms[0].to_s
        else
          text_view :text => " --- "
        end
        if ms[1].to_s != ""
           text_view :text => ms[0].to_s
        else
          text_view :text => " --- "
        end
        if ms[2].to_s != ""
           text_view :text => ms[0].to_s
        else
          text_view :text => " --- "
        end
        if ms[3].to_s != ""
           text_view :text => ms[0].to_s
        else
          text_view :text => " --- "
        end
       end)
  elsif @screen.to_s == "party summary 4"     
     setTitle $player.party.get_data[@party_select].screen_name?.to_s + "'s Condition"
     set_content_view(linear_layout(:orientation => :vertical) do
        linear_layout(:orientation => :horizontal) do
            button :text => " Back " , :on_click_listener => proc{  @screen = "party" ; update_screen }  , :height => 47 , :width => 80
            button :text => " < " , :on_click_listener => proc{  @screen = "party summary 3" ; update_screen }   , :height => 47 , :width => 50
            text_view :text => "oooO" 
        end        

        text_view :text => "  nothing here yet" 
      end)

   elsif @screen.to_s == "party choose pokemon"

   elsif @screen.to_s == "intro"
     setTitle "Welcome to pokemon IRB."
     set_content_view(linear_layout(:orientation => :vertical) do
       text_view :text => "You should know enough about pokemon game mechanics before"
       text_view :text => "trying to use this program. If not it is highly suggested you defeat the"
       text_view :text => "elite-4 in at least one generation of the series of games."
       text_view :text => "You can find emulators to run your legally ripped roms using any"
       text_view :text => "search engine."
       text_view :text => "\nA few things to clear up here, mainly there is no over world, its too time"
       text_view :text => "consumming to include and format map. So mostly what you are getting"
       text_view :text => "Here is a 2nd gen UI with 4th gen pokemon objects and a 5th gen battle"
       text_view :text => "\n You can use a shell to control the game, or just stick to the button menu UI"
       text_view :text => "Other than the lack of a map the mechanich in this game mimmic that of a typical"
       text_view :text => "hendheld pokemon game."
       text_view :text => "\n For more info read the tutorials included with the games source code."
       button :text => " Got it! " , :on_click_listener => proc{  @screen = "intro profile" ; update_screen }   , :height => 47 , :width => 80
     end)     
   elsif @screen.to_s == "intro profile"
    if @gend_sel == nil ; @gend_sel = "" ; end ; if @name_ent == nil ; @name_ent = "" ; end
     setTitle "The World of Pokemon!"
     set_content_view(linear_layout(:orientation => :vertical) do
       text_view :text => "So no dopey talking about pokemon being our friends and playing together."
       text_view :text => "because you're here for some hard core pokemon playing, or programming, or both."
       if @gend_sel.to_s == ""
            button :text => " Boy " , :on_click_listener => proc{  @gend_sel = "boy" ; @name_ent = @name_bar.get_text.to_s ; update_screen }   , :height => 47 , :width => 75
            button :text => " Girl " , :on_click_listener => proc{  @gend_sel = "girl" ; @name_ent = @name_bar.get_text.to_s ; update_screen }   , :height => 47 , :width => 75
       elsif @gend_sel.to_s == "boy"
               button :text => " Boy " , :on_click_listener => proc{  @gend_sel = "girl" ; @name_ent = @name_bar.get_text.to_s ; update_screen }   , :height => 47 , :width => 75
       elsif @gend_sel.to_s == "girl"
            button :text => " Girl " , :on_click_listener => proc{  @gend_sel = "boy" ; @name_ent = @name_bar.get_text.to_s ; update_screen }   , :height => 47 , :width => 75
       end
       linear_layout(:orientation => :horizontal) do
          text_view :text => "Your Name: "
          @name_bar = edit_text :text => @name_ent.to_s
       end
          button :text => " Continue " , :on_click_listener => proc{  @screen = "intro sendoff" ; @name_ent = @name_bar.get_text.to_s ; dat = $player.get_data ; dat[0] = @name_ent.to_s ; if @gend_sel == "boy" ; dat[1] = 1 ; elsif @gend_sel == "girl" ; dat[1] = 0 ; end ; id = "" ; 8.times { id << rand(1..9).to_s } ; dat[2] = id.to_s ; $player.set_data(dat) ; update_screen }   , :height => 47 , :width => 120
     end)
   elsif @screen.to_s == "intro sendoff"   
            setTitle "Almost done..."
            set_content_view(linear_layout(:orientation => :vertical) do
                 text_view :text => "Ok that's pretty much it."
                 text_view :text => "Press start game and get playing."
                 button :text => " Start Game " , :on_click_listener => proc{ @previous_screen = "title" ; @screen = "menu" ; pshell("Welcome to a new game.") ; update_screen } , :height => 47 , :width => 50   
             end)
   elsif @screen.to_s == "save file"
            setTitle "Save your game?"
           if file_check and file_info[0].to_s != $player.instance_variable_get("@name").to_s
             setTitle "!WARNGIN! There is another saved file !WARNING!"
             set_content_view(linear_layout(:orientation => :vertical) do
                text_view :text => "Existing_File: " + file_info.join(" ").to_s
                text_view :text => "The existing file contains that of another trainer.\nIf you save now, you will lose all your progress in the other file.\nAre you sure you want to save?" 
                button :text => "Cancel" , :on_click_listener => proc{ goto(@previous_screen) ; pshell(":> " + $player.instance_variable_get("@name").to_s + " canceled saving over another trainers file.") } , :height => 47 , :y => -10
                button :text => "Save" , :on_click_listener => proc{ save_animation ; save_file ; goto(@previous_screen) ; pshell(":> " + $player.instance_variable_get("@name").to_s + " saved new game on an old trainers file.") } , :height => 47 , :y => -10
              end)
           else file_check
            set_content_view(linear_layout(:orientation => :vertical) do
                text_view :text => "Player:        " + $player.get_data[0].to_s
                text_view :text => "Pokedex:   " + $player.get_data[6][3].length.to_s
                text_view :text => "Badges:     " + $player.get_data[5].to_s
                text_view :text => "Money:       " + $player.get_data[4].to_s
                button :text => "Cancel" , :on_click_listener => (proc{ goto(@previous_screen) ; pshell(":> " + $player.instance_variable_get("@name").to_s + " canceled saving the game.") }) , :height => 47 , :width => 120 , :y => -10
                button :text => "Save" , :on_click_listener => (proc{ save_animation ; save_file ; goto(@previous_screen) ; pshell(":> " + $player.instancce_variable_get("@name").to_s + " saved the game." ) }) , :height => 47 , :width => 120 , :y => -20
            end)
           end

   elsif @screen.to_s == "menu"
     setTitle "Menu"
     set_content_view(linear_layout(:orientation => :vertical) do
           button :text => "Pokedex", :on_click_listener => ( proc{ goto("pokedex") }) , :height => 47     
           button :text => "Party", :on_click_listener => ( proc{ goto("party") }) , :height => 47 , :y => -10
           button :text => "Bag", :on_click_listener => ( proc{ goto("inventory") }) , :height => 47 , :y => -20
           button :text => "Pokegear", :on_click_listener => ( proc{ goto("pokegear") }) , :height => 47 , :y => -30
           button :text => $player.instance_variable_get("@name").to_s , :on_click_listener => (proc{ goto("player") }) , :height => 47 , :y => -40
           button :text => "Save", :on_click_listener => (proc{ goto("save file") })     , :height => 47 , :y => -50
           button :text => "Options", :on_click_listener => (proc{ goto("options") })     , :height => 47 , :y => -60
           button :text => "Shell", :on_click_listener => (proc{ goto("shell") ; pshell("") })   , :height => 47 , :y => -70
     end)

   elsif @screen.to_s == "title"
     setTitle "Doubinux Presents...."
     set_content_view(linear_layout(:orientation => :vertical) do
       text_view :text => "No Affiliation with Game Freak/Nintendo\n\n\n\n\n\n\n\n\                                                                                   Pokemon IRB                                                 \n\n\n\n\n"
        linear_layout(:orientation => :horizontal) do
          text_view :text => "Powered by Ruby, (c) 2017                            Press "
          button :text => "Enter", :on_click_listener => proc{ @previous_screen = "menu" ; @screen = "load file" ; update_screen } , :height => 47 , :width => 100
        end
        text_view :text => "Powered by JRuby, Ruboto, Android, AMD        DBX (c) Spring 2017"
     end)    
   elsif @screen.to_s == "options"
     setTitle "Game Options"
      set_content_view(linear_layout(:orientation => :vertical) do
        linear_layout(:orientation => :horizontal) do
           if $debug
               button :text => " Turn Debug Mode Off ", :on_click_listener => proc{ $debug = false ; update_screen } , :height => 47
               text_view :text => "          Exit debug mode."
           else
               button :text => " Turn Debug Mode On ", :on_click_listener => proc{ $debug = true ; update_screen } , :height => 47
               text_view :text => "          For debugging and game hacking."
           end
        end
        linear_layout(:orientation => :horizontal) do
           button :text => " Quit Game ", :on_click_listener => proc{ @screen = "options quit game confirm" ; update_screen } , :height => 47 , :y => -10
           text_view :text => "          Return to title screen." , :y => -10
        end
         button :text => " Back ", :on_click_listener => proc{ goto(@previous_screen) ; pshell("") } , :height => 47 , :y => -20
       end)
   elsif @screen == "options quit game confirm"
     setTitle "Quit Game?"
      set_content_view(linear_layout(:orientation => :vertical) do
        text_view :text => "Are you sure you want to quit the game?"
        linear_layout(:orientation => :horizontal) do
           button :text => "     Cancel    ", :on_click_listener => proc{ @screen = "options" ; update_screen } , :height => 47
           button :text => " Quit Game ", :on_click_listener => proc{ $player = Player.new() ; goto("title") ; pshell('') } , :height => 47 , :x => -10
        end 
      end)
   end
  end













  def inv_scrollar_up
    if @sel > 0
      @sel -= 1
      update_inventory_display
   else ## try to scroll up
      if @isc1 > 1
         @isc1 -= 1 ; @isc2 -= 1
         update_inventory_display
      end
   end
  end
  def inv_scrollar_down
    if @sel.to_i < 9
      @sel += 1
      update_inventory_display
    else ## try to scroll down
       if @isc2.to_i < $player.bag.get_data[1].length.to_i - 1
         @isc1 += 1 ; @isc2 += 1
        update_inventory_display
       end
    end
  end

  def update_inventory_display
     if $player.bag.get_data[1].length.to_i > 0
       items = $player.bag.get_data[1].to_a ; itemsq = $player.bag.get_data[2].to_a    
       @selected_item = items[@isc1..@isc2][@sel].to_s
       list = [] ; c = 0
       itemsq.each do |i|
         list << i.to_s + " x " + items[c].to_s
          c+=1
       end
        view = [] ; c = 0
        list[@isc1..@isc2].each do |l|
          if c.to_i == @sel.to_i
            view << "> " + l.to_s
          else
            view << "  " + l.to_s
          end
          c += 1
        end
        descrip = $item_datadex.get(@selected_item) ; if descrip == nil ; descrip = "" ; else descrip = descrip[6].to_s ; end
       @inv_display.set_text(view.join("\n").to_s) 
       @item_description_label.set_text(descrip.to_s)
    else
       @inv_display.set_text("You have no items.")
   end
  end


  

  def pshell(inp)
    ll = [] ; inp.to_s.split("\n").each { |l| ll << l.to_s }
    nl = []
    ll.each do |l|
       if l.to_s.length > @wrap_length.to_i
          c = 0 ; line = ""
          l.split('').each do |ch|          
             if c < @wrap_length.to_i - 1
               line << ch.to_s ; c += 1
             else
               nl << line.to_s + ch.to_s ; line = "" ; c = 0
             end
          end
       else
          nl << l.to_s
       end
    end
     nl.each { |l| $display_lines << l.to_s }
     update_display
  end
  def update_display
    @display.set_text($display_lines[@sc1..@sc2].join("\n").to_s)    
  end
  def set_display_lines(lines) # INTEGER
       $scl = lines.to_i - lines.to_i - lines.to_i ; @sc1 = $scl ; update_display
  end
  def set_display_width(length)
    @wrap_length = length.to_i
  end
  def scroll_top
     l = $display_lines.length.to_i ; l = l - l - l
    @sc1 = l.to_i ; @sc2 = @sc1 - $scl - 2
     update_display
  end
  def scroll_up
    cpv = $display_lines.length - $display_lines.length - $display_lines.length
    if @sc1.to_i > cpv.to_i
      @sc1 -= 1 ; @sc2 -= 1
      update_display
    else
      ## cant scroll any more
    end
  end
  def scroll_bottom
    @sc1 = $scl ; @sc2 = -1 ; update_display
  end
  def scroll_down
    if @sc2.to_i < -1
      @sc1 += 1 ; @sc2 += 1
      update_display
    else
      ## cant scroll any more
    end
  end
  def forward_input
   cmd = @input_bar.get_text.to_s 
   if cmd[0].to_s == "*"
      cmd = cmd[1..-1].to_s
   else 
      @input_bar.set_text("")
   end
  if cmd.to_s == "[u"
    res = nil ; scroll_up 
  elsif cmd.to_s == "[d"
    res = nil ; scroll_down
  elsif cmd.to_s == "[h"
     res = nil ; scroll_top
  elsif cmd.to_s == "[e"
    res = nil ; scroll_bottom
  else
     pshell("<: " + cmd.to_s)
     res = self.general_request(cmd.to_s)
   end
   if res == nil
     pshell("") # for some reason this keeps the consol display from accumulating  a '\n' everytime you redraw its gui with out initializing its env vars
   else     
     pshell(":> " + res.to_s )
   end
  end

  def general_request(cmd)
     if cmd.to_s == "pokedex"
        goto("pokedex")
     elsif cmd.to_s == "party"
        goto("party")
     elsif cmd.to_s == "pokegear"
        goto("pokegear")
     elsif cmd.to_s == "inventory" or cmd.to_s == "bag"
      goto("inventory")
    elsif cmd.to_s == "player" or cmd.to_s.downcase == $player.instance_variable_get("@name").to_s.downcase
      goto("player")
     elsif cmd.to_s == "save"
      goto("save file")
    elsif cmd.to_s == "options"
      goto("options")
    elsif cmd.to_s == "menu"
      goto("menu")
    elsif cmd.to_s == ""
    elsif cmd.to_s == ""
    elsif cmd.to_s == ""
    else
       if $debug
          begin ; eval(cmd.to_s) ; rescue ; "Ruby Failed" ; end
       else
          "Invalid Input"
       end
    end
  end
end

 $irb.start_ruboto_activity :class_name => "Engine_Activity"
