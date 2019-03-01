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

    // key E,D,B,F,R press ascii code
    parameter character_E =8'h45;
    parameter character_lowercase_e= 8'h65;
    parameter character_D =8'h44;
    parameter character_lowercase_d= 8'h64;
    parameter character_B =8'h42;
    parameter character_lowercase_b= 8'h62;
    parameter character_F =8'h46;
    parameter character_lowercase_f= 8'h66;
    parameter character_R =8'h52;
    parameter character_lowercase_r= 8'h72;

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
        key_pressed = 8'h0;
        flash_read_finished = 1'b0;
        kbd_data_ready = 1'b0;
        #10;
        key_pressed = character_E;
        assert ({start_read_flash, dir, restart} === 3'b001) 
        else  $error("Error at 1");
        #30;
        key_pressed = character_D;
        assert ({start_read_flash, dir, restart} === 3'b000) 
        else  $error("Error at 2");
        #30;
        key_pressed = character_E;
        assert ({start_read_flash, dir, restart} === 3'b001) 
        else  $error("Error at 3");
        #30;
        key_pressed = character_D;
        assert ({start_read_flash, dir, restart} === 3'b000) 
        else  $error("Error at 4");
        #30;
        key_pressed = character_R;
        kbd_data_ready = 1'b1;
        assert ({start_read_flash, dir, restart} === 3'b101) 
        else  $error("Error at 5");
        #10
        flash_read_finished = 1'b1;
        assert ({start_read_flash, dir, restart} === 3'b001) 
        else  $error("Error at 6");
        #10;
        key_pressed = character_B;
        kbd_data_ready = 1'b0;
        assert ({start_read_flash, dir, restart} === 3'b011) 
        else  $error("Error at 7");
        #30;
        flash_read_finished = 1'b0;
        key_pressed = character_F;
        assert ({start_read_flash, dir, restart} === 3'b001) 
        else  $error("Error at 8");
        #30;
        key_pressed = character_B;
        assert ({start_read_flash, dir, restart} === 3'b011) 
        else  $error("Error at 9");
        #30;
        key_pressed = character_D;
        assert ({start_read_flash, dir, restart} === 3'b000) 
        else  $error("Error at 10");
        #30;
        key_pressed = character_E;
        assert ({start_read_flash, dir, restart} === 3'b011) 
        else  $error("Error at 11");
        #30;
        key_pressed = character_R;
        kbd_data_ready = 1'b1;
        assert ({start_read_flash, dir, restart} === 3'b111) 
        else  $error("Error at 12");
        #30;
        flash_read_finished = 1'b1;
        assert ({start_read_flash, dir, restart} === 3'b011) 
        else  $error("Error at 13");
        #30;
        $stop;
    end

endmodule