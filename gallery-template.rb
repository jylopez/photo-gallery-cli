require 'erb'
require 'fileutils'
require 'optparse'
require 'pry'

options = {}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: gallery-template.rb --file file_output.html"

	options[:file] = false
	opts.on( '-f', '--file', 'Name the html file.') do
		options[:file] = true
	end

	options[:directory] = false
	opts.on( '-d', '--d', 'Name the directory.') do
		options[:directory] = true
	end

	options[:multi] = false
	opts.on( '-m', '--m', 'Make multiple pages with detail.') do
		options[:multi] = true
	end

end

optparse.parse!




def get_template(img_tag_vect, atags = false)
	%{
	<!DOCTYPE html>
	<html>
	<head>
		<title> My Gallery </title>
	</head>
	<body>
		<h1>My Gallery</h1>
		<% (0..(img_tag_vect.length-1)).each do |q| %>
			<% if atags %>
				<a href="<%= img_tag_vect[q] %>"><%= img_tag_vect[q] %></a>
			<% else %>
    		<%= img_tag_vect[q] %>
    	<% end %>
    <% end %>
	</body>
	</html>
	}
end

def get_template_detail(img_path)
	%{
	<!DOCTYPE html>
	<html>
	<head>
		<title> <%= #{img_path} %> </title>
	</head>
	<body>
		<h1><%= #{img_path} %></h1>
			<img src="<%= #{img_path} %>">
	</body>
	</html>
	}
end

if options[:directory]
	directory_name = ARGV[1]
else
	directory_name = "public"
end

if not Dir.exists?("./"+directory_name)
	Dir.mkdir(directory_name)
	Dir.mkdir(directory_name+"/imgs")
	FileUtils.cp_r Dir.pwd+"/photos/.", directory_name+"/imgs/"
end

imgs_vect=Dir.glob(directory_name+"/imgs/*.jpg")
img_tag_vect = Array.new(imgs_vect.length)

(0..(imgs_vect.length-1)).each do |q|
	img_tag_vect[q] = "<img src=\"#{"."+(imgs_vect[q])[6..-1]}\">"
end

if not options[:multi]

	if options[:file]
		html_file = "./"+directory_name+"/"+ARGV[0]
	else
		html_file= "./"+directory_name+"/gallery.html"
	end

	puts "Writing html file: "+ html_file

	renderer = ERB.new(get_template(img_tag_vect))
	# binding.pry
	File.open(html_file, 'w') do |f|
		f.write(renderer.result())
	end

else
	if options[:file]
		html_file = "./"+directory_name+"/"+ARGV[0]
	else
		html_file= "./"+directory_name+"/index.html"
	end

	puts "Writing html file: "+ html_file
  # binding.pry
	renderer = ERB.new(get_template(img_tag_vect, atags = true))
	File.open(html_file, 'w') do |f|
		f.write(renderer.result())
	end

	if not Dir.exists?("./public/photo-pages")
	Dir.mkdir("./public/photo-pages")
	end

	# binding.pry

	imgs_vect.each do |img_path|
		renderer_detailed_page = ERB.new(get_template_detail(img_path.gsub("public/","")))
		html_detailed_page_name = "public/photo-pages/" + img_path.gsub("public/imgs/", "").gsub(".jpg", ".html")
		puts html_detailed_page_name
		puts
		binding.pry
		File.open(html_detailed_page_name, 'w') do |f|
			f.write(renderer_detailed_page.result())
		end
	end

end


