require 'csv'

def run
  csv_file      = ARGV[0]
  input_image   = ARGV[1]
  qr_color      = ARGV[2]
  output_folder = ARGV[3]

  csv = CSV.parse(File.read(csv_file))

  csv.each do |row|
    imagemagick_pipeline(input_image, row[0], qr_color, output_folder)
  end

end

def imagemagick_pipeline(input_image, uuid, qr_color, output_path)
  url = "https://www.seium.org/attendees/" + uuid
  output_file = output_path.gsub(/\/$/, '') + "/" + uuid + ".png"

  system "
  qrencode '#{url}' -m 0 -l H -t SVG --svg-path --foreground=#{qr_color} |
  convert #{input_image} -density 480 svg:- -gravity Center -geometry +6-50 -composite #{output_file}
  "

  #convert #{input_image} -density 320 svg:- -gravity Center -geometry +3-25 -composite png:- |

  puts uuid
end

run