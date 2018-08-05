class Category < ApplicationRecord
  has_many :books, dependent: :destroy
  default_scope{order created_at: :desc}
  scope :load_more, (lambda do |offset|
    order("created_at desc")
      .limit(Settings.categories.categories_menu_limit).offset(offset)
  end)
  scope :list_category, ->{select :id, :name}
  scope :list_category_top, (lambda do
    joins(:books).select("categories.id, count(books.id), categories.name")
    .group("categories.id").order("count(books.id) DESC")
    .limit(Settings.homes.categories_in_page)
  end)
  validates :name, presence: true,
    length: {minimum: Settings.min_length_category,
             maximum: Settings.max_length_category}
end
