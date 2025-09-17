class PagesController < ApplicationController
  def index
    render({ :template => "page_templates/index" })
  end
end
