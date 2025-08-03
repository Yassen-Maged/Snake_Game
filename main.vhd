library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
generic(xy: natural :=640*480; -- Screen dimensions.
map_dim: natural := 32*24; -- Map dimensions.
map_dim_n: natural:= 10;	-- The number of bits in the map dimensions.
snk_xy: natural := 20	--Snake dimensions 20 * 20 pixels (I call it "snake pixel").
);
port(
clk50,rstn,L,R,game_enable: in std_logic; --L & R are 2 push buttons to rote the snake either to the right
														-- or to the left (I have only 2 push buttons on my board).
VGA_R,VGA_G,VGA_B: out std_logic_vector(3 downto 0);
VGA_HS,VGA_VS: out std_logic
);
end main;

architecture beh of main is
constant map_w: natural := 32; -- map width.
constant map_h: natural := 24; -- map height.

constant max_cnt05: natural := 2500; -- max_count 0.5- snake speed: 0.5 sec = 2 Hz;
signal cnt05: natural range 0 to max_cnt05-1 := 0; --count 0.5- frequency divider.
signal screen: std_logic_vector(0 to map_dim-1); -- the whole map.
signal screen_cnt: natural range 0 to map_dim-1:=0; --screen count- specifies which location to be checked.

signal bait: natural range 0 to map_dim-1:= 11*map_h; --the snake food.
signal new_bait: std_logic; --indicates that a new bait has been added.

type moves is (new_move,making_move,done_moving); -- snake movement FSM
signal moving: moves:= new_move;

type snk_array is array (0 to map_dim-1) of unsigned(map_dim_n -1 downto 0);
signal the_snake: snk_array; --snake array- specifies the location of every snake pixel to the whole map.

signal snk_len: natural range 3 to map_dim-1:= 3; -- snake length.
type direction is (rt,lt,up,dn); --right, left, up, down.
signal head: direction; -- snake head direction.
signal snake_head,k,x: natural range 0 to map_dim-1;
signal bait_eaten: std_logic:= '0';	--x & bait_eaten: temp signal for bait location calculation.
signal j: natural range 0 to map_h := 0; --j, k are used as counters to avoid using loops.
signal curr_L,curr_R,prev_L,prev_R: std_logic:= '0'; --current,previous- detect a falling edge for left and right buttons.
signal done05,done05_prev: std_logic:= '0'; --indicates that the snake movement at the front-end is done.

type game_state is (start,play,lost,won);
signal game: game_state:= start;



COMPONENT VGA_IP
	port(
		-- Clock and Reset
		clk    : in  STD_LOGIC;
		reset_n      : in  STD_LOGIC;
		
		-- Pixel Data Interface
		data_in   : in  STD_LOGIC_VECTOR(11 downto 0);  -- 4-bit R, 4-bit G, 4-bit B
		valid  : in  STD_LOGIC;                       -- Data valid signal
		ready  : out STD_LOGIC;                       -- Ready to accept new pixel
		
		-- VGA Output Signals
		hsync       : out STD_LOGIC;
		vsync       : out STD_LOGIC;
		red        : out STD_LOGIC_VECTOR(3 downto 0);
		green        : out STD_LOGIC_VECTOR(3 downto 0);
		blue        : out STD_LOGIC_VECTOR(3 downto 0)		
	);
end component VGA_IP;
signal h_cnt: natural range 0 to map_w-1:=0; --horizontal count- checks pixels in row.
signal cnt20,vcnt20: natural range 0 to snk_xy-1:= 0; --count20, vertical count20- check snake pixels.
signal vga_valid,vga_ready: std_logic:= '0';
signal pixel: std_logic_vector(11 downto 0):= (others => '0'); --RGB colour.

component pll0 IS
	PORT
	(
		inclk0		: IN STD_LOGIC;
		c0		: OUT STD_LOGIC ; -- 25MHz to VGA clock
		c1		: OUT STD_LOGIC  -- 10KHz
	);
END component pll0;
signal VGA_CLK,clk10k, clk05: std_logic;-- 25MHZ, 10KHz, 2Hz (0.5 sec).

begin

-----------------USER INTERFACE (FRONT-END)-----------------
process(L)
begin
if L = '0' then
	curr_L <= not prev_L;
end if;
end process;

process(R)
begin
if R = '0' then
	curr_R <= not prev_R;
end if;
end process;

process(rstn, clk05)
begin
if rstn = '0' then
	screen <= (others => '0');
	done05 <= '0';
elsif rising_edge(clk05) then
--avoid using for loop for the whole snake.
	screen(to_integer(the_snake(0))) <= '1'; --show the head.
	screen(to_integer(the_snake(snk_len-1))) <= '1'; --show the tail.
	screen(to_integer(the_snake(snk_len))) <= '0'; -- hide the snake pixel after the tail.
	done05 <= not done05;
end if;
end process;

