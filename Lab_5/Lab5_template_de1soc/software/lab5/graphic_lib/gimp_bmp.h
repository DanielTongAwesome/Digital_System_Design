#ifndef GIMP_BMP_H_
#define GIMP_BMP_H_

typedef struct gimp_image_struct{
  unsigned int   width;
  unsigned int   height;
  unsigned int   bytes_per_pixel; /* 3:RGB, 4:RGBA */ 
  unsigned char  pixel_data[];
} GimpImage;

typedef struct {            /* the structure for a bitmap. */
  short biWidth;
  short biHeight;
  short biBitCount;
  char *bicolor_palatte;
//  short *data;
  char *data;
} bitmap_struct;



int load_gimp_bmp( GimpImage *gimp_image, 
                    bitmap_struct *bmp, 
                    int output_bits_per_pixel );
                    
                    
void copy_pix_map_32_to_32(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );
                    
void copy_pix_map_32_to_24(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );

void copy_pix_map_32_to_16(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );
                    
void copy_pix_map_24_to_32(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );

void copy_pix_map_24_to_24(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );
                    
void copy_pix_map_24_to_16(
                    void *src_ptr,
                    long src_active_width,
                    long src_active_height,
                    long src_line_width,
                    void *dest_ptr,
                    long dest_line_width );
                    
#endif //GIMP_BMP_H_
