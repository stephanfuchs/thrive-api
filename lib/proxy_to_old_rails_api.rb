# INFO: (Stephan) taken and adjusted from https://github.com/ncr/rack-proxy#rails-middleware-example
class ProxyToOldRailsApi < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)

    if request.path =~ %r{^(?!.*\/v5).*$} && request.path != '/sidekiq'
      env["HTTP_HOST"] = 'api.cialfo.test'
      super(env)
    else
      @app.call(env)
    end
  end
end
