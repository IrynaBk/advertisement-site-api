class AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: %i[ show update destroy ]
  before_action :authenticate_request, only: [:update, :destroy, :create]
  before_action :check_correct_user, only: %i[update destroy]

  # GET /advertisements
  def index  # ! чи можна оптимізувати, щоб не витягувати кожного разу всі 
    @advertisements = Advertisement.all
    if params[:location].present? && params[:location]!="all"
      @advertisements = @advertisements.where(location: params[:location])
    end
  
    if params[:category].present? && params[:category]!="all"
      @advertisements = @advertisements.where(category: params[:category])
    end
    @advertisements = @advertisements.paginate(page: params[:page], per_page: 12).order('created_at DESC')
    render json: @advertisements, except: [:created_at, :updated_at]
  end

  # GET /advertisements/1
  def show
    render json: @advertisement , except: [:created_at, :updated_at, :user_id], include:
    [:user => {:only => [:first_name, :last_name, :id]}]
  end

  # POST /advertisements
  def create
    @advertisement = Advertisement.new(advertisement_params)
    @advertisement.user_id = @current_user.id

    if @advertisement.save
      render json: @advertisement, status: :created, location: @advertisement
    else
      render json: @advertisement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /advertisements/1
  def update
    if @advertisement.update(advertisement_params)
      render json: @advertisement
    else
      render json: @advertisement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /advertisements/1
  def destroy
    @advertisement.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def advertisement_params
      params.require(:advertisement).permit(:title, :description, :location, :category)
    end

    def check_correct_user
      @user = @advertisement.user
      if @current_user.id != @user.id
        render json:  {"error": "No access"}, status: 403
      end
    end
end
