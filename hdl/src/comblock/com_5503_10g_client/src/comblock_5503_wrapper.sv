module comblock5503_wrapper #(
    parameter NTCPSTREAMS_MAX = 1
)(
    input wire clk,
    input wire sync_reset,
    input wire [47:0] mac_addr,
    input wire dynamic_ipv4,
    input wire [31:0] requested_ipv4_addr,
    input wire [31:0] ipv4_multicast_addr,
    input wire [31:0] ipv4_subnet_mask,
    input wire [31:0] ipv4_gateway_addr,

    input wire [127:0] ipv6_addr,
    input wire [7:0] ipv6_subnet_prefix_length,
    input wire [127:0] ipv6_gateway_addr,
    input wire [(NTCPSTREAMS_MAX*128)-1:0] tcp_dest_ip_addr,
    input wire [NTCPSTREAMS_MAX-1:0] tcp_dest_ipv4_6n,
    input wire [(NTCPSTREAMS_MAX*16)-1:0] tcp_dest_port,
    input wire [NTCPSTREAMS_MAX-1:0] tcp_state_requested,
    output wire [(NTCPSTREAMS_MAX*4)-1:0] tcp_state_status,
    input wire [NTCPSTREAMS_MAX-1:0] tcp_keepalive_en,

	output wire [63:0] mac_tx_data,
	output wire [7:0] mac_tx_data_valid,
	output wire mac_tx_sof,
	output wire mac_tx_eof,
	input wire mac_tx_cts,
	output wire mac_tx_rts,

	input wire [63:0] mac_rx_data,
	input wire [7:0] mac_rx_data_valid,
	input wire mac_rx_sof,
	input wire mac_rx_eof,
	input wire mac_rx_frame_valid,

	output wire [63:0] udp_rx_data,
	output wire [7:0] udp_rx_data_valid,
	output wire udp_rx_sof,
	output wire udp_rx_eof,
	output wire udp_rx_frame_valid,
	input wire [15:0] udp_rx_dest_port_no_in,
	input wire check_udp_rx_dest_port_no,
	output wire [15:0] udp_rx_dest_port_no_out,

	input wire [63:0] udp_tx_data,
	input wire [7:0] udp_tx_data_valid,
	input wire udp_tx_sof,
	input wire udp_tx_eof,
	output wire udp_tx_cts,
	output wire udp_tx_ack,
	output wire udp_tx_nak,

	input wire [127:0] udp_tx_dest_ip_addr,
	input wire udp_tx_dest_ipv4_6n,
	input wire [15:0] udp_tx_dest_port_no,
	input wire [15:0] udp_tx_source_port_no,

	input wire [(NTCPSTREAMS_MAX*16)-1:0] tcp_local_ports,

	output wire [(NTCPSTREAMS_MAX*64)-1:0] tcp_rx_data,
	output wire [(NTCPSTREAMS_MAX*8)-1:0] tcp_rx_data_valid,
	output wire [(NTCPSTREAMS_MAX)-1:0] tcp_rx_rts,
	input wire [(NTCPSTREAMS_MAX)-1:0] tcp_rx_cts,
	output wire [(NTCPSTREAMS_MAX)-1:0] tcp_rx_cts_ack,

	input wire [(NTCPSTREAMS_MAX*64)-1:0] tcp_tx_data,
	input wire [(NTCPSTREAMS_MAX*8)-1:0] tcp_tx_data_valid,
	input wire [(NTCPSTREAMS_MAX)-1:0] tcp_tx_data_flush,
	output wire [(NTCPSTREAMS_MAX)-1:0] tcp_tx_cts,

	// Testpoints
	output wire [(NTCPSTREAMS_MAX)-1:0] tcp_connected_flag,
	output wire [7:0] cs1,
	output wire cs1_clk,
	output wire [7:0] cs2,
	output wire cs2_clk,

	output wire [63:0] debug1,
	output wire [63:0] debug2,
	output wire [63:0] debug3,
	output wire [10:1] tp
);

