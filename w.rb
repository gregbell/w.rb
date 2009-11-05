%w{rubygems sinatra rdiscount}.each{|l| require(l)};F=File;L="c";def C(f);"#{L}/#{f}";end; `mkdir #{L} && cd #{L} && git init`
get(%r{\/([^/]*)\/versions\/?}){|t| @t = t; @v=`cd #{L} && git log --format=format:"%ai | %aN | %H" #{t}`; erb(:v)}
get('/'){redirect('/HomePage')}; get(%r{\/([^/]*)\/?(edit)?}){|u,e|@t=u;@c=F.read(C(u)) rescue ''
(@c == '' || e) ? @t="Edit: #{@t}" && erb(:e) : (@vc=`cd #{L} && git log --pretty=oneline #{u} | wc -l`) && erb(:p)}
post(%r{\/([^/]*)\/?}){|t|F.open(C(t),'w+'){|f|f.write(params[:c])};`cd #{L} && git add . && git commit -m 'Updated #{t}'`;redirect("/#{t}")}
__END__
@@layout
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN""http://www.w3.org/TR/html4/strict.dtd">
<html><head><title><%= @t %></title><style type="text/css" media="screen">body{font:14px/19px sans-serif;color:#333;}
a{color:#000;}a:hover{text-decoration:none;}</style></head><body><div id="wrapper"><%= yield %></div></body></html>
@@p
<h1><%= @t %></h1><div><%= Markdown.new(@c.gsub(/([A-Z]\w+){2}/){|m| "<a href='/#{m}'>#{m}</a>"}).to_html %></div>
<div><a href='/<%= @t %>/edit'>Edit</a> | <a href="/<%= @t %>/versions">Version <%= @vc %></a></div>
@@e
<h1><%= @t %></h1><form method="post"><textarea name="c" cols="100" rows="15"><%= @c %></textarea>
<br/><input type="submit" label="Save" /> or <a href="/<%= @t %>">Cancel</a></form>
@@v
<h1><%= @t %>: Versions</h1>
<div><a href='/<%= @t %>'>&lt; Back</a></div><pre><%= @v.gsub(">", "&gt;").gsub("<", "&lt;") %></pre>