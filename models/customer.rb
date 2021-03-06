require_relative('../db/sql_runner.rb')
require_relative('film')

class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i if options['id'] != nil
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers
    (
      name,
      funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET
    (
      name,
      funds
      )
      =
      (
        $1, $2
      )
      WHERE id = $3"
      values = [@name, @funds, @id]
      SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map {|film|Film.new(film)}
    return result
  end

  def buy_tickets(film_id)
    film = Film.find(film_id).price
    @funds -= film
    update()
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def count_films()
    sql = "SELECT COUNT(*) FROM tickets WHERE customer_id = $1"
    values = [@id]
    count = SqlRunner.run(sql, values).first
    return count['count'].to_i
  end

  def Customer.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    customer_hash = SqlRunner.run(sql, values).first
    customer = Customer.new(customer_hash)
    return customer
  end

end
