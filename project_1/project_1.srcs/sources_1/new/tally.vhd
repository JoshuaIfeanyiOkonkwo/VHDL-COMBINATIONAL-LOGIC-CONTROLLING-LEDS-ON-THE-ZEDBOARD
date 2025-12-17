library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tally is
    port (
        scoresA, scoresB : in std_logic_vector(2 downto 0); -- input 2 vectors named scoresA and scoresB for the scores
        winner : out std_logic_vector(1 downto 0) -- output vector to find the winner
    );
end entity;

architecture loopy of tally is

begin
    process(scoresA, scoresB)
        variable countA, countB : integer :=0; 
    begin 
        countA := 0;
        countB := 0;
    -- scoresA get counted 
        for i in 0 to 2 loop
            if scoresA(i) = '1' then
                countA := countA + 1;
            end if;

    -- scoresB get count
            if scoresB(i) = '1' then
                countB := countB + 1;
            end if;
        end loop;
        -- Compare counts get the winner 
        if (countA = 0 and countB = 0) then
            winner <= "00";  -- 0 for both scoresA and scoresB
        elsif countA > countB then
            winner <= "10";  -- A wins
        elsif countB > countA then
            winner <= "01";  -- B wins
        else
            winner <= "11";  -- Tie
        end if;
    end process;
end architecture loopy; 
