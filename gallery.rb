

# files_vect=Dir.glob(Dir.pwd+"/"+ARGV.to_s)
# puts files_vect
# puts "uhh?"
require 'fileutils'

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

html_file="./public/gallery.html"
puts "Writing html file: "+ html_file

target = open(html_file, 'w')

target.write("<!DOCTYPE html>")
target.write("\n")
target.write("<html>")
target.write("\n")
	target.write("<head>")
target.write("\n")
		target.write("	<title> My Gallery </title>")
target.write("\n")
	target.write("</head>")
target.write("\n")
	target.write("<body>")
target.write("\n")
	 	target.write("	<h1> My Gallery </h1>")
target.write("\n")
    (0..(img_tag_vect.length-1)).each do |q|
    	target.write("	"+img_tag_vect[q])
			target.write("\n")
    end

	target.write("</body>")
target.write("\n")
target.write("</html>")



