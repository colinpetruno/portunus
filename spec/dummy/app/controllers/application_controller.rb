class ApplicationController < ActionController::Base
  def show
    render inline: "Hello user", layout: false
  end
end
