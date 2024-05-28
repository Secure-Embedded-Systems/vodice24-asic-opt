#include "poly1305.h"
#include <stdio.h>

uint8_t key[32] = {0x85,0xd6,0xbe,0x78,0x57,0x55,0x6d,0x33,0x7f,0x44,0x52,0xfe,0x42,0xd5,0x06,0xa8,
		   0x01,0x03,0x80,0x8a,0xfb,0x0d,0xb2,0xfd,0x4a,0xbf,0xf6,0xaf,0x41,0x49,0xf5,0x1b};

uint8_t block1[16] = {0x43,0x72,0x79,0x70,0x74,0x6f,0x67,0x72,0x61,0x70,0x68,0x69,0x63,0x20,0x46,0x6f};
size_t  block1len  = 16;

uint8_t block2[16] = {0x72,0x75,0x6d,0x20,0x52,0x65,0x73,0x65,0x61,0x72,0x63,0x68,0x20,0x47,0x72,0x6f};
size_t  block2len  = 16;

uint8_t block3[16]  = {0x75,0x70};
size_t  block3len  = 2;

uint8_t tag[16];

void showBlock(const uint8_t *data, size_t length) {
  uint8_t n;
  for (n=0; n<length; n++) 
    printf("%x ", data[n]);
  printf("\n");  
}

void showPoly(const Poly1305Context *p) {
  uint8_t n;
  printf("R %8x %8x %8x %8x\n", p->r[0], p->r[1], p->r[2], p->r[3]);
  printf("S %8x %8x %8x %8x\n", p->s[0], p->s[1], p->s[2], p->s[3]);
  printf("A %lx %lx %lx %lx %lx %lx %lx %lx\n",
	 p->a[0], p->a[1], p->a[2], p->a[3],
	 p->a[4], p->a[5], p->a[6], p->a[7]);
  printf("A* %x %x %x %x %x\n",
	 (uint32_t) p->a[4],
	 (uint32_t) p->a[3],
	 (uint32_t) p->a[2],
	 (uint32_t) p->a[1],
	 (uint32_t) p->a[0]);
  printf("Buffer ");
  for (n=0; n<17; n++) 
    printf("%x ", p->buffer[n]);
  printf("\n");
  printf("Size %lx\n", p->size);
}

void main() {

  Poly1305Context c;

  printf("--key:\n");
  poly1305Init(&c, key);
  showPoly(&c);
  
  printf("--block1:\n");
  poly1305Update(&c, block1, block1len);
  showPoly(&c);
  
  printf("--block2:\n");
  poly1305Update(&c, block2, block2len);
  showPoly(&c);
  
  printf("--block3:\n");
  poly1305Update(&c, block3, block3len);
  showPoly(&c);
  
  printf("--final:\n");
  poly1305Final(&c, tag);
  showPoly(&c);

  showBlock(tag, 16);
}
