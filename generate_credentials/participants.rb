require 'csv'

def run
  csv_file      = ARGV[0]
  input_image   = ARGV[1]
  qr_color      = ARGV[2]
  output_folder = ARGV[3]

  csv = CSV.parse(File.read(csv_file), headers: true)
  csv.by_row!

  csv.each do |row|
    imagemagick_pipeline(input_image, row["uuid"], qr_color, row["name"], output_folder)
  end

end

def imagemagick_pipeline(input_image, uuid, qr_color, name, output_path)
  url = "https://www.seium.org/attendees/" + uuid
  output_file = output_path.gsub(/\/$/, '') + "/" + uuid + ".png"
  name = name.gsub(/^ *([^ ]+).*?([^ ]+) *$/, '\1 \2')

  system "
  qrencode '#{url}' -m 0 -l H -t SVG --svg-path --foreground=#{qr_color} |
  convert #{input_image} -density 240 svg:- -gravity Center -geometry +3-25 -composite png:- |
  convert -font CoolveticaRg-Regular -fill white -pointsize 85 -gravity center -draw \"text 10,340 '#{name}'\" png:- #{output_file}
  "


  #convert #{input_image} -density 320 svg:- -gravity Center -geometry +3-25 -composite png:- |

  # For name in two lines instead of one
  # convert -font CoolveticaRg-Regular -fill white -pointsize 85 -gravity center -draw \"text 10,340 '#{name}'\" png:- png:- |
  # convert -font CoolveticaRg-Regular -fill white -pointsize 85 -gravity center -draw \"text 10,440 '#{surname}'\" png:- #{output_file}

  puts name
end

run