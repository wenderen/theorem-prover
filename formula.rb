class Formula
  attr_accessor :lhs, :rhs

  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def set_to_expr(expr)
    Formula.new(expr.lhs, expr.rhs)
  end

  def print_formula
    print '('
    @lhs.print_formula
    print ' -> '
    @rhs.print_formula
    print ')'
  end

  def substitute(var, expr)
    Formula.new(@lhs.substitute(var, expr), @rhs.substitute(var, expr))
  end

  def ==(x)
    return false if x.class != self.class
    return @lhs == x.lhs && @rhs == x.rhs
  end

  class << self
    def axiom1(a_val, b_val)
      return Formula.new(a_val, Formula.new(b_val, a_val))
    end

    def axiom2(a_val, b_val, c_val)
      lhs = Formula.new(a_val, Formula.new(b_val, c_val))
      rhs = Formula.new(Formula.new(a_val, b_val), Formula.new(a_val, c_val))
      return Formula.new(lhs, rhs)
    end

    def axiom3(a_val)
      return Formula.new(Formula.new(Formula.new(a_val, $FALSE_VAL), $FALSE_VAL), a_val)
    end

    def modus_ponens(formula1, formula2)
      if formula1.is_a?(Formula) and formula1.lhs == formula2
        formula1.rhs
      elsif formula2.is_a?(Formula) and formula2.lhs == formula1
        formula2.rhs
      else
        # puts "You are trying to apply modus ponens to "
        # formula1.print_formula
        # formula2.print_formula
        raise "error: cannot apply modus ponens here"
      end
    end
  end
end

class Variable < Formula
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def print_formula
    print @name
  end

  # return a formula from a variable
  # with the variable replaced by the given formula 'expr'
  def substitute(var, expr)
    if expr.is_a?(Variable)
      var.name == @name ? expr : self
    else
      Formula.new(expr.lhs, expr.rhs)
    end
  end

  def ==(x)
    x.class == Variable ? x.name == @name : false
  end

  def logical_not
    Formula.new(self,$FALSE_VAL)
  end

  def logical_or(x)
    Formula.new(
      Formula.new(self,$FALSE_VAL),
      x
    )
  end

  def logical_and(x)
    Formula.new(
      Formula.new(
        self,
        Formula.new(x, $FALSE_VAL)
      ),
      $FALSE_VAL
    )
  end
end

# syntactic false variable
$FALSE_VAL = Variable.new('False')