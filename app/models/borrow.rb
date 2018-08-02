class Borrow < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: {waiting: 0, sent: 1, borrowed: 2}

  def send_acceptance_email
    BorrowMailer.accept_request(self).deliver_now
  end
end
