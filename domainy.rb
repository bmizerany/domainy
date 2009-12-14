require 'sinatra'
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

get "/*?.txt" do
  content_type  "text/plain"

  domain = params[:splat][0]
  extract_base_domain(domain)
end
