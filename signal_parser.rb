require 'sinatra'
require 'lib/sgnl_parser.rb'


get '/' do 
  [200, "<!DOCTYPE html><html><head><title>sgnl</title><script type='text/javascript'>
        //<![CDATA[
             var _gaq = _gaq || [];
             _gaq.push(['_setAccount', 'UA-77378-6']);
             _gaq.push(['_setDomainName', '.sgnl.ws']);
             _gaq.push(['_trackPageview']);
                                                     
             (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
             })();
        //]]>
      </script>
      </head>
      <body>
        <h1 style='text-align: center;'>SGNL</h1>
        <p style='text-align: center;'>Redirector for SignalFlare</p>
      </body>
    </html>'"] 
end

get '/test/*/*' do

  lat = params[:splat][0]
  lng = params[:splat][1]

  sp = SgnlParser.new

  encoded_lat = sp.encoded_int(lat)
  encoded_lng = sp.encoded_int(lng)
  decoded_lat = sp.decode_latlng(encoded_lat)
  decoded_lng = sp.decode_latlng(encoded_lng)

  [200,"#{lat}/#{lng}<br/>#{encoded_lat}/#{encoded_lng}<br/>#{decoded_lat}/#{decoded_lng}"]
  
end

get '/*/*' do
  #matches two encoded values

  encoded_lat = params[:splat][0]
  encoded_lng = params[:splat][1]

  sp = SgnlParser.new

  decoded_lat = sp.decode_latlng(encoded_lat)
  decoded_lng = sp.decode_latlng(encoded_lng)

  headers['Cache-Control'] = 'public, max-age=86400'
  headers['Location'] = "http://maps.google.com/maps?q=#{decoded_lat},#{decoded_lng}"

  [301, "<!DOCTYPE html><html><head><title>sgnl</title></head><body>Redirecting to Google Maps</body></html>" ]
end
