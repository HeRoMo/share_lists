class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :own_the_list?, only:[:edit, :update, :destroy]
  skip_before_filter :require_login, only: [:index, :show]

  LISTS_PAGE_SIZE = 24

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.includes(:fans).order(:created_at, :id).reverse_order
                 .page(params[:page]).per(LISTS_PAGE_SIZE)
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)
    @list.owner = @current_user

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PUT /list/:id/like
  # PUT /list/:id/like.json
  def like
    @rating = rating_param[:rating] || 0
    puts @rating
    @list.add_fan(current_user, @rating)
  end

  # DELETE /list/:id/like
  # DELETE /list/:id/like.json
  def unlike
    @list.remove_fan(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render status: :not_found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:title, :description, :items, :memo)
    end

    def rating_param
      params.permit(:rating)
    end

    # 操作対象のリストのオーナーがログインユーザであることを確認
    # オーナーでなければ元のページかルートに戻す
    def own_the_list?
      if current_user.id != @list.owner_id
        respond_to do |format|
          format.html {
            alert_message = "You are not the owner of the list."
            if request.referer.nil?
              redirect_to :root, alert: alert_message
            else
              redirect_to :back, alert: alert_message
            end
          }
          format.json { status :forbidden }
        end
      end
    end
end
