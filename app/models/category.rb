class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :sub_categories, :dependent => :destroy
  has_many :products, :dependent => :destroy

   def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
end