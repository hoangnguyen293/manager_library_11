class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: {waiting: 0, sent: 1, borrowed: 2}

  scope :ordered_by_created_at, ->{order created_at: :desc}
  validates :borrowed_date, :returned_date, presence: true
  validate :brrowed_date_after_now
  validate :returned_date_after_borrowed_date

  def send_acceptance_email
    BorrowMailer.accept_request(self).deliver_now
  end

  def find_borrows search_params
    @borrows = Borrow.joins(:user, :book).order("created_at desc")
    find_borrows_by_email search_params[:email]
    find_borrows_by_book_name search_params[:book_name]
    @borrows
  end

  private

  def brrowed_date_after_now
    return if borrowed_date.nil?
    return unless borrowed_date < Time.now
    errors.add(:borrowed_date, I18n.t("borrows.brrowed_date_after_now"))
  end

  def returned_date_after_borrowed_date
    return if returned_date.nil?
    return if borrowed_date.nil?
    return unless returned_date <= borrowed_date
    errors.add(:returned_date, I18n.t("borrows.validate_returned_date"))
  end

  def find_borrows_by_email email
    return unless email.present?
    @borrows = @borrows.where("users.email like ?", "%" + email + "%")
  end

  def find_borrows_by_book_name book_name
    return unless book_name.present?
    @borrows = @borrows.where("books.name like ?", "%" + book_name + "%")
  end
end
