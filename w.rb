%w{rubygems sinatra rdiscount}.each{|l| require(l)};L="c";def C(f);"#{L}/#{f}";end; `mkdir #{L}`
get('/'){redirect '/HomePage'}; get(%r{\/([^/]*)\/?(edit)?}){|u, e| @t = u; @c = File.read(C(u)) rescue ''
(@c == '' || e) ? @t = "Edit: #{@t}" && erb(:e) : erb(:p) }
post(%r{\/([^/]*)\/?}){|t| File.open(C(t),'w+') {|f| f.write params[:c] }; redirect("/#{t}") }
__END__
@@layout
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN""http://www.w3.org/TR/html4/strict.dtd">
<html><head><title><%= @t %></title><style type="text/css" media="screen">body{font:14px/19px sans-serif;}
</style></head><body><div id="wrapper"><%= yield %></div></body></html>
@@p
<h1><%= @t %></h1><div><%= Markdown.new(@c.gsub(/([A-Z]\w+){2}/){|m| "<a href='/#{m}'>#{m}</a>"}).to_html %></div>
<div><a href='/<%= @t %>/edit'>Edit</a></div>
@@e
<h1><%= @t %></h1><form method="post"><textarea name="c" cols="100" rows="15"><%= @c %></textarea>
<br/><input type="submit" label="Save" /> or <a href="/<%= @t %>">Cancel</a></form>