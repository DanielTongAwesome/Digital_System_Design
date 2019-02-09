/*
 * Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code/Keyboard_Control_tb.sv
 * Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_2/lab2_template_de1soc/added_code
 * Created Date: Friday, February 8th 2019, 9:20:41 pm
 * Author: DanielTong
 * 
 * Testbench of Keyboard_Control.sv
 */

`timescale 1ns/1ns

module Keyboard_Control_tb;
    logic clk;
    logic kbd_data_ready;
    logic flash_read_finished;
    logic [7:0] key_pressed;

    logic dir;
    logic start_read_flash;
    logic restart;

    Keyboard_Control dut(
        .clk(clk),
        .kbd_data_ready(kbd_data_ready),
        .flash_read_finished(flash_read_finished),
        .key_pressed(key_pressed),
        .dir(dir),
        .start_read_flash(start_read_flash),
        .restart(restart)
    );

    // clock
    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end

    initial begin
        #10;
        kbd_data_ready = 8'h45;
        #10;
    end

endmodule