class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :is_subscribed
  before_action :is_logged_in
 
  # GET /products or /products.json
  def index
    @pos_id = PosTracker.find_by(user_id: session[:user_id])
    @products = Product.all.where("pos_id = ?", @pos_id.id).order(:quantity)
    @product_count = @products.length()
    @page = params.fetch(:page, 0).to_i
    if @page < 0 
      @page = 0
    end
    @products_per_page = 5
    @products = Product.offset(@page * @products_per_page).limit(@products_per_page).order(:quantity).where(pos_id: @pos_id.id)
  end

  def search
    @pos_id = PosTracker.find_by(user_id: session[:user_id])
    search_type = params[:search_type].to_s
    if search_type == "Product Name"
      search_type = "productName"
    elsif search_type== "Product Type"
      search_type = "product_type"
    end
    @products = Product.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").where(pos_id: @pos_id.id).order(:productName).order(:quantity)
    respond_to do |format|
      if @products.length > 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("products",partial: "products/search_results", locals:{products:@products })}
      elsif @products.length <= 0
          format.turbo_stream{render turbo_stream: turbo_stream.update("products","No Record/s Found")}
      end
    end

  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("input_area",partial:"/products/form", locals:{product: @product, message: "Adding New Product"})}
    end
  end

  # GET /products/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream{render turbo_stream: turbo_stream.update("input_area",partial:"/products/form", locals:{product: @product, message: "Editing a Product"})}
    end

  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @pos_id = PosTracker.find_by(user_id: session[:user_id])
    @product.pos_id = @pos_id.id
    respond_to do |format|
      if @product.save
        format.html { redirect_to "/products", notice: "Product was successfully created." }
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("input_area",partial: "form",locals:{product: @product})}
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to "/products", notice: "Product was successfully updated." }
      else
        format.turbo_stream{render turbo_stream: turbo_stream.update("input_area",partial: "form",locals:{product: @product})}
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:pos_id, :productName, :quantity, :pricePerUnit, :product_type)
    end
end
