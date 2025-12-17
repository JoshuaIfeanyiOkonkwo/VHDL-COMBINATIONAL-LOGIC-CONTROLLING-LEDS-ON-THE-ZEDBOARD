# Design and Simulation of Combinational Logic Controlling LEDs With Switches on the Zedboard

This project implements a **combinational voting system** in VHDL that decides the winner between two contestants, **A** and **B**, based on the votes of **three judges**. The design is then **simulated, verified with a testbench, and implemented on the Zedboard**, where switches act as inputs and LEDs display the result.

---

## 1. Problem description

In a competition between contestants **A** and **B**, **three judges** each give a score encoded in **2 bits**:

### Judge vote encoding (per judge)

| Bits | Description           |
|------|-----------------------|
| `00` | No decision           |
| `10` | 1 point for A         |
| `01` | 1 point for B         |
| `11` | 1 point for both A&B  |

The final **winner output** is encoded in 2 bits:

### Winner encoding

| Bits | Description                                |
|------|--------------------------------------------|
| `00` | Tie, all judges gave 0 to both A and B     |
| `10` | A is the winner (A has more points)        |
| `01` | B is the winner (B has more points)        |
| `11` | Tie, A and B have equal non-zero points    |

The votes from the three judges are combined into two **3-bit vectors**:

- `scoresA(2 downto 0)` → votes for A (from each judge)
- `scoresB(2 downto 0)` → votes for B (from each judge)

Each bit of `scoresA`/`scoresB` corresponds to one judge’s vote.

---

## 2. Tally entity (vote calculator)

The core component is the **combinational vote calculator** `tally`, which takes the two 3-bit vectors as inputs and produces a 2-bit `winner` output.

### Entity definition

```vhdl
entity tally is
  port (
    scoresA : in  std_logic_vector(2 downto 0);
    scoresB : in  std_logic_vector(2 downto 0);
    winner  : out std_logic_vector(1 downto 0)
  );
end entity;
