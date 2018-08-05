10.times do |n|
  name = Faker::Book.genre
  description = Faker::Book.title
  Category.create!(name: name, description: description)
end

10.times do |n|
  name = Faker::Book.publisher
  location = Faker::Address.street_address
  Publisher.create!(name: name, location: location)
end

10.times do |n|
  name = Faker::Book.author
  description = Faker::Lorem.sentence(3)
  detail = Faker::Lorem.paragraph(3)
  Author.create!(name: name, description: description, detail: detail)
end

20.times do |n|
  name = Faker::Book.title
  description = Faker::Lorem.sentence(3)
  detail = Faker::Lorem.paragraph(4)
  edition = Faker::Lorem.sentence(2)
  pages = rand(10..1000)
  category_id = Category.order("RAND()").first.id
  publisher_id = Publisher.order("RAND()").first.id
  author_id = Author.order("RAND()").first.id
  Book.create!(name: name, description: description, detail: detail,
    edition: edition, pages: pages, category_id: category_id,
    publisher_id: publisher_id, author_id: author_id)
end

20.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, role: rand(3), password: password,
    password_confirmation: password, activated: :true)
end
