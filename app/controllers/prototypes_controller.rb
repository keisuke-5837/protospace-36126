class PrototypesController < ApplicationController
  #before_action :authenticate_user! only: [:index, :show]
  before_action :set_prototype, only: [:edit, :show]

  def index
    @prototypes = Prototype.all
  end

  def new
    redirect_to root_path unless current_user.id == @buy_item.user_id
    @prototype = Prototype.new
  end

  def create
    #binding.pry
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    redirect_to root_path unless current_user == @buy_item.user_id
  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_path unless current_user == @buy_item.user_id
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    render :index
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end
