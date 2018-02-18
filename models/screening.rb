require_relative('../db/sql_runner')

class Screening
  attr_reader :id
  attr_accessor :film_id, :start_time

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
  end

  def save()
    sql = "INSERT INTO screenings
    (
      film_id,
      start_time
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@film_id, @start_time]
    screening = SqlRunner.run(sql, values).first
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings
    (
      film_id,
      start_time
    )
    =
    ($1, $2
    )
    WHERE id = $3"
    values = [@film_id, @start_time, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def tickets()
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON films.id = tickets.film_id
    WHERE tickets.screening_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map {|film|Film.new(film)}
    return result
  end

  # def count_screenings()
  #   sql = "SELECT COUNT(*)
  #   FROM tickets
  #   GROUP BY start_time
  #   WHERE id = $1"
  #   values = [@id]
  #   count = SqlRunner.run(sql, values).first
  #   return count['count'].to_i
  # end

end
