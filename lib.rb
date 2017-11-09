class Solver
    def self.run(size:, &block)
        solver_proxy = SolverProxy.new(size)
        solver_proxy.instance_eval &block
        puts solver_proxy.to_source
    end
end

class SolverProxy
    def initialize(size)
        @size = size
        @constraints = []
    end

    def bigger(a, b)
        @constraints << "bigger(#{a}, #{b})"
    end

    def equal(a, value)
        @constraints << "#{a} = #{value}"
    end

    def to_source
        shebang = "#!" + `which swipl`

        shebang + <<-CODE
            :- initialization main.

            #{bigger_data}
            #{solve_definition}
            #{row_constraints}
            #{col_constraints}
            #{permutation_constraints}

            #{@constraints.join(",\n")}.

            #{main}
        CODE
    end

    private
    def bigger_data
        lines = []
        @size.downto(1) do |i|
            (i-1).downto(1) do |j|
                lines << "bigger(#{i}, #{j})."
            end
        end

        lines.join "\n"
    end

    def solve_definition
        row_symbols = (1..@size).map { |n| "Row#{n}" }.join(", ")
        "solve([#{row_symbols}]) :-"
    end

    # Defines row constaints, i.e.
    #   Row1 = [C11, C12, C13, C14],
    #   Row2 = [C21, C22, C23, C24],
    #   Row3 = [C31, C32, C33, C34],
    #   Row4 =  [C41, C42, C43, C44],
    def row_constraints
        lines = []

        1.upto @size do |r|
            cells = (1..@size).map { |c| "C#{r}#{c}" }.join(", ")
            lines << "Row#{r} = [#{cells}],"
        end

        lines.join "\n"
    end

    # Defines col constraints, i.e.
    #   Col1 = [C11, C21, C31, C41],
    #   Col2 = [C12, C22, C32, C42],
    #   Col3 = [C13, C23, C33, C43],
    #   Col4 = [C14, C24, C34, C44],
    def col_constraints
        lines = []

        1.upto @size do |c|
            cells = (1..@size).map { |r| "C#{r}#{c}" }.join(", ")
            lines << "Col#{c} = [#{cells}],"
        end

        lines.join "\n"
    end

    # Defines row/col permutation constraints, i.e.
    #   Set = [1, 2, 3, 4],
    #
    #   permutation(Row1, Set),
    #   permutation(Col1, Set),
    #   permutation(Row2, Set),
    #   permutation(Col2, Set),
    #   permutation(Row3, Set),
    #   permutation(Col3, Set),
    #   permutation(Row4, Set),
    #   permutation(Col4, Set),
    def permutation_constraints
        items = (1..@size).to_a.join ", "
        lines = ["Set = [#{items}],"]

        1.upto @size do |n|
            lines << "permutation(Row#{n}, Set),"
            lines << "permutation(Col#{n}, Set),"
        end

        lines.join "\n"
    end

    def main
        <<-CODE
            main :-
                solve(B),
                format('~q~n', [B]),
                halt.
        CODE
    end
end
