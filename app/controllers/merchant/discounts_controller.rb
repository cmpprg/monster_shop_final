class Merchant::DiscountsController < Merchant::BaseController

  def index

  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
    @discount.save ? happy_path_new : sad_path_new(@discount)
  end

  private

  def discount_params
    discount_params = params.require(:discount).permit(:min_quantity, :percentage)
    discount_params[:merchant_id] = current_user.merchant.id
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
end
