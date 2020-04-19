class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = current_merchant.discounts.new(discount_params)
    @discount.save ? happy_path("created") : sad_path(@discount, :new)
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    @discount.save ? happy_path("updated") : sad_path(@discount, :edit)
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:min_quantity, :percentage)
  end

  def happy_path(crud_action_past_tense)
    flash[:notice] = "You have succefully #{crud_action_past_tense} discount."
    redirect_to merchant_discounts_path
  end

  def sad_path(object, render_path)
    generate_flash(object)
    render action: render_path
  end

  def current_merchant
    current_user.merchant
  end
end
