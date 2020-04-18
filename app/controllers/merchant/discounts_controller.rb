class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
    @discount.save ? happy_path_new : sad_path_new(@discount)
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  private

  def discount_params
    discount_params = params.require(:discount).permit(:min_quantity, :percentage)
    discount_params[:merchant_id] = current_merchant.id
    discount_params
  end

  def happy_path_new
    flash[:notice] = "You have succefully created a new discount."
    redirect_to "/merchant/discounts"
  end

  def sad_path_new(object)
    generate_flash(object)
    render action: :new
  end

  def current_merchant
    current_user.merchant
  end
end
