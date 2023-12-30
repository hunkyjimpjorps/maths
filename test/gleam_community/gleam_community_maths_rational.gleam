import gleam_community/maths/rational
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn new_test() {
  // Basic rational number
  rational.new(1, 2)
  |> should.be_ok()

  // Invalid rational number
  rational.new(1, 0)
  |> should.be_error()

  // Two equivalent rational numbers; the second should reduce to the first
  rational.new(1, 2)
  |> should.equal(rational.new(2, 4))

  // Two equivalent rational numbers that should reduce to the same different number
  rational.new(2, 4)
  |> should.equal(rational.new(3, 6))

  // -a/b is equivalent to a/-b
  rational.new(-1, 2)
  |> should.equal(rational.new(1, -2))
}

pub fn new_improper_test() {
    // Basic rational number 
    rational.new_improper(1, 2, 3) |> should.be_ok()

    // Invalid rational number
    
}