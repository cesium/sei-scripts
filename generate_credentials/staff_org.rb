require 'csv'

def run
  csv_file      = ARGV[0]
  input_image   = ARGV[1]
  qr_color      = ARGV[2]
  name_color    = ARGV[3]
  output_folder = ARGV[4]

  csv = CSV.parse(File.read(csv_file))

  csv.each do |row|
    imagemagick_pipeline(input_image, qr_color, name_color, row[0], output_folder)
  end

end

def imagemagick_pipeline(input_image, qr_color, name_color, name, output_path)
  url = "https://www.seium.org/random"
  name = name.gsub(/^ *([^ ]+).*?([^ ]*) *$/, '\1 \2')
  output_file = output_path.gsub(/\/$/, '') + "/" + name.gsub(/ /,'_') + ".png"

  system "
  qrencode '#{url}' -m 0 -l H -t SVG --svg-path --foreground=#{qr_color} |
  convert #{input_image} -density 320 svg:- -gravity Center -geometry +3-25 -composite png:- |
  convert -font CoolveticaRg-Regular -fill \"##{name_color}\" -pointsize 85 -gravity center -draw \"text 10,340 '#{name}'\" png:- #{output_file}
  "


  #convert #{input_image} -density 320 svg:- -gravity Center -geometry +3-25 -composite png:- |

  # For name in two lines instead of one
  # convert -font CoolveticaRg-Regular -fill white -pointsize 85 -gravity center -draw \"text 10,340 '#{name}'\" png:- png:- |
  # convert -font CoolveticaRg-Regular -fill white -pointsize 85 -gravity center -draw \"text 10,440 '#{surname}'\" png:- #{output_file}

  puts name
end

run