class BackgroundController < ApplicationController
  def index
    images = Dir.glob('public/images/*-bk.jpg')
    send_file images[rand(images.size)], :type => 'image/jpeg', :disposition => 'inline'
  end
end
