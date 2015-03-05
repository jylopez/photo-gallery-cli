require 'erb'
require 'fileutils'

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

if not Dir.exists?("./public")
	Dir.mkdir("public")
	Dir.mkdir("public/imgs")
	FileUtils.cp_r Dir.pwd+"/photos/.", "public/imgs/"
end

imgs_vect=Dir.glob("public/imgs/*.jpg")
img_tag_vect = Array.new(imgs_vect.length)

(0..(imgs_vect.length-1)).each do |q|
	img_tag_vect[q] = "<img src=\"#{"."+(imgs_vect[q])[6..-1]}\">"
end

html_file= "./public/gallery.html"
puts "Writing html file: "+ html_file

renderer = ERB.new(get_template(img_tag_vect))
File.open(html_file, 'w') do |f|
	f.write(renderer.result())
end



