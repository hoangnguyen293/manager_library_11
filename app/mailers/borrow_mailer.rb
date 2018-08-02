class BorrowMailer < ApplicationMailer
  def accept_request borrow
    @borrow = borrow
    mail to: borrow.user.email, subject: t("mailer.accept_request")
  end
end
