module Admin::BorrowsHelper
  def send_action_tag send_path
    content_tag :a,
      content_tag(:i, nil, class: ["zmdi", "zmdi-mail-send", "txt-warning"]),
      href: send_path, class: "text-inverse pr-10",
      data: {toggle: :tooltip, original_title: t("send")}
  end

  def borrowed_action_tag borrowed_path
    content_tag :a,
      content_tag(:i, nil,
        class: ["zmdi", "zmdi-wb-iridescent", "txt-warning"]),
      href: borrowed_path, class: "text-inverse pr-10",
      data: {toggle: :tooltip, original_title: t("borrowed")}
  end
end
