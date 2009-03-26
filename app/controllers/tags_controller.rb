class TagsController < ApplicationController
  def index
    @tags = Tag.find(:all)
  end
end
