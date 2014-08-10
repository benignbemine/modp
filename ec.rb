
class Point

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def coord_pair
    [@x, @y]
  end
end

class ECurve
  attr_accessor :a, :b, :p

  def initialize a, b, p
    # y^2 = x^3 + a*x + b
    @a = a
    @b = b
    @p = p
  end

  # public

  # k is private key
  def pub_key(k)
  end


  # private

  def ec_add point_1, point_2
    # get slope of line between both points
    m = get_slope point_1, point_2

    # calculate addition
    point_3
  end

  def ec_multiply point_1, k

  end


  def get_slope (point_1, point_2)
    if point_1.coord_pair == point_2.coord_pair
      (3 * point_1.x ** 2 + @a) * inverse_mod(2 * point_1.y, @p)
    else
      (point_1.y - point_2.y) * inverse_mod(point_1.x - point_2.x, @p)
    end
  end

  def inverse_mod(e, et)
    g, x = extended_gcd(e, et)
    if g != 1
      raise 'Teh maths are broken!'
    end
    x % et
  end


  def extended_gcd(a, b)
    last_remainder, remainder = a.abs, b.abs
    x, last_x, y, last_y = 0, 1, 1, 0
    while remainder != 0
      last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
      x, last_x = last_x - quotient*x, x
      y, last_y = last_y - quotient*y, y
    end

    return last_remainder, last_x * (a < 0 ? -1 : 1)
  end

end


############
# a = 0, b = 7, p = 17
ec = ECurve.new(0, 7, 17)
p ec.inverse_mod(6, 11) == 2

p1 = Point.new(1, 5)
p2 = Point.new(11, 10)

p ec.get_slope(p1, p2)
p ec.get_slope(p1, p1)
# private_key = 8

# pub_key = ec_get_pub_key private_key
