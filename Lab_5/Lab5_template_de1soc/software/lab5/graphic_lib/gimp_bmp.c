#include <stdio.h>
#include <stdlib.h>
#include "gimp_bmp.h"

int load_gimp_bmp( GimpImage *gimp_image, 
                    bitmap_struct *bmp, 
                    int output_bits_per_pixel )
{
  int ret_code = 0;
  
  int output_bytes_per_pixel = output_bits_per_pixel / 8;
  int num_pixels = gimp_image->width * gimp_image->height;
  
  bmp->biWidth = gimp_image->width;
  bmp->biHeight = gimp_image->height;
  bmp->biBitCount = output_bits_per_pixel;
  
  /* try to allocate memory for bitmap data */
  if ((bmp->data = malloc(num_pixels * output_bytes_per_pixel)) == NULL)
  {
    ret_code = -1;
  }
  else
  {
    if( output_bits_per_pixel == 16 )
    {
      if( gimp_image->bytes_per_pixel == 4 )
      {
        copy_pix_map_32_to_16( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
      }
      if( gimp_image->bytes_per_pixel == 3 )
      {
        copy_pix_map_24_to_16( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
  
      }
    }
    if( output_bits_per_pixel == 24 )
    {
      if( gimp_image->bytes_per_pixel == 4 )
      {
        copy_pix_map_32_to_24( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
      }
      if( gimp_image->bytes_per_pixel == 3 )
      {
        copy_pix_map_24_to_24( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
  
      }
    }
    if( output_bits_per_pixel == 32 )
    {
      if( gimp_image->bytes_per_pixel == 4 )
      {
        copy_pix_map_32_to_32( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
      }
      if( gimp_image->bytes_per_pixel == 3 )
      {
        copy_pix_map_24_to_32( gimp_image->pixel_data, //void *src_ptr,
                               bmp->biWidth, //long src_active_width,
                               bmp->biHeight, // long src_active_height,
                               bmp->biWidth, //long src_line_width,
                               bmp->data, //void *dest_ptr,
                               bmp->biWidth  );  //long dest_line_width
  
      }
    }
  }
  
  return( ret_code );
}

void copy_pix_map_32_to_32(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;
  
  src_increment = src_line_width + src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width + dest_line_width + dest_line_width;
  
  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      *(unsigned long *)(dest_line_ptr) = *(unsigned long *)(src_line_ptr);
      src_line_ptr += 4;
      dest_line_ptr += 4;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}


void copy_pix_map_32_to_24(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;
  
  src_increment = src_line_width + src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width + dest_line_width;

  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      *(unsigned char *)(dest_line_ptr) = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr) = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr) = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 2;
      dest_line_ptr += 1;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}


void copy_pix_map_32_to_16(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  unsigned long next_long_pixel;
  unsigned short next_short_pixel;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;
  
  src_increment = src_line_width + src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width;
  
  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      next_long_pixel = *(unsigned long *)(src_line_ptr);
      src_line_ptr += 4;

      next_short_pixel =  (((next_long_pixel >> 3) & 0x1f) << 11) |
                          (((next_long_pixel >> 10) & 0x3f) << 5) |
                          (((next_long_pixel >> 19) & 0x1f) << 0) ;

      *(unsigned short *)(dest_line_ptr) = next_short_pixel;
      dest_line_ptr += 2;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}


void copy_pix_map_24_to_32(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;
  
  src_increment = src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width + dest_line_width + dest_line_width;
  
  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      *(unsigned char *)(dest_line_ptr + 2)  = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr)  = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr - 2)  = *(unsigned char *)(src_line_ptr);
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr)  = 0xff;
      dest_line_ptr += 1;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}


void copy_pix_map_24_to_24(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;

  src_increment = src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width + dest_line_width;
  
  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      *(unsigned char *)(dest_line_ptr) = (*(unsigned char *)(src_line_ptr));
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr) = (*(unsigned char *)(src_line_ptr));
      src_line_ptr += 1;
      dest_line_ptr += 1;
      *(unsigned char *)(dest_line_ptr) = (*(unsigned char *)(src_line_ptr));
      src_line_ptr += 1;
      dest_line_ptr += 1;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}

void copy_pix_map_24_to_16(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width
                  )
{
  int src_row, src_col;
  unsigned short next_short_pixel;
  void *src_line_ptr, *dest_line_ptr;
  long src_increment, dest_increment;

  src_increment = src_line_width + src_line_width + src_line_width;
  dest_increment = dest_line_width + dest_line_width;
  
  for( src_row = 0 ; src_row < src_active_height ; src_row++ )
  {
    src_line_ptr = src_ptr;
    dest_line_ptr = dest_ptr;
    for( src_col = 0 ; src_col < src_active_width ; src_col++ )
    {
      next_short_pixel  = ((*(unsigned char *)(src_line_ptr)) & 0xf8) << 8 ;
      src_line_ptr += 1;
      next_short_pixel |= ((*(unsigned char *)(src_line_ptr)) & 0xfc) << 3;
      src_line_ptr += 1;
      next_short_pixel |= ((*(unsigned char *)(src_line_ptr)) & 0xf8) >> 3;
      src_line_ptr += 1;
  
      *(unsigned short *)(dest_line_ptr) = next_short_pixel;
      dest_line_ptr += 2;
    }
    src_ptr += src_increment;
    dest_ptr += dest_increment;
  }
}


