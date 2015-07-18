require 'rubygems'
require 'bundler/setup'

require 'sinatra'

DATA = {
  'popoloproject.com' => {
    host: 'www.popoloproject.com',
  },
}

get '/*' do
  logger.info DATA
  logger.info request.host
  config = DATA[request.host]
  if config
    if config[:root_to] && request.fullpath == '/'
      path = config[:root_to]
    elsif config[:undo_clean_url] && request.fullpath != '/' && request.fullpath.end_with?('/')
      path = request.fullpath.chomp('/') + '.html'
    else
      path = request.fullpath
    end
    redirect "#{request.scheme}://#{config.fetch(:host)}#{path}", 301
  else
    400
  end
end

run Sinatra::Application
