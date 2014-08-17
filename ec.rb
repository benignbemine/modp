
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

  @infinity = Point.new(0,0)

  def ec_add point_1, point_2
    # get slope of line between both points
    if point_2 == @infinity
      return point_1
    else
      m = get_slope(point_1, point_2)

      # calculate addition
      x_3 = (m*m - point_1.x - point_2.x) % @p
      y_3 = (m * (point_1.x - x_3) - point_1.y) % @p

      # final point
      Point.new(x_3, y_3)
    end
  end

  def ec_multiply(point_1, k)
    puts k
    if k == 0
      return @infinity
    elsif k.odd?
      ec_add(point_1, ec_multiply(point_1, k-1))
    else
      ec_multiply(ec_add(point_1,point_1), k/2)
    end
  end

  def get_slope (point_1, point_2)
    if point_1.coord_pair == point_2.coord_pair
      ((3 * point_1.x ** 2 + @a) * inverse_mod(2 * point_1.y, @p)) % @p
    else
      ((point_1.y - point_2.y) * inverse_mod(point_1.x - point_2.x, @p)) % @p
    end
  end

 def extended_gcd(a, b)
   last_remainder, remainder = a.abs, b.abs
   x, last_x = 0, 1

   while remainder != 0
     last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
     x, last_x = last_x - quotient*x, x
   end

   return last_remainder, last_x * (a < 0 ? -1 : 1)
 end

  def inverse_mod(e, et)
    g, x = extended_gcd(e, et)
    if g != 1
      raise 'Teh maths are broken!'
    end
    x % et
  end

end



############

p = 2**256 - 2**32 - 2**9 - 2**8 - 2**7 - 2**6 - 2**4 - 1
ec = ECurve.new(0, 7, p)

starting_point = Point.new(55066263022277343669578718895168534326250603453777594175500187360389116729240, 32670510020758816978083085130507043184471273380659243275938904335757337482424)

private_key = 72759466100064397073952777052424474334519735946222029294952053344302920927294

p ec.ec_multiply(starting_point, private_key)
 # p ec.ec_multiply(starting_point,2)
 # p ec.ec_add(ec.ec_add(ec.ec_add(starting_point, starting_point), starting_point),starting_point)
# private_key = 8

# pub_key = ec_get_pub_key private_key
