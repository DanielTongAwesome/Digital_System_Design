# Lab 3 Project Summary
### Simple Ipod - with volume indication ###
In this laboratory, you will enhance your "simple iPod" of the
previous lab in order to add an LED strength meter that will show the
strength of the audio signal.<br />

## Code Explanation
1. In this Lab, we need to first add a module to interact with the [picoblaze_module](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/lab2_template_de1soc/simple_ipod_solution.v#L353-L364)
2. Add [pacoblaze_instruction_memory.v](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/lab2_template_de1soc/PicoBlaze_template/pacoblaze_instruction_memory.v#L1-L16) file to read the generated .MEM file
3. Add picoblaze_template.v to perform interaction of the picoblaze processor
4. Modify the picoblaze_template.v especially the following [lines](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/lab2_template_de1soc/PicoBlaze_template/picoblaze_template.v#L104-L114)
5. Adding the interaction for LED[9:2] Volume Indication in the floowing [lines](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/lab2_template_de1soc/PicoBlaze_template/picoblaze_template.v#L154-L159)

Next --- Modify the assembly code
1. Modify the [cold start](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/Additional%20Files/pracPICO.psm#L153-L160)
2. Modify the [main program](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/Additional%20Files/pracPICO.psm#L163-L176)
3. Modify the [ISR](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/Additional%20Files/pracPICO.psm#L243-L355)

Note: 
1. cold start mostly for initilization
2. main program in charge of the 1s LED[0] flashing
3. ISR in charge of the Volume indication
4. Do not forget to change the [port_definitions, memory_locations](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/Additional%20Files/pracPICO.psm#L10-L42)

## How to generate the MEM file
1. Install DOSBOX
2. Open DOSBOX, then type 'mount c c:\' --- this will set the directory
3. Enter 'c:'  -- DOSBOX will change the routine to c folder
4. Copy and paste your psm file to the folder 'Assembler'
5. Mount the "c" drive via the command "mount c c:/", and go to the directory "C:\KCPSM3\Assembler"
7. Compile the PSM file by running:  KCPSM3 pracpico > compile.log
8. Check the log file, if everything successfull, then copy and paste the MEM file to your quartus project


## Assembly Logic
--- Main Program---- <br/>
the main program logic is simple just a loop and turning ON and OFF each second

--- ISR ---<br/>
   1. save the main program register value to the memory
```text
                    STORE s0, ISR_preserve_s0           ;preserve register
                    STORE s1, ISR_preserve_s1           ;preserve register
                    STORE s2, ISR_preserve_s2           ;preserve register
                    STORE s3, ISR_preserve_s3           ;preserve register
                  
                    ; read varaiables value
                    FETCH s1, ACCUMULATE_LOW
                    FETCH s2, ACCUMULATE_HIGH
                    FETCH s3, COUNTER
```
   2. read input value 
```text
                    ; read input value
                    INPUT s0, DATA_IN_PORT
```
   3. perform absolute --> adding ---> output to LED
   4. save the ISR register value to the memory, and clear if needed
```text
   LED_END:  OUTPUT s2, LED_port                    
                    LOAD s1, 00
                    LOAD s2, 00
                    LOAD s3, 00

                    STORE s1, ACCUMULATE_LOW            ;store variable
                    STORE s2, ACCUMULATE_HIGH           ;store varibale
                    STORE s3, COUNTER                   ;store variable
```
   5. put main program register value in memory back to the registers
```text
                    FETCH s0, ISR_preserve_s0           ;preserve register
                    FETCH s1, ISR_preserve_s1           ;preserve register
                    FETCH s2, ISR_preserve_s2           ;preserve register
                    FETCH s3, ISR_preserve_s3           ;preserve register
                    RETURNI ENABLE
```
   
   Note: Since the signal is only 8-bit, and each count register is 8-bit, so we need to have a carry register s2 <br/>
   Also, since we need to accumulate 256 input values and output its average, the s2 register value is already the desired <br/>
   output bit control signal.<br/>
   Check the code [here](https://github.com/DanielTongAwesome/Simple_iPod_FPGA/blob/ea75eaad3d880d2dd7fa3b19849989545b5f70cf/Lab_3/Additional%20Files/pracPICO.psm#L289-L309)
   



