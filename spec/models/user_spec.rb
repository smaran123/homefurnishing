require 'spec_helper'
require 'factory_girl_rails'

describe User do
	
	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid 
	end
	it "is invalid without a email" do
		FactoryGirl.build(:user, email: nil).should_not be_valid
	end
	it "is invalid without a password" do
		FactoryGirl.build(:user, password: nil).should_not be_valid
	end

end