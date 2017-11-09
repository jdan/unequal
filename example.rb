require_relative "lib.rb"

Solver.run size: 4 do
    bigger :C12, :C13
    bigger :C24, :C34
    bigger :C32, :C33
    bigger :C42, :C32
    equal :C44, 1
end
