class NewsItemsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :rate]
  before_filter :check_news_item_ownership!, :only => [:edit, :update, :destroy]

  def index
    if params[:user_id].present?
      @user = User.find_by_id(params[:user_id])
      @news_items = NewsItem.ordered_by_rating_and_date(@user)
    else
      @news_items = NewsItem.ordered_by_rating_and_date
    end
  end

  def show
    @ip = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
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

  def rate    
    if request.xhr?
      news_item = NewsItem.find(params[:idBox])

      ip = request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip

      if !news_item.allowed_to_rate?(ip, current_user)
        render :nothing => true, :status => 401
      else        
        rating = news_item.ratings.new      
        rating.value = params[:rate]
        rating.ip = ip
        if user_signed_in?
          rating.user_id = current_user.id
        end

        if rating.save
          render :json => news_item
        else
          render :nothing => true, :status => 500
        end
      end
    end
  end

  private

  def check_news_item_ownership!
    @news_item = NewsItem.find(params[:id])
    if !user_signed_in? || @news_item.user_id != current_user.id
      redirect_to root_path, :notice => "Your are not allowed to visit this page."
    end
  end
end