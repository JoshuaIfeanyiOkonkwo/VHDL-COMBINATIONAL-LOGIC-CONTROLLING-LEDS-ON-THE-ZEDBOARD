----------------------------------------------------------------------------------
-- Testbench for tally using lookup tables
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tally_testbench is
end entity;

architecture loopy of tally_testbench is
    -- DUT signals
    signal scoresA, scoresB : std_logic_vector(2 downto 0);
    signal winner           : std_logic_vector(1 downto 0);

    -- Lookup table: number of 1's in a 3-bit vector
    type score_table_t is array(0 to 7) of integer;
    constant Score_table : score_table_t := (0, 1, 1, 2, 1, 2, 2, 3);

    -- Lookup table: winner result (countA vs countB)
    type winner_table_t is array(0 to 3, 0 to 3) of std_logic_vector(1 downto 0);
    constant Winner_table : winner_table_t := (
        ( "00", "01", "01", "01" ),  -- countA=0
        ( "10", "11", "01", "01" ),  -- countA=1
        ( "10", "10", "11", "01" ),  -- countA=2
        ( "10", "10", "10", "11" )   -- countA=3
    );

    -- Function: use LUTs to determine expected winner
    function expected_winner(sa, sb : std_logic_vector(2 downto 0)) return std_logic_vector is
        variable idxA, idxB : integer;
        variable countA, countB : integer;
    begin
        idxA := to_integer(unsigned(sa));
        idxB := to_integer(unsigned(sb));
        countA := Score_table(idxA);
        countB := Score_table(idxB);
        return Winner_table(countA, countB);
    end function;

begin
    -- Instantiate DUT (assumes entity work.tally exists)
    DUT: entity work.tally
        port map (
            scoresA => scoresA,
            scoresB => scoresB,
            winner  => winner
        );

    -- Stimulus process
    process
        variable expected : std_logic_vector(1 downto 0);
    begin
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                scoresA <= std_logic_vector(to_unsigned(i, 3));
                scoresB <= std_logic_vector(to_unsigned(j, 3));
                wait for 10 ns;

                expected := expected_winner(scoresA, scoresB);

                -- Assert DUT result matches expected
                assert (winner = expected)
                report "Mismatch! A=" & integer'image(i) &
                       " B=" & integer'image(j) &
                       " Expected=" & integer'image(to_integer(unsigned(expected))) &
                       " Got=" & integer'image(to_integer(unsigned(winner)))
                severity error;
            end loop;
        end loop;

        report "Simulation completed successfully: all cases passed." severity note;
        wait;
    end process;
end architecture;
