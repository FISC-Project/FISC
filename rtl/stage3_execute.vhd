LIBRARY IEEE;
USE IEEE.math_real.all;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;
USE work.FISC_DEFINES.all;

ENTITY Stage3_Execute IS
	PORT(
		clk        : in  std_logic;
		opA        : in  std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
		opB        : in  std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
		result     : out std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
		sign_ext   : in  std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
		aluop      : in  std_logic_vector(1  downto 0);
		opcode     : in  std_logic_vector(10 downto 0);
		alusrc     : in  std_logic;
		alu_zero   : out std_logic
	);
END Stage3_Execute;

ARCHITECTURE RTL OF Stage3_Execute IS
	COMPONENT ALU
		PORT(
			clk      : in  std_logic;
			opA      : in  std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
			opB      : in  std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
			func     : in  std_logic_vector(3 downto 0);
			zero : out std_logic;
			result   : out std_logic_vector(FISC_INTEGER_SZ-1 downto 0)
		);
	END COMPONENT;
	
	signal opB_reg  : std_logic_vector(FISC_INTEGER_SZ-1 downto 0);
	signal func_reg : std_logic_vector(3 downto 0) := (others => '0');
BEGIN
	-- Instantiate ALU:
	ALU1: ALU PORT MAP(clk, opA, opB_reg, func_reg, alu_zero, result);

	-- Instantiate Forward Unit:
	-- TODO

	opB_reg    <= sign_ext WHEN alusrc = '1' ELSE opB;
	func_reg   <= "0010" WHEN aluop = "00" ELSE "0111" WHEN aluop(0) = '1' ELSE 
	              "0010" WHEN (aluop(1) = '1' AND (opcode = "10001011000" or opcode(10 downto 1) = "1001000100" or opcode(10 downto 1) = "1011000100" or opcode = "10101011000"))  ELSE
	              "0110" WHEN (aluop(1) = '1' AND (opcode = "11001011000" or opcode(10 downto 1) = "1101000100" or opcode(10 downto 1) = "1111000100" or opcode = "11101011000"))  ELSE
	              "0000" WHEN (aluop(1) = '1' AND (opcode = "10001010000" or opcode(10 downto 1) = "1001001000" or opcode(10 downto 1) = "1111001000" or opcode = "11101010000"))  ELSE
	              "0001" WHEN (aluop(1) = '1' AND (opcode = "10101010000" or opcode(10 downto 1) = "1011001000"))  ELSE (others => 'X');
END ARCHITECTURE RTL;