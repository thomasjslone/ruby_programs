# webcrawler 1.1  created 2021.05.04 last updated 2021.05.05 j.thomas
# starts with a basepage and grabs links as it finds them in each page while noting instances of search term appearences in pages and links
# min ruby: 0.0.0
require 'uri';require 'open-uri'
class Web_Crawler
  def initialize
	@case_sensitivity=false ## weather capitolization is ignored when looking for search term
    @counter=0 ##number of loops executed\pages crawled
	@invalid_counter=0 ## number of invalid pages checked
    @already_searched=[] ## links to not crawl again
	@search_term=''
	@search_que=[] ## a list of links to crawl
	@matching_pages=[] ## a list of pages that matched the search term
	@matching_links=[] ## links that directly contain the search term
	@base_page='' ##starting page

  end
  
  def start_crawling(base_page,term)
    if @case_sensitivity==false;@search_term=term.to_s.downcase;else;@search_term=term.to_s;end
	@search_que=[base_page]
	unless @crawling ; crawl_loop ; end
  end
  
  def stop_crawling
    @crawling=false
  end
  
  def save_crawl
    dat=[@counter.to_s,@invalid_counter.to_s,@case_sensitivity.to_s,@already_searched.to_s,@search_que.to_s,@matching_pages.to_s,@matching_links.to_s,@search_term.to_s].to_s    
    f=File.open(Dir.getwd+"/crawl.dat","w");f.write(dat);f.close
	puts "Saved this point in the crawl to file."
  end
  def resume_saved_crawl ## to resume a crawl right after calling stop just call the crawl_loop again
    if File.exist?(Dir.getwd+"/crawl.dat")
	  f=File.open(Dir.getwd+"/crawl.dat","r");dat=f.read.to_s;f.close
	  dat=eval(dat)
	  @counter=dat[0].to_i ; @invalid_counter=dat[1].to_i ; if dat[2]=="true";@case_sensitivity=true;else;@case_sensitivity=false;end
	  @already_searched=eval(dat[3].to_s)
	  @search_que=eval(dat[4].to_s)
	  @matching_pages = eval(dat[5].to_s)
	  @matching_links = eval(dat[6].to_s)
	  if @case_sensitivity==false;@search_term = dat[7].to_s.downcase;else;@search_term=dat[7].to_s;end
	  puts "Preparing to resume crawl..."
	  crawl_loop
	else;return []
	end	
  end
  
  def crawl_loop ## base_page=String 'http://url.page.com',term=String 'gold prices in germany' 
    @crawling=true ## a variable to keep the loop running	  
	while @crawling
	
      #sleep 1 # can be used to prevent annoyance to servers being crawled
	  @counter=@counter+1 ## counts pages checked
	  
	  ## set next page to check                                ## STEERING GOES HERE kinda 
	  current=@search_que[0];@search_que.delete_at(0)

	  ## print info to consol
	  puts "Searching: " + current.to_s
	  puts @counter.to_s+"/"+@search_que.length.to_s
	  
	  ## get page contents
	  p=get_page(current)
	  
	  ## check page
	  if p == '' ;@invalid_counter+=1; puts "Invalid link checked.("+@invalid_counter.to_s+")" ## if invalid skip
	  else ## if valid page check for search term and save page if found
        ## write page address to file	   
		begin;f=File.open(Dir.getwd+"/dat/a_traveled_links.txt","a");f.write(current.to_s+"\n");f.close;rescue;;end
		## extract links from page
		l=get_links(p)
        ## filter out links that do not have an http/https header
		nl=[];l.each do |i| ; begin;if i.to_s[0..3].downcase=="http";nl<<i;end;rescue;;end;end;l=nl
	    ## if links are found add them to the search que if they havent been checked before
		if l.length>0;puts "Found "+l.length.to_s+" links on this page."  ## print found links to screen   

		  ## filter links searched before
		  nl=[];l.each {|i| if @already_searched.include?(i)==false;nl<<i.to_s;end};l=nl 
		  ## write links to file
		  begin;f=File.open(Dir.getwd+"/dat/a_found_links.txt","a");f.write(l.join("\n")+"\n");f.close;rescue;;end
		  ## check links for search term and add them to the beginning of the que if they match and the end if they dont	      
		  begin;if @case_sensitivity==false;nl=l.to_s;else;nl=l.to_s.downcase;end;rescue;nl=l.to_s;end;nl=eval(nl.to_s)
          nl.each do |i|
		    if i.include?(@search_term)
			  begin;f=File.open(Dir.getwd+"/dat/a_matching_links.txt","w");f.write(i.to_s);f.close;rescue;;end
			  @search_que.insert(0,i)
			else
			  @search_que<<i
			end
		  end
		  
		else;puts "No links found on this page." ## print found links to screen
		end
	  end ## end of link check
	  ## begin search term check
	  
	  begin;if @case_sensitivity==false;cp=p.downcase;else;cp=c;end;rescue;cp=p.to_s;end ## handle case sensetivity setting
	  if cp.include?(@search_term) ## the term was found
	    puts "PAGE MATCH:" + @matching_pages.length.to_s + ": "+current.to_s ## print match alert to consol
	    @matching_pages<<p ##add page to list of matches
		unless File.exist?(Dir.getwd+"/dat/"+current.to_s.gsub(/[^a-zA-Z0-9]/,"_")+".txt")
		begin
   		  f=File.open(Dir.getwd+"/dat/"+current.to_s.gsub(/[^a-zA-Z0-9]/,"_")+".txt","w");f.write("url: "+current.to_s+p.to_s);f.close ## save entire page to file
        rescue;;end
		end		
	  end ## end of page check
	  ## list this link so we wont search it again
      @already_searched<<current.to_s
	
 	  ## if out of links to crawk stop(the search que so far has never reached zero)
	  ##if @search_que.length==0;@crawling=false;puts "SEARCH CONCLUDED";end
	  save_crawl
	end ## end of crawl loop
	
  end ## end of crawl method
  
  def get_page(url)  ## get page source code from link
    begin;page=URI.open(url);cont=page.read.to_s;page.close;page=cont;return page.to_s;rescue;puts "A page load resulted in an exception.";end
  end
  
  def get_links(str) ## use rubys URI class to extract links, returns an array
    begin;return URI.extract(str.to_s);rescue;return [];end ## rescue the code incase of illegal characters
  end
  
end
$w=Web_Crawler.new ##so you wont have to type it every time
