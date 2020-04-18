class Merchant::DiscountsController < Merchant::BaseController

  def index

  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = current_user.merchant.discounts.create(discount_params)
  end

  private

  def discount_params
    params.require(:discount).permit(:min_quantity, :percentage)
  end
end
