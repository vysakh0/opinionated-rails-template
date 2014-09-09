class RealtimeGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  require 'net/http'
  def generate_socket_client
    puts "Check if you have started node server"
    url = URI.parse('http://localhost:5001/socket.io/socket.io.js')
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body if res
    begin
      file = File.open("public/javascripts/socket.io.js", "w")
      file.write(res.body)
    rescue IOError => e
      #some error occur, dir not writable etc.
    ensure
      file.close unless file == nil
    end
  end
end