-----------------CALCULATION (BACK-END)-----------------
snake_head <= to_integer(the_snake(0));
process(clk10k,rstn)
begin
if rstn = '0' then
	snk_len <= 3;
	k<= 0;
	j <= 0;
	x <= 0;
	head <= rt;
	cnt05 <= 0;
	clk05 <= '0';
	moving <= new_move;
	game <= start;
	--initialize snake pixels position
	the_snake <= (others => (others => '0'));
	the_snake(0) <= to_unsigned(10*map_w + 4,map_dim_n);
	the_snake(1) <= to_unsigned(10*map_w + 3,map_dim_n);
	the_snake(2) <= to_unsigned(10*map_w + 2,map_dim_n);
	prev_R <= curr_R;
	prev_L <= curr_L;
	bait <= 11*map_w; --initialize bait position
	new_bait <= '1';
	bait_eaten <= '0';
	done05_prev <= '0';
	
elsif rising_edge(clk10k) then
	if cnt05 = max_cnt05 -1 then -- generate 2Hz clock
		cnt05 <= 0;
		clk05 <= not clk05;
	else
		cnt05 <= cnt05 +1;
	end if;
	
	case game is
	when start =>
		snk_len <= 3;
		k<= 0;
		j <= 0;
		x <= 0;
		head <= rt;
		moving <= new_move;
		game <= start;
		the_snake <= (others => (others => '0'));
		the_snake(0) <= to_unsigned(10*map_w + 4,map_dim_n);
		the_snake(1) <= to_unsigned(10*map_w + 3,map_dim_n);
		the_snake(2) <= to_unsigned(10*map_w + 2,map_dim_n);
		if game_enable = '1' then
			game <= play;
		end if;
		prev_R <= curr_R;
		prev_L <= curr_L;
		bait <= 11*map_w;
		new_bait <= '1';
		bait_eaten <= '0';
		
	when play =>
	
		case moving is
		when new_move=>
			case head is
			when rt=>
				if curr_r /= prev_r and curr_l = prev_l then --Right
					head <= dn;
					prev_R <= curr_R;
				elsif curr_l /= prev_l and curr_r = prev_r then --Left
					head <= up;
					prev_L <= curr_L;
				else
					head <= rt;
					prev_R <= curr_R;
					prev_L <= curr_L;
				end if;
				
			when lt=>
				if curr_r /= prev_r and curr_l = prev_l then --Right
					head <= up;
					prev_R <= curr_R;
				elsif curr_l /= prev_l and curr_r = prev_r then --Left
					head <= dn;
					prev_L <= curr_L;
				else
					head <= lt;
					prev_R <= curr_R;
					prev_L <= curr_L;
				end if;
				
			when up=>
				if curr_r /= prev_r and curr_l = prev_l then --Right
					head <= rt;
					prev_R <= curr_R;
				elsif curr_l /= prev_l and curr_r = prev_r then --Left
					head <= lt;
					prev_L <= curr_L;
				else
					head <= up;
					prev_R <= curr_R;
					prev_L <= curr_L;
				end if;

			when dn=>
				if curr_r /= prev_r and curr_l = prev_l then --Right
					head <= lt;
					prev_R <= curr_R;
				elsif curr_l /= prev_l and curr_r = prev_r then --Left
					head <= rt;
					prev_L <= curr_L;
				else
					head <= dn;
					prev_R <= curr_R;
					prev_L <= curr_L;
				end if;
				
			when others=> head <= rt;
			end case;
			moving <= making_move;
			k <= 0;
			j <= 0;
			x <= 0;
			new_bait <= '1';
			bait_eaten <= '0';
			
		when making_move =>	
			if k < snk_len then --shift the location of every snake pixel
				the_snake(snk_len -k) <= the_snake(snk_len -k -1);
				k <= k+1;
				j <= 0;
				
			elsif k >= snk_len then
				case head is
				when rt =>
					if snake_head < map_dim -1 then --Lower Right corner check
						if screen(snake_head + 1) = '1' then --Eats itself
							game <= lost;
						elsif j >= map_h-1 then --every right edge have been checked (the snake won't penetrate the wall)
							the_snake(0) <= the_snake(0) + 1;
							j <= 0;
							k <= 0;
							moving <= done_moving;
						elsif snake_head = (j+1)*map_w-1 then --Right Edge detected.
							the_snake(0) <= the_snake(0) -map_W +1; --show up at the opposit edge.
							j <= 0;
							k <= 0;
							moving <= done_moving;
						else
							j <= j + 1;
						end if;
					else
						if screen(map_dim -map_W) = '1' then --Eats itself
							game <= lost;
						else
							the_snake(0) <= to_unsigned(map_dim -map_W, map_dim_n); --show up at the opposit edge.
							j <= 0;
							k <= 0;
							moving <= done_moving;
						end if;
					end if;
					
				when lt =>
					if snake_head > 0 then --Upper Left corner check
						if screen(snake_head - 1) = '1' then --Eats itself
							game <= lost;
						elsif j >= map_h then
							the_snake(0) <= the_snake(0) - 1;
							j <= 0;
							k <= 0;
							moving <= done_moving;
						elsif snake_head = j*map_w then --Left Edge Check
							the_snake(0) <= the_snake(0) + map_w -1;
							j <= 0;
							k <= 0;
							moving <= done_moving;
						else
							j <= j + 1;
						end if;
					else
						if screen(map_W -1) = '1' then --Eats itself
							game <= lost;
						else
							the_snake(0) <= to_unsigned(map_W -1, map_dim_n);
							j <= 0;
							k <= 0;
							moving <= done_moving;
						end if;
					end if;
					
				when up =>
					if snake_head >= map_W then --Upper Edge check
						if screen(snake_head - map_w) = '1'  then --Eats itself
							game <= lost;
						else
							j <= 0;
							k <= 0;
							the_snake(0) <= the_snake(0) - map_w;
							moving <= done_moving;
						end if;
					else
						if screen(map_dim -map_w +snake_head) = '1'  then --Eats itself
							game <= lost;
						else
							j <= 0;
							k <= 0;
							the_snake(0) <= to_unsigned(map_dim -map_w +snake_head, map_dim_n);
							moving <= done_moving;
						end if;
					end if;
					
				when dn =>
					if (snake_head < map_dim - map_w) then --Lower Edge check
						if screen(snake_head + map_w) = '1' then --Eats itself
							game <= lost;
						else
							j <= 0;
							k <= 0;
							the_snake(0) <= the_snake(0) + map_w;
							moving <= done_moving;
						end if;
					else
						if screen(snake_head -map_w*(map_h-1)) = '1'  then --Eats itself
							game <= lost;
						else
							j <= 0;
							k <= 0;
							the_snake(0) <= to_unsigned(snake_head -map_w*(map_h-1), map_dim_n);
							moving <= done_moving;
						end if;
					end if;
					
				when others => null;
				end case;
			else k <= 0; j <= 0;
			end if;
			x <= 0;
			bait_eaten <= '0';
			
		when done_moving =>
		
			if snake_head = bait then -- check if the bait has been eaten.
				if bait_eaten = '0' then
					--snake length += 1.
					if snk_len = map_dim -2 then 
						game <= won;
					else
						snk_len <= snk_len +1;
					end if;
					--apply a simple algorithm to generate a random place for the new bait.
					if bait > map_dim -1 - 151 then
						x <= map_dim - bait;
					else
						x <= bait + 151; -- 151 is a prime number.
					end if;
					new_bait <= '0';
					bait_eaten <= '1';
				else
					if new_bait = '0' then
						if screen(x) = '0' then -- empty place check
							new_bait <= '1';
							bait <= x;
						else -- add 1 to check the next location if empty.
							if x >= map_dim -1 then
								x <= 0;
							else
								x <= x + 1;
							end if;
						end if;
					end if;
				end if;
			else
				new_bait <= '1';
			end if;
			
			if (done05_prev /= done05) and new_bait = '1' then --all processes has been done.
				moving <= new_move;
				done05_prev <= done05;
			else
				moving <= done_moving;
			end if;
		end case;
		
	when won =>
		--I left it blank. So, the game will freeze and you need to restart.
	when lost =>
		--I left it blank. So, the game will freeze and you need to restart.
	when others => game <= start;
	end case;
	
end if;
end process;

-----------------VGA-----------------
pll: pll0 PORT MAP (
		inclk0	 => clk50,
		c0	 => VGA_CLK, 	-- 25MHz clock for VGA
		c1	 => clk10k 		-- 10KHz clock
	);
vga_controller: vga_ip
port map(
clk => VGA_CLK,
reset_n => rstn,

data_in =>pixel,
valid => vga_valid,
ready => vga_ready,

hsync => VGA_HS,
vsync => VGA_VS,
red	 => VGA_R,
green	 => VGA_G,
blue	 => VGA_B
);

process(rstn,VGA_CLK)
begin
if rstn = '0' then
	screen_cnt <= 0;
	vcnt20 <= 0;
	h_cnt <= 0;
	cnt20 <= 0;
	
elsif rising_edge(VGA_CLK) then
	if vga_ready = '1' then --obtain the pixel colors.
		pixel <= (others => '0'); --Black
			if screen(screen_cnt) = '1' then --Snake
				pixel(11 downto 8) <= (others => '1'); --Red
			elsif screen_cnt = bait then --Bait
				pixel(7 downto 0) <= (others => '1'); --Cyan
			end if;
			--We check snake pixels. So, we'll count snk_xy vertically and horizontally.
			if cnt20 = snk_xy -1 then -- cnt20: counts a snake pixel horizontally.
				cnt20 <= 0;
				screen_cnt <= screen_cnt +1;
				
				if h_cnt = map_w-1 then -- h_cnt: counts the entire horizontal row.
					h_cnt <= 0;
					screen_cnt <= screen_cnt - map_w +1;
					
					if vcnt20 = snk_xy -1 then --v_cnt20: counts a snake pixel vertically.
						vcnt20 <= 0;
						
						if screen_cnt = map_dim -1 then -- counts the whole map in snake pixels.
							screen_cnt <= 0;
						else
							screen_cnt <= screen_cnt +1;
						end if;
					else
						vcnt20 <= vcnt20 +1;
					end if;
				else
					h_cnt <= h_cnt + 1;
				end if;
			else
				cnt20 <= cnt20 + 1;
			end if;
	end if;
end if;
end process;
vga_valid <= '1';


end beh;
