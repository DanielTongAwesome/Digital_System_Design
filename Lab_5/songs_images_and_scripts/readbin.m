

fileID = fopen('song.bin','rb');
A=fread(fileID,'uint8',0,'l');

fclose(fileID);

seconds=30;
fID = fopen('song.c','w');
fprintf(fID,'const unsigned int size_song=%d;\n',seconds*44000);
fprintf(fID,'const unsigned char song[%d]={',seconds*44000);
for y = 1:(seconds*44000)
    if(y<(seconds*44000))
        fprintf(fID,'%d,\n',A(y));
    else
        fprintf(fID,'%d',A(y));
    end


end
fprintf(fID,'};');
fclose(fID);

%A=A/255;
%%sound(A,44000);