class NewsItemsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :check_news_item_ownership!, :only => [:edit, :update, :destroy]

  def index
    if params[:user_id].present?
      @user = User.find_by_id(params[:user_id])
      @news_items = @user.news_items
    else
      @news_items = NewsItem.order("created_at DESC")
    end
  end

  def show
    @news_item = NewsItem.find(params[:id])
  end

  def new
    @news_item = NewsItem.new
  end

  def create
    @news_item = NewsItem.new(params[:news_item])
    @news_item.user_id = current_user.id
    if @news_item.save
      redirect_to @news_item, :notice => "Successfully created news item."
    else
      render :action => 'new'
    end
  end

  def edit
    @news_item = NewsItem.find(params[:id])
  end

  def update
    @news_item = NewsItem.find(params[:id])
    if @news_item.update_attributes(params[:news_item])
      redirect_to @news_item, :notice  => "Successfully updated news item."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @news_item = NewsItem.find(params[:id])
    @news_item.destroy
    redirect_to news_items_path, :notice => "Successfully destroyed news item."
  end

  private

  def check_news_item_ownership!
    @news_item = NewsItem.find(params[:id])
    if !current_user.present? || @news_item.user_id != current_user.id
      redirect_to root_path, :notice => "Your are not allowed to visit this page."
    end
  end

end