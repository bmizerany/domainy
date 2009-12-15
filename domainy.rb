require 'sinatra'
require 'haml'
require 'tlds'

TEN_YEARS = 60 * 60 * 24 * 30 * 12 * 10 # Overkill
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
  content_type "text/plain"

  response["Cache-Control"] = "public, max-age=#{TEN_YEARS}"

  domains = params[:splat][0]
  domains.split("/").map {|domain| extract_base_domain(domain)}.join(",")
end

__END__

@@ layout

%html
  %body
    = yield
    #footer
      By Blake Mizerany (c) 2009
      code infulenced by
      %a{:href => "http://phosphorusandlime.blogspot.com/2007/08/php-get-base-domain.html"} phosphorusandlime
      %p
        code is
        %a{:href => "http://github.com/bmizerany/domainy"} here

@@ index
%h3 Domainy is a simple service for getting the base of a domain
%h4 Simply GET /:domain1[/:domain2][/etc..] to get it's base
%p NOTE: You can use SSL thanks to heroku's piggyback SSL
