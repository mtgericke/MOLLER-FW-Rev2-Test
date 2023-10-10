# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "EXT_PHY_MDIO_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC_CONTROL_PAUSE_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_BUFFER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_BUFFER_ADDR_NBITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RX_MTU" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SIMULATION" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TX_BUFFER" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TX_BUFFER_ADDR_NBITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TX_MTU" -parent ${Page_0}


}

proc update_PARAM_VALUE.EXT_PHY_MDIO_ADDR { PARAM_VALUE.EXT_PHY_MDIO_ADDR } {
	# Procedure called to update EXT_PHY_MDIO_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXT_PHY_MDIO_ADDR { PARAM_VALUE.EXT_PHY_MDIO_ADDR } {
	# Procedure called to validate EXT_PHY_MDIO_ADDR
	return true
}

proc update_PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE { PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE } {
	# Procedure called to update MAC_CONTROL_PAUSE_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE { PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE } {
	# Procedure called to validate MAC_CONTROL_PAUSE_ENABLE
	return true
}

proc update_PARAM_VALUE.RX_BUFFER { PARAM_VALUE.RX_BUFFER } {
	# Procedure called to update RX_BUFFER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_BUFFER { PARAM_VALUE.RX_BUFFER } {
	# Procedure called to validate RX_BUFFER
	return true
}

proc update_PARAM_VALUE.RX_BUFFER_ADDR_NBITS { PARAM_VALUE.RX_BUFFER_ADDR_NBITS } {
	# Procedure called to update RX_BUFFER_ADDR_NBITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_BUFFER_ADDR_NBITS { PARAM_VALUE.RX_BUFFER_ADDR_NBITS } {
	# Procedure called to validate RX_BUFFER_ADDR_NBITS
	return true
}

proc update_PARAM_VALUE.RX_MTU { PARAM_VALUE.RX_MTU } {
	# Procedure called to update RX_MTU when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_MTU { PARAM_VALUE.RX_MTU } {
	# Procedure called to validate RX_MTU
	return true
}

proc update_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to update SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to validate SIMULATION
	return true
}

proc update_PARAM_VALUE.TX_BUFFER { PARAM_VALUE.TX_BUFFER } {
	# Procedure called to update TX_BUFFER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_BUFFER { PARAM_VALUE.TX_BUFFER } {
	# Procedure called to validate TX_BUFFER
	return true
}

proc update_PARAM_VALUE.TX_BUFFER_ADDR_NBITS { PARAM_VALUE.TX_BUFFER_ADDR_NBITS } {
	# Procedure called to update TX_BUFFER_ADDR_NBITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_BUFFER_ADDR_NBITS { PARAM_VALUE.TX_BUFFER_ADDR_NBITS } {
	# Procedure called to validate TX_BUFFER_ADDR_NBITS
	return true
}

proc update_PARAM_VALUE.TX_MTU { PARAM_VALUE.TX_MTU } {
	# Procedure called to update TX_MTU when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_MTU { PARAM_VALUE.TX_MTU } {
	# Procedure called to validate TX_MTU
	return true
}


proc update_MODELPARAM_VALUE.EXT_PHY_MDIO_ADDR { MODELPARAM_VALUE.EXT_PHY_MDIO_ADDR PARAM_VALUE.EXT_PHY_MDIO_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXT_PHY_MDIO_ADDR}] ${MODELPARAM_VALUE.EXT_PHY_MDIO_ADDR}
}

proc update_MODELPARAM_VALUE.RX_MTU { MODELPARAM_VALUE.RX_MTU PARAM_VALUE.RX_MTU } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_MTU}] ${MODELPARAM_VALUE.RX_MTU}
}

proc update_MODELPARAM_VALUE.RX_BUFFER { MODELPARAM_VALUE.RX_BUFFER PARAM_VALUE.RX_BUFFER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_BUFFER}] ${MODELPARAM_VALUE.RX_BUFFER}
}

proc update_MODELPARAM_VALUE.RX_BUFFER_ADDR_NBITS { MODELPARAM_VALUE.RX_BUFFER_ADDR_NBITS PARAM_VALUE.RX_BUFFER_ADDR_NBITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_BUFFER_ADDR_NBITS}] ${MODELPARAM_VALUE.RX_BUFFER_ADDR_NBITS}
}

proc update_MODELPARAM_VALUE.TX_MTU { MODELPARAM_VALUE.TX_MTU PARAM_VALUE.TX_MTU } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_MTU}] ${MODELPARAM_VALUE.TX_MTU}
}

proc update_MODELPARAM_VALUE.TX_BUFFER { MODELPARAM_VALUE.TX_BUFFER PARAM_VALUE.TX_BUFFER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_BUFFER}] ${MODELPARAM_VALUE.TX_BUFFER}
}

proc update_MODELPARAM_VALUE.TX_BUFFER_ADDR_NBITS { MODELPARAM_VALUE.TX_BUFFER_ADDR_NBITS PARAM_VALUE.TX_BUFFER_ADDR_NBITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_BUFFER_ADDR_NBITS}] ${MODELPARAM_VALUE.TX_BUFFER_ADDR_NBITS}
}

proc update_MODELPARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE { MODELPARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE}] ${MODELPARAM_VALUE.MAC_CONTROL_PAUSE_ENABLE}
}

proc update_MODELPARAM_VALUE.SIMULATION { MODELPARAM_VALUE.SIMULATION PARAM_VALUE.SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIMULATION}] ${MODELPARAM_VALUE.SIMULATION}
}

