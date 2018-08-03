class HomeController < ApplicationController
  before_action :load_items, only: :index

  def index; end

  private

  def load_items
    @support = Supports::Home.new
  end
end
