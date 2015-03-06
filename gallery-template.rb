require 'erb'
require 'fileutils'
require 'optparse'

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

end

optparse.parse!




def get_template(img_tag_vect)
	%{
	<!DOCTYPE html>
	<html>
	<head>
		<title> My Gallery </title>
	</head>
	<body>
		<h1>My Gallery</h1>
		<% (0..(img_tag_vect.length-1)).each do |q| %>
    	<%= img_tag_vect[q] %>
    <% end %>
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

if options[:file]
	html_file = "./"+directory_name+"/"+ARGV[0]
else
	html_file= "./"+directory_name+"/gallery.html"
end

puts "Writing html file: "+ html_file

renderer = ERB.new(get_template(img_tag_vect))
File.open(html_file, 'w') do |f|
	f.write(renderer.result())
end



