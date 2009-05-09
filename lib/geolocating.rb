require 'net/http'

module Geolocating

  # fills out geolocation object by querying user's ip
  def self.get_user_country(request)
    ip = request.remote_ip
    url = "http://api.hostip.info/get_html.php?ip=#{ip}"
    Log::log(nil, nil, Log::LOCATION_GRAB, nil, "#{url}")
    body = APIUtil::get_request(url)

    country = nil
    if body # got a geolocation reponse
      country = body.gsub(/Country:\w*(.*)\n(.*)\n(.*)\n(.*)/i, "\\1").strip
    end
    
    return country
  end
end