#ifndef POLY1305_H
#define POLY1305_H

#include <stdint.h>
#include <stddef.h>

typedef struct {
  uint32_t r[4];
  uint32_t s[4];
  uint64_t a[8];
  uint8_t buffer[17];
  size_t size;
} Poly1305Context;
  
//Poly1305 related functions
void poly1305Init(Poly1305Context *context, const uint8_t *key);
void poly1305Update(Poly1305Context *context, const void *data, size_t length);
void poly1305Final(Poly1305Context *context, uint8_t *tag);  
void poly1305ProcessBlock(Poly1305Context *context);

#endif
