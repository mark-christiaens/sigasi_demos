// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module spi_host_reg_top (
  input clk_i,
  input rst_ni,

  // Below Regster interface can be changed
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o,
  // To HW
  output spi_host_reg_pkg::spi_host_reg2hw_t reg2hw, // Write
  input  spi_host_reg_pkg::spi_host_hw2reg_t hw2reg, // Read

  // Config
  input devmode_i // If 1, explicit error return for unmapped register access
);

  import spi_host_reg_pkg::* ;

  localparam int AW = 2;
  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;

  // incoming payload check
  logic chk_err;
  tlul_payload_chk u_chk (
    .tl_i,
    .err_o(chk_err)
  );

  // outgoing payload generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_gen_payload_chk u_gen_chk (
    .tl_i(tl_o_pre),
    .tl_o
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW)
  ) u_reg_if (
    .clk_i,
    .rst_ni,

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = (devmode_i & addrmiss) | wr_err | chk_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic [3:0] control_data_qs;
  logic [3:0] control_data_wd;
  logic control_data_we;
  logic control_sck_qs;
  logic control_sck_wd;
  logic control_sck_we;
  logic control_csb_qs;
  logic control_csb_wd;
  logic control_csb_we;
  logic control_dir_qs;
  logic control_dir_wd;
  logic control_dir_we;

  // Register instances
  // R[control]: V(False)

  //   F[data]: 3:0
  prim_subreg #(
    .DW      (4),
    .SWACCESS("RW"),
    .RESVAL  (4'h0)
  ) u_control_data (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (control_data_we),
    .wd     (control_data_wd),

    // from internal hardware
    .de     (hw2reg.control.data.de),
    .d      (hw2reg.control.data.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.data.q ),

    // to register interface (read)
    .qs     (control_data_qs)
  );


  //   F[sck]: 4:4
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_control_sck (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (control_sck_we),
    .wd     (control_sck_wd),

    // from internal hardware
    .de     (hw2reg.control.sck.de),
    .d      (hw2reg.control.sck.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.sck.q ),

    // to register interface (read)
    .qs     (control_sck_qs)
  );


  //   F[csb]: 5:5
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_control_csb (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (control_csb_we),
    .wd     (control_csb_wd),

    // from internal hardware
    .de     (hw2reg.control.csb.de),
    .d      (hw2reg.control.csb.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.csb.q ),

    // to register interface (read)
    .qs     (control_csb_qs)
  );


  //   F[dir]: 6:6
  prim_subreg #(
    .DW      (1),
    .SWACCESS("RW"),
    .RESVAL  (1'h0)
  ) u_control_dir (
    .clk_i   (clk_i    ),
    .rst_ni  (rst_ni  ),

    // from register interface
    .we     (control_dir_we),
    .wd     (control_dir_wd),

    // from internal hardware
    .de     (hw2reg.control.dir.de),
    .d      (hw2reg.control.dir.d ),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.control.dir.q ),

    // to register interface (read)
    .qs     (control_dir_qs)
  );




  logic [0:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[0] = (reg_addr == SPI_HOST_CONTROL_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = 1'b0;
    if (addr_hit[0] && reg_we && (SPI_HOST_PERMIT[0] != (SPI_HOST_PERMIT[0] & reg_be))) wr_err = 1'b1 ;
  end

  assign control_data_we = addr_hit[0] & reg_we & ~wr_err;
  assign control_data_wd = reg_wdata[3:0];

  assign control_sck_we = addr_hit[0] & reg_we & ~wr_err;
  assign control_sck_wd = reg_wdata[4];

  assign control_csb_we = addr_hit[0] & reg_we & ~wr_err;
  assign control_csb_wd = reg_wdata[5];

  assign control_dir_we = addr_hit[0] & reg_we & ~wr_err;
  assign control_dir_wd = reg_wdata[6];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[3:0] = control_data_qs;
        reg_rdata_next[4] = control_sck_qs;
        reg_rdata_next[5] = control_csb_qs;
        reg_rdata_next[6] = control_dir_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we)
  `ASSERT_PULSE(rePulse, reg_re)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o.d_valid)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit))

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
