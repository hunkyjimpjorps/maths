import gleam/int
import gleam/float
import gleam/order.{Eq, Gt, Lt}
import gleam_community/maths/arithmetics

pub opaque type Rational {
  Rational(num: Int, den: Int)
}

fn reduce(num: Int, den: Int) -> Rational {
  let g = arithmetics.gcd(int.absolute_value(num), int.absolute_value(den))

  case den < 0 {
    True -> Rational(-num / g, -den / g)
    False -> Rational(num / g, den / g)
  }
}

fn do_pow(x: Int, n: Int) -> Int {
  case n {
    0 -> 1
    1 -> x
    2 -> x * x
    n ->
      case n % 2 {
        0 -> do_pow(x * x, n / 2)
        _ -> x * do_pow(x, n - 1)
      }
  }
}

// public functions
// creation
/// Creates a new rational number from a numerator (top of the fraction) and denominator (bottom).
/// 
pub fn new(num: Int, den: Int) -> Result(Rational, Nil) {
  case den {
    0 -> Error(Nil)
    _ -> Ok(reduce(num, den))
  }
}

/// Creates a new rational number from an improper fraction,
/// which has a whole number part as well as a numerator and denominator.
/// 
pub fn new_improper(whole: Int, num: Int, den: Int) -> Result(Rational, Nil) {
  new(num + whole * den, den)
}

/// Creates a new rational number from a float, rounding it to the nearest rational increment.
/// 
pub fn from_float(from f: Float, to_nearest inc: Rational) -> Rational {
  reduce(
    float.round(f *. int.to_float(inc.den) /. int.to_float(inc.num)),
    inc.den,
  )
}

/// Creates a new rational number from an integer.
pub fn from_int(from: Int) -> Rational {
  let assert Ok(r) = new(from, 1)
  r
}

/// Returns the nearest float to the rational number.
/// 
pub fn to_float(r: Rational) -> Float {
  int.to_float(r.num) /. int.to_float(r.den)
}

pub fn truncate(r: Rational) -> Int {
  r.num / r.den
}

/// Takes a rational number and returns it as a tuple representing a mixed fraction, with a whole 
/// part and a fractional part.
pub fn to_mixed_fraction(r: Rational) -> #(Int, Rational) {
  #(r.num / r.den, reduce(r.num % r.den, r.den))
}

// math
/// Adds two rational numbers.
/// 
pub fn add(a: Rational, b: Rational) -> Rational {
  reduce(a.num * b.den + b.num * a.den, a.den * b.den)
}

/// Subtracts two rational numbers.
/// 
pub fn subtract(a: Rational, b: Rational) -> Rational {
  reduce(a.num * b.den - b.num * a.den, a.den * b.den)
}

/// Multiplies two rational numbers.
/// 
pub fn multiply(a: Rational, b: Rational) -> Rational {
  reduce(a.num * b.num, a.den * b.den)
}

pub fn divide(a: Rational, b: Rational) -> Result(Rational, Nil) {
  case b.num {
    0 -> Error(Nil)
    _ -> Ok(reduce(a.num * b.den, a.den * b.num))
  }
}

pub fn reciprocal(a: Rational) -> Rational {
  reduce(a.den, a.num)
}

pub fn pow(a: Rational, n: Int) -> Rational {
  case int.compare(n, 0) {
    Gt -> reduce(do_pow(a.num, n), do_pow(a.den, n))
    Eq -> from_int(1)
    Lt -> reduce(do_pow(a.den, -n), do_pow(a.num, -n))
  }
}

pub fn absolute_value(a: Rational) -> Rational {
  reduce(int.absolute_value(a.num), a.den)
}

// comparison
/// Compares two rational numbers, returning an `Order` type that describes their relationship
pub fn compare(a: Rational, b: Rational) -> order.Order {
  int.compare(a.num * b.den, b.num * a.den)
}

pub fn to_string(r: Rational) -> String {
  int.to_string(r.num) <> "/" <> int.to_string(r.den)
}
