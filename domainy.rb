require 'sinatra'
require 'haml'
require 'tlds'

TEN_YEARS = 60 * 60 * 24 * 30 * 12 * 10
IPX       = /\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}/

helpers do
  def extract_base_domain(domain)
    return domain if domain =~ IPX
    parts = domain.split(".")
    if CTLDS.include?(parts[-1]) &&
       GTLDS.include?(parts[-2]) && 
       parts[-3] != "www"

      parts[-3..-1] * "."
    else
      parts[-2..-1] * "."
    end
  end
end

get "/" do
  haml :index
end

## API Method
get "/*" do
  content_type  "text/plain"
  response["Cache-Control"] = "public, max-age=#{TEN_YEARS}"

  domain = params[:splat][0]
  extract_base_domain(domain)
end

__END__

@@ layout

%html
  %body
    = yield
    #footer
      By Blake Mizerany (c) 2009
      code from
      %a{:href => "http://phosphorusandlime.blogspot.com/2007/08/php-get-base-domain.html"} phosphorusandlime
      and a little style from
      %a{:href => "http://down4.net"} down4.net
      %p
        code is
        %a{:href => "http://github.com/bmizerany/domainy"} here

@@ index
%h3 Domainy is a simple service for getting the base of a domain
%h4 Simply GET /q/[domain] to get it's base
