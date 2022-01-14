defmodule EspecialCodeGenerator do

    def generate_amount_of_codes(amount) do
        read_codes_from_db()
        |> get_map_of_codes
        |> generate_random_code(abs amount)
        #|> IO.inspect()
        #|> save_codes_to_db
    end

    def read_codes_from_db() do
        {:ok, raw_codes} = File.read("codes.julioDb")
        String.slice(raw_codes,0..-2)
    end

    def get_map_of_codes(raw_codes) do
        String.split(raw_codes, " ") 
        |> Enum.frequencies 
    end
    
    def generate_random_code(actual_codes, iterator) do
        generate_random_char(16)
        |> verify_code(actual_codes, iterator)
    end
    
    def generate_random_char(num_iter) when num_iter > 1 do
        [Enum.random(33..126)] ++ generate_random_char(num_iter - 1)
    end
    
    def generate_random_char(1) do
        [Enum.random(33..126)]
    end

    def verify_code(generated_code, actual_codes, iterator) do
       actual_codes_maybe_with_generated_code = Map.put_new(actual_codes, generated_code, 1)
       Map.equal?(actual_codes_maybe_with_generated_code, actual_codes)
       |> generate_another_code(actual_codes_maybe_with_generated_code, iterator)
    end

    def generate_another_code(true,  actual_codes, iterator) when iterator !== 1, do: generate_random_code( actual_codes, iterator )
    def generate_another_code(false, actual_codes, iterator) when iterator !== 1, do: generate_random_code(actual_codes, iterator-1)
    def generate_another_code(false, actual_codes, 1), do: actual_codes 

    def save_to_db(generated_codes) do
        Map.keys(generated_codes)
        |> Enum.map(fn code -> "#{code} " end)
        |> write_to_file
    end

    def write_to_file(raw_codes) do
       File.write("codes",raw_codes) 
    end
end
