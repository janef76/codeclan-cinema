require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/ticket.rb')

require('pry-byebug')

Customer.delete_all

Film.delete_all

customer1 = Customer.new({'name' => 'Sergio', 'funds' => 100})
customer1.save()
customer2 = Customer.new({'name' => 'Tiger', 'funds' => 70})
customer2.save()
customer3 = Customer.new({'name' => 'Rory', 'funds' => 150})
customer3.save()

film1 = Film.new({'title' => 'Star Wars', 'price' => 10})
film1.save()
film2 = Film.new({'title' => 'Trainspotting', 'price' => 15})
film2.save()
film3 = Film.new({'title' => 'T2', 'price' => 20})
film3.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film2.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film1.id})
ticket2.save()
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id})
ticket3.save()

binding.pry
nil
