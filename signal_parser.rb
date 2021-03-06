require 'sinatra'
require 'lib/sgnl_parser.rb'

get '/' do 
  headers['Cache-Control'] = 'public, max-age=86400'
  [200, "<!DOCTYPE html><html><head><title>sgnl</title><script type='text/javascript'>
        //<![CDATA[
             var _gaq = _gaq || [];
             _gaq.push(['_setAccount', 'UA-77378-8']);
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
      <body style='font-family: Verdana, Helvetica, sans-serif;'>
        <h1 style='text-align: center;'>SGNL</h1>
        <p style='text-align: center;'>Redirector for SignalFlare</p>
        <h4>Usage</h4>
        <p>
          Encode: <code>/encode/[latitude]/[longitude]</code><br/>
          Decode: <code>/[encoded lat]/[encoded lng]</code> - will redirect to Google Maps
        </p>
        <h4>Example URLs</h4>
        <p>
          West Hartford, CT: <a href='http://sgnl.ws/1PQXr/-325jx'>http://sgnl.ws/1PQXr/-325jx</a><br/>
          Eiffel Tower, Paris: <a href='http://sgnl.ws/22v8f/6Mlb'>http://sgnl.ws/22v8f/6Mlb</a>
        </p>
        <h4>Source Code</h4>
        <p>
          Let me know if you find bugs (file issues at Github): <a href='https://github.com/sujal/SignalFlare-Redirector'>https://github.com/sujal/SignalFlare-Redirector</a>
        </p>
        <div style='height: 150px'>&nbsp;</div>
        <p>
          &copy; 2011 Forche LLC - <a href='http://forchesoftware.com'>forche software</a>
        </p>
      </body>
    </html>"] 
end

get '/encode/*/*' do

  raw_lat = params[:splat][0]
  raw_lng = params[:splat][1]

  sp = SgnlParser.new

  encoded_lat = sp.encoded_latlng(raw_lat)
  encoded_lng = sp.encoded_latlng(raw_lng)

  headers["Cache-Control"] = "public, max-age=86400"

  [200,"<!DOCTYPE html><html><head><title>sgnl</title><script type='text/javascript'>
        //<![CDATA[
             var _gaq = _gaq || [];
             _gaq.push(['_setAccount', 'UA-77378-8']);
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
      <body style='font-family: Verdana, Helvetica, sans-serif;'>
      <p>
      <em>Input</em>: #{raw_lat}/#{raw_lng}<br/>
      <em>Output</em>: <a href='http://sgnl.ws/#{encoded_lat}/#{encoded_lng}'>http://sgnl.ws/#{encoded_lat}/#{encoded_lng}</a>
      </p>
      </body>
      </html>
 "]
end

get '/test/*/*' do

  lat = (params[:splat][0]).to_f
  lng = (params[:splat][1]).to_f

  sp = SgnlParser.new

  encoded_lat = sp.encoded_latlng(lat)
  encoded_lng = sp.encoded_latlng(lng)
  decoded_lat = sp.decode_latlng(encoded_lat)
  decoded_lng = sp.decode_latlng(encoded_lng)

  [200,"#{lat}/#{lng}<br/>#{encoded_lat}/#{encoded_lng}<br/>#{decoded_lat}/#{decoded_lng}"]
  
end

# yes, being lazy and copying and pasting. :( will make it modular soon
#get '/*/*', :agent => /IEMobile/  do
  #matches two encoded values

  #encoded_lat = params[:splat][0]
  #encoded_lng = params[:splat][1]

  #sp = SgnlParser.new

  #decoded_lat = sp.decode_latlng(encoded_lat)
  #decoded_lng = sp.decode_latlng(encoded_lng)

  #headers['Cache-Control'] = 'public, max-age=86400'
  #headers['Location'] = "http://maps.google.com/maps?q=#{decoded_lat},#{decoded_lng}"
  #headers['Location'] = "http://www.bing.com/maps/?v=2&where1=#{decoded_lat}%2C#{decoded_lng}&q=#{decoded_lat}%2C#{decoded_lng}&cp=#{decoded_lat}~#{decoded_lng}&lvl=18&encType=1"

  #[301, "<!DOCTYPE html><html><head><title>sgnl</title></head><body>Redirecting to Bing Maps</body></html>" ]
#end

get '/*/*' do

  encoded_lat = params[:splat][0]
  encoded_lng = params[:splat][1]

  sp = SgnlParser.new

  decoded_lat = sp.decode_latlng(encoded_lat)
  decoded_lng = sp.decode_latlng(encoded_lng)

  headers['Cache-Control'] = 'public, max-age=86400'
  headers['Location'] = "http://maps.google.com/maps?q=#{decoded_lat},#{decoded_lng}"

  [301, "<!DOCTYPE html><html><head><title>sgnl</title></head><body>Redirecting to Google Maps</body></html>" ]
end
