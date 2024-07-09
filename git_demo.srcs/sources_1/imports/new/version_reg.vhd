library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity v_reg is
    port (
        -- Clock and reset
        clk   : in  std_logic;
        reset : in  std_logic;

        -- AXI read address channel
        axi_araddr  : in  std_logic_vector(31 downto 0);
        axi_arvalid : in  std_logic;
        axi_arready : out std_logic;

        -- AXI read data channel
        axi_rdata   : out std_logic_vector(31 downto 0);
        axi_rvalid  : out std_logic;
        axi_rready  : in  std_logic;
        axi_rresp   : out std_logic_vector(1 downto 0);

        -- AXI control
        axi_awaddr  : in  std_logic_vector(31 downto 0);
        axi_awvalid : in  std_logic;
        axi_awready : out  std_logic;
        axi_wdata   : in  std_logic_vector(31 downto 0);
        axi_wstrb   : in  std_logic_vector(3 downto 0);
        axi_wvalid  : in  std_logic;
        axi_wready  : out std_logic;
        axi_bresp   : out std_logic_vector(1 downto 0);
        axi_bvalid  : out std_logic;
        axi_bready  : in  std_logic
    );
end v_reg;

architecture rtl of v_reg is
    -- Register to be read
    signal s_axi_arready : std_logic;
	signal version : std_logic_vector(31 downto 0) := x"02640e06"; -- New version signal
    signal s_axi_rvalid : std_logic;
    
    ATTRIBUTE X_INTERFACE_INFO : STRING;

    ATTRIBUTE X_INTERFACE_INFO of axi_awaddr: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE AWADDR";
    ATTRIBUTE X_INTERFACE_INFO of axi_awvalid: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE AWVALID";
    ATTRIBUTE X_INTERFACE_INFO of axi_wdata: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE WDATA";
    ATTRIBUTE X_INTERFACE_INFO of axi_wvalid: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE WVALID";
    ATTRIBUTE X_INTERFACE_INFO of axi_wready: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE WREADY";
    ATTRIBUTE X_INTERFACE_INFO of axi_bresp: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE BRESP";
    ATTRIBUTE X_INTERFACE_INFO of axi_bvalid: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE BVALID";
    ATTRIBUTE X_INTERFACE_INFO of axi_bready: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE BREADY";
    ATTRIBUTE X_INTERFACE_INFO of axi_araddr: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE ARADDR";
    ATTRIBUTE X_INTERFACE_INFO of axi_arvalid: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE ARVALID";
    ATTRIBUTE X_INTERFACE_INFO of axi_arready: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE ARREADY";
    ATTRIBUTE X_INTERFACE_INFO of axi_rdata: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE RDATA";
    ATTRIBUTE X_INTERFACE_INFO of axi_rvalid: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE RVALID";
    ATTRIBUTE X_INTERFACE_INFO of axi_rready: SIGNAL is "xilinx.com:interface:aximm:1.0 AXI_LITE RREADY";
    
    
    
begin
    -- AXI read address channel
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                axi_arready <= '0';
            elsif axi_arvalid = '1' and s_axi_arready = '0' then
                axi_arready <= '1';
            else
                axi_arready <= '0';
            end if;
        end if;
    end process;

    -- AXI read data channel
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '0' then
                s_axi_rvalid <= '0';
                axi_rdata <= (others => '0');
            elsif s_axi_arready = '1' and axi_arvalid = '1' then
                axi_rdata <= version;
                s_axi_rvalid <= '1';
            elsif s_axi_rvalid = '1' and axi_rready = '1' then
                s_axi_rvalid <= '0';
            end if;
        end if;
    end process;
    axi_arready <= s_axi_arready;
    axi_rvalid <= s_axi_rvalid;
    -- Placeholder for write operations (not implemented)
    axi_wready <= '0';
    axi_bresp <= "00";  -- OKAY response
    axi_rresp <= "00";
    axi_bvalid <= '0';
    axi_awready <= '1';
end ;