COM5503 COM5503_lut (
	.CLK(clk),
	.SYNC_RESET(sync_reset),

	.MAC_ADDR(mac_addr),
	.DYNAMIC_IPv4(dynamic_ipv4),
	.REQUESTED_IPv4_ADDR(requested_ipv4_addr),
	.IPv4_MULTICAST_ADDR(ipv4_multicast_addr),
	.IPv4_SUBNET_MASK(ipv4_subnet_mask),
	.IPv4_GATEWAY_ADDR(ipv4_gateway_addr),
	.IPv6_ADDR(ipv6_addr),
	.IPv6_SUBNET_PREFIX_LENGTH(ipv6_subnet_prefix_length),
	.IPv6_GATEWAY_ADDR(ipv6_gateway_addr),

	.TCP_DEST_IP_ADDR(tcp_dest_ip_addr),
	.TCP_DEST_IPv4_6n(tcp_dest_ipv4_6n),
	.TCP_DEST_PORT(tcp_dest_port),
	.TCP_STATE_REQUESTED(tcp_state_requested),
	.TCP_STATE_STATUS(tcp_state_status),
	.TCP_KEEPALIVE_EN(tcp_keepalive_en),

	.MAC_TX_DATA(mac_tx_data),
	.MAC_TX_DATA_VALID(mac_tx_data_valid),
	.MAC_TX_SOF(mac_tx_sof),
	.MAC_TX_EOF(mac_tx_eof),
	.MAC_TX_CTS(mac_tx_cts),
	.MAC_TX_RTS(mac_tx_rts),

	.MAC_RX_DATA(mac_rx_data),
	.MAC_RX_DATA_VALID(mac_rx_data_valid),
	.MAC_RX_SOF(mac_rx_sof),
	.MAC_RX_EOF(mac_rx_eof),
	.MAC_RX_FRAME_VALID(mac_rx_frame_valid),

	.UDP_RX_DATA(udp_rx_data),
	.UDP_RX_DATA_VALID(udp_rx_data_valid),
	.UDP_RX_SOF(udp_rx_sof),
	.UDP_RX_EOF(udp_rx_eof),
	.UDP_RX_FRAME_VALID(udp_rx_frame_valid),
	.UDP_RX_DEST_PORT_NO_IN(udp_rx_dest_port_no_in),
	.CHECK_UDP_RX_DEST_PORT_NO(check_udp_rx_dest_port_no),
	.UDP_RX_DEST_PORT_NO_OUT(udp_rx_dest_port_no_out),

	.UDP_TX_DATA(udp_tx_data),
	.UDP_TX_DATA_VALID(udp_tx_data_valid),
	.UDP_TX_SOF(udp_tx_sof),
	.UDP_TX_EOF(udp_tx_eof),
	.UDP_TX_CTS(udp_tx_cts),
	.UDP_TX_ACK(udp_tx_ack),
	.UDP_TX_NAK(udp_tx_nak),
	.UDP_TX_DEST_IP_ADDR(udp_tx_dest_ip_addr),
	.UDP_TX_DEST_IPv4_6n(udp_tx_dest_ipv4_6n),
	.UDP_TX_DEST_PORT_NO(udp_tx_dest_port_no),
	.UDP_TX_SOURCE_PORT_NO(udp_tx_source_port_no),

	.TCP_LOCAL_PORTS(tcp_local_ports),
	.TCP_RX_DATA(tcp_rx_data),
	.TCP_RX_DATA_VALID(tcp_rx_data_valid),
	.TCP_RX_RTS(tcp_rx_rts),
	.TCP_RX_CTS(tcp_rx_cts),
	.TCP_RX_CTS_ACK(tcp_rx_cts_ack),

	.TCP_TX_DATA(tcp_tx_data),
	.TCP_TX_DATA_VALID(tcp_tx_data_valid),
	.TCP_TX_DATA_FLUSH(tcp_tx_data_flush),
	.TCP_TX_CTS(tcp_tx_cts),

	.TCP_CONNECTED_FLAG(tcp_connected_flag),
	.CS1(cs1),
	.CS1_CLK(cs1_clk),
	.CS2(cs2),
	.CS2_CLK(cs2_clk),
	.DEBUG1(debug1),
	.DEBUG2(debug2),
	.DEBUG3(debug3),
	.TP(tp)
);

endmodule

