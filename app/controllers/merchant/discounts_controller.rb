class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = current_merchant.discounts.new(discount_params)
    @discount.save ? happy_path_new : sad_path_new(@discount)
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    flash[:notice] = "You have succefully updated discount."
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:min_quantity, :percentage)
  end

  def happy_path_new
    flash[:notice] = "You have succefully created a new discount."
    redirect_to merchant_discounts_path
  end

  def sad_path_new(object)
    generate_flash(object)
    render action: :new
  end

  def current_merchant
    current_user.merchant
  end
end
