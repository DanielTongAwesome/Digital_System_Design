# Lab 1 Project Summary
Basic Tone Organ ( Basic Verilog / VHDL ) <br />
In this lab we will construct a basic 1-octave frequency organ.<br />

## Getting Started 
Step 1: Design the frequency divider<br />
Step 2: Design the LED_Control.v<br />
Step 3: Design the "node display"<br />
Step 4: Design the "frequency display"<br />


## Detailed Description
### Step 1 -- Design the frequency divider
Here is an example of the frequency divider <br />
<img src="https://user-images.githubusercontent.com/26049843/51406543-5620e800-1b0e-11e9-9fe2-58667200fd2b.png" width="500"><br />
The basic logic of design frequency divider is simple, for example our base frequency is 50MHz, then we count how many periods we need to wait for the flip for a 1Hz signal: <br /> <br />
Equation is simple:   **(Base Frequency /  (Target Frequency * 2))** <br /> <br /> Below is the logic: <br />
<img src="https://user-images.githubusercontent.com/26049843/51407133-dd229000-1b0f-11e9-8840-bba68288eb16.png" width="500"><br /><br />
**Note** Here is the problem confused me for a long time, why the **count < count_end - 1** Here is the reason: <br />
<img src="https://user-images.githubusercontent.com/26049843/51407257-37bbec00-1b10-11e9-9f50-c3fa68e0ab7c.png" width="500"><br /><br />
After the flip, due to the else sentence, it will set the count to the 0, and then at the next rising edge it will rise to 1 and then we finished 2 complete cycles, we should flip again, that is why count < count_end - 1 <br /><br />

### Step 2 --  Design the LED_Control.v
<br />
<img src="https://user-images.githubusercontent.com/26049843/51407457-cfb9d580-1b10-11e9-8a47-2b422bf312f3.png" width="500"><br />
shift_direction --> controls the direction of shift <br />
we only need to consider the boundary condition at the very left(8'b0000_0001) and right(8'b1000_0000), on the boundary condition we need to flip the shift_direction<br />

### Step 3  & 4 --  Design the "node display" & Design the "frequency display"<br />

Step 3 and 4 needs to modify the code inside the **LCD_Scope_Encapsulated_pacoblaze_wrapper LCD_LED_scope** module <br /><br />
Below is the solution: <br /><br />
<img src="https://user-images.githubusercontent.com/26049843/51407763-a6e61000-1b11-11e9-94e1-c2f8907e7c3b.png" width="500">
<br /><br />
## Author

* **Daniel Tong** - *Initial work* - [Github Link](https://github.com/DanielTongAwesome)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


