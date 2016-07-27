class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel_order, :confirm_myorder]
  before_action :check_order_exists, only: [:checkout_information, :new, :create, :confirm]
  def index
    @orders = Order.all
  end

  def show

  end

  def new
    @cart = current_cart
    @order = Order.new
  end 

  def create
    @order = current_cart.build_order(order_params)
    if current_user.present?
      @order.user_id = current_user.id 
      @order.user_type = "User"
    else
      @order.user_type = "Guest"
    end

    @order.ip_address = request.remote_ip
    if @order.save
      redirect_to confirm_order_path(@order.id)
    else
      render action: 'new'
    end
  end

  def edit
   
  end

  def update
    @order.update(order_params)
    redirect_to orders_path   
  end

  def destroy
    @order.destroy
    redirect_to carts_path
  end
  
  def confirm
    @myproduct = Product.new
    @order = Order.find(params[:id])
    @order.update_attributes(:status => 'Pending')
    @product = Product.all
  end

  def confirm_myorder
   @order = Order.find(params[:id]) 
   decr_ordered_qty(@order.id)
   @order.update_attributes(:status => "Success")
       Newsletter.order_info(@order).deliver
   session[:cart_id] = nil
   flash[:notice] = "Your order is successfully placed. It will deliver soon."
   redirect_to success_orders_path
  end
  
  def success
    
  end

  def myorder
    all_carts = []
    @orders = current_user.try(:orders)
    @carts = @orders.map {|order| order.try(:cart)}
    @carts.map {|cart| all_carts << cart}
    @all_carts = all_carts
  end

  def checkout_information
    @user = User.new
  end

  def decr_ordered_qty(order)
    Order.find(order).cart.line_items.each do |li|
      @qty = li.product.quantity
      if ((@qty > 0 || @qty.present?) && (@qty >= li.quantity))
        @qty1 = (@qty-li.quantity)
        li.product.update_attributes(:quantity => @qty1)
      end
    end
  end

  def cancel_order
    if @order.update_attributes(status: 'Cancelled')
      flash[:notice] = "Your order has been cancelled."
      redirect_to myorder_orders_path
    else
      flash[:notice] = "Unprocessable entity."
    end
  end
  
  private
  def set_order
    order
  end

  def check_order_exists 
    if current_cart.line_items.blank?
      redirect_to homes_path
    end
  end

  def order
     @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:cart_id, :first_name, :last_name, :address, :landmark, :pincode, :city, :state, :country, :phone, :ip_address, :cod, :user_id, :status, :user_type, :same_as_billing, :city1, :state1, :country1, :address1, :landmark1, :phone1, :pincode1, :first_name1, :last_name1, :email)
  end

end