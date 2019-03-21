/* AUTOR: Holguer A Becerrra
 * Semillero ADT
 * https://sites.google.com/site/semilleroadt/
 * */

#include "draw_gimps.h"
#include "gimp_bmp.h"
#include "stdio.h"
#include "../vip_fr.h"




int AsVidCopyImageToBuffer( char* dest, char* src,
                            int dest_width,
                            int src_width, int src_height )
{
  int y;

  //Copy one line at a time from top to bottom
  for ( y = 0; y < src_height; y++ )
  {
    memcpy( dest, src, ( src_width * 4 ));
    src += ( src_width * 4 );
    dest += ( dest_width * 4 );
    if(y==349){printf("%d;",*src);}
  }

  return( 0 );
}

int AsVidCopyImageToBuffer2( unsigned int* dest, char* src,
                            int dest_width, 
                            int src_width, int src_height, int _x, int _y, int w_fit, int h_fit)
{
  int x;
  int y;
  int i;
  char color[4];
  unsigned char _red,_green,_blue;
  unsigned int reaL_color;
  //Copy one line at a time from top to bottom

  for ( y = 0; y < src_height; y++ )
  {
    for(x=0; x< src_width; x++){
        reaL_color=0;
        for(i=0; i<4; i++){
            color[i]=*src;
            src++;
        }
        _red=(unsigned char)color[2];
        _green=(unsigned char)color[1];
        _blue=(unsigned char)color[0];
        reaL_color=((_red<<16)|(_green<<8)|_blue) & 0xffffff;

        if(y<=h_fit && x<=w_fit){
            * (dest+((y+_y)*dest_width+(x+_x)))=reaL_color;
        }

    }
  }

  return( 0 );
}


int AsVidCopyImageToBuffer3( unsigned int* dest, char* src,
                            int dest_width,
                            int src_width, int src_height, int _x, int _y, int w_fit, int h_fit,int transparent)
{
  int x;
  int y;
  int i;
  char color[4];
  unsigned char _red,_green,_blue;
  unsigned int reaL_color;
  //Copy one line at a time from top to bottom

  for ( y = 0; y < src_height; y++ )
  {
    for(x=0; x< src_width; x++){
        reaL_color=0;
        for(i=0; i<4; i++){
            color[i]=*src;
            src++;
        }
        _red=(unsigned char)color[2];
        _green=(unsigned char)color[1];
        _blue=(unsigned char)color[0];
        reaL_color=((_red<<16)|(_green<<8)|_blue) & 0xffffff;

        if(y<=h_fit && x<=w_fit){
        	if(reaL_color!=transparent){
            * (dest+((y+_y)*dest_width+(x+_x)))=reaL_color;
        	}
        }


    }

  }

  return( 0 );
}



void DispIMAGE( void * display_in, int x, int y,void * _image_in)
{
  alt_video_display * display = (alt_video_display *)display_in;
  struct gimp_image_struct * image_in=(struct gimp_image_struct *)_image_in;
  
  bitmap_struct* image;
  char* image_dest;
  struct gimp_image_struct* CIII_image;
  
  CIII_image = image_in;
  
  image = malloc(sizeof(bitmap_struct));
  printf("image %d\n",image->biWidth);
  if(image!=NULL)
  {
	  load_gimp_bmp( CIII_image, image, 32);
	  printf("image %d\n",image->biWidth);

	  unsigned int  *frame_destiny;
	  if(display->DisplayFrame==0)
	  {
		  image_dest = (char*)display->Frame0_Base;
	  }
	  else
	  {
		  image_dest = (char*)display->Frame1_Base;
	  }

    
	  AsVidCopyImageToBuffer(image_dest,
			  image->data,
              display->width,
              image->biWidth,
              image->biHeight );
                      
	  free( image->data );
	  free( image );
  }
} 

int DispIMAGE_fit( void * display_in,void * _image_in, int x, int y, int w,int h){
    alt_video_display * display = (alt_video_display *)display_in;
    struct gimp_image_struct * image_in=(struct gimp_image_struct *)_image_in;

    bitmap_struct* image;
    unsigned int* image_dest;
    struct gimp_image_struct* CIII_image;

    CIII_image = image_in;

    image = malloc(sizeof(bitmap_struct));
    printf("image %d\n",image->biWidth);
    if(image!=NULL)
    {
    	load_gimp_bmp( CIII_image, image, 32);
    	printf("image %d\n",image->biWidth);

    	if(display->DisplayFrame==0)
    	{
    		image_dest = (char*)display->Frame0_Base;
    	}
    	else
    	{
    		image_dest = (char*)display->Frame1_Base;
    	}

    	AsVidCopyImageToBuffer2(image_dest,
    			image->data,
				display->width,
                image->biWidth,
                image->biHeight,x,y,w,h );

    	free( image->data );
    	free( image );
    	return 1;
    }
    else
    {
        return 0;
    }
}

int DispIMAGE_from_gimp( void * display_in,void * _image_in, int x, int y,int transparent){
    alt_video_display * display = (alt_video_display *)display_in;
    struct gimp_image_struct * image_in=(struct gimp_image_struct *)_image_in;

    bitmap_struct* image;
    unsigned int* image_dest;
    struct gimp_image_struct* CIII_image;

    CIII_image = image_in;

    image = malloc(sizeof(bitmap_struct));
    //printf("image %d\n",image->biWidth);
    if(image!=NULL)
    {
    	load_gimp_bmp( CIII_image, image, 32);
    	//printf("image %d\n",image->biWidth);

    	if(display->DisplayFrame==0)
    	{
    		image_dest = (char*)display->Frame0_Base;
    	}
    	else
    	{
    		image_dest = (char*)display->Frame1_Base;
    	}

    	AsVidCopyImageToBuffer3(image_dest,
    			image->data,
				display->width,
                image->biWidth,
                image->biHeight,x,y,image->biWidth,image->biHeight, transparent);

    	free( image->data );
    	free( image );
    	return 1;
    }
    else
    {
        return 0;
    }
}

