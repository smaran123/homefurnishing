class Admin::OrdersController < ApplicationController
  before_filter :authenticate_admin!
  before_action :set_order, only: [:order_status, :show]

	def index
	end

	def guest_orders
    @orders = search Order.guest_orders
	end
	
	def user_orders
		@orders = search Order.user_orders
	end

	def order_status
		@orders = Order.guest_orders.paginate(:page => params[:page], :per_page => 20).order("created_at DESC ")
		if (params.has_key?(:parm) && params[:parm] == "Shipped")
			shipped_status
		elsif (params.has_key?(:parm) && params[:parm] == "Returned")
			returned_status
		end
		redirect_to :back
	end
  
  def show
    @product = Product.all
    @order_items = @order.cart.line_items
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def shipped_status
    @order.update_attributes(:status => "Shipped")
    flash[:notice] = "You have changed the order status to Shipped."
  end

  def returned_status
    @order.update_attributes(:status => "Returned")
    flash[:notice] = "You have changed the order status to Returned."
  end

  def search(object)
    object.search(params[:search]).paginate(:page => params[:page], :per_page => 20).order("created_at DESC ")
  end
end
