#include<stdint.h>
#include<stddef.h>
#include<stdlib.h>

#include<lua.h>
#include<lualib.h>
#include<lauxlib.h>

/* hex_encode encodes a string as hex digits */
static int hex_encode(lua_State *L) {
	size_t len;
	const char *in = luaL_checklstring(L, 1, &len); 

	luaL_Buffer buff;
	luaL_buffinit(L, &buff);

	size_t outsz = len * 2; 
	char *out = luaL_prepbuffsize(&buff, outsz);

	while(len--) {
		uint8_t val = *in++;
		char c1 = ((val >> 4) & 0xF);
		c1 += (c1 > 9) ? ('a' - 10) : '0';
		char c2 = (val & 0xF);
		c2 += (c2 > 9) ? ('a' - 10) : '0';
		*out++ = c1;  *out++ = c2;
	}
	luaL_addsize(&buff, outsz);
	luaL_pushresult(&buff);
	return 1;
}

static inline uint8_t hex_decode_1(char c) {
	uint8_t ans = c - '0';
	return (ans < 10)?ans:(c - 'a' + 10);
}

/* hex_decode decodes a string of hex digits into binary */
static int hex_decode(lua_State *L) {
	size_t len;
	const char *in = luaL_checklstring(L, 1, &len); 
	if((len&1) != 0) {
		luaL_pushfail(L);
		lua_pushstring(L,"hex-encoded string must be even length!");
		return 2;
	}

	luaL_Buffer buff;
	luaL_buffinit(L, &buff);

	size_t outsz = len / 2; 
	char *out = luaL_prepbuffsize(&buff, outsz);

	while(len) {
		uint8_t p1 = hex_decode_1(*in++);
		if(p1 > 0xF) goto fail;
		uint8_t p2 = hex_decode_1(*in++);
		if(p2 > 0xF) goto fail;
		*out++ = (uint8_t)((p1 << 4) | p2);
		len -= 2;
	}
	luaL_addsize(&buff, outsz);
	luaL_pushresult(&buff);
	return 1;
fail:
	luaL_pushfail(L);
	lua_pushstring(L,"invalid hex format!");
	return 2;
}

/* base64_encode allocates a buffer and encodes the given string in base64.
 */
static int b64_encode(lua_State *L) {
	static const char letters[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	size_t len;
	const char *in = luaL_checklstring(L, 1, &len); 

	luaL_Buffer buff;
	luaL_buffinit(L, &buff);

	size_t outsz = (len + 2) / 3 * 4; 
	char *out = luaL_prepbuffsize(&buff, outsz);

	char remainder;  /* temp var for leftover bits during processing */
	while(len >= 3) {
		*out++ = letters[((*in)>>2) & 63];     /* top 6 bits */
		remainder = (*in++ & 3); 
		*out++ = letters[(remainder << 4) | (((*in)>>4) & 15)];   /* bottom 2 bits plus top 4 bits */
		remainder = (*in++ & 15);
		*out++ = letters[(remainder << 2) | (((*in)>>6) & 3)];    /* bottom 4 bits plus top 2 bits */
		*out++ = letters[(*in++ & 63)];
		len -= 3;
	}

	switch(len) {
	case 0:
		break;
	case 1:
		*out++ = letters[((*in)>>2) & 63];     /* top 6 bits */
		*out++ = letters[((*in)&3) << 4];      /* bottom 2 bits plus zero bits */
		*out++ = '=';
		*out++ = '=';
		break;
	case 2:
		*out++ = letters[((*in)>>2) & 63];     /* top 6 bits */
		remainder = (*in++ & 3); 
		*out++ = letters[(remainder << 4) | (((*in)>>4) & 15)];   /* bottom 2 bits plus top 4 bits */
		*out++ = letters[(*in & 15) << 2];  /* bottom 4 bits  plus zero bits */
		*out++ = '=';
	}

	luaL_addsize(&buff, outsz);
	luaL_pushresult(&buff);
	return 1;
}

static inline uint8_t b64_decode_1(char ch) {
	if(ch >= 'A' && ch <= 'Z')
		return (uint8_t)(ch - 'A');
	if(ch >= 'a' && ch <= 'z')
		return 26 + (uint8_t)(ch - 'a');
	if(ch >= '0' && ch <= '9')
		return 52 + (uint8_t)(ch - '0');
	if(ch == '+') return 62;
	if(ch == '/') return 63;
	return 64;  /* error case! */
}

/* b64_decode allocates a buffer and encodes the given string in base64.
 */
static int b64_decode(lua_State *L) {

	size_t len;
	const char *in = luaL_checklstring(L, 1, &len); 
	if((len&3) != 0) {
		luaL_pushfail(L);
		lua_pushstring(L,"base64-encoded string must be multiple of 4 in length!");
		return 2;
	}
	size_t outsz = len / 4 * 3;
	if(in[len-2] == '=') outsz -= 2;
	else if(in[len-1] == '=') outsz -= 1;

	luaL_Buffer buff;
	luaL_buffinit(L, &buff);
	char *out = luaL_prepbuffsize(&buff, outsz);
	size_t remaining = outsz;

	uint8_t ch0, ch1, ch2, ch3;
	while(remaining >= 3) {
		ch0 = b64_decode_1(in[0]);
		ch1 = b64_decode_1(in[1]);
		ch2 = b64_decode_1(in[2]);
		ch3 = b64_decode_1(in[3]);
		if(((ch0|ch1|ch2|ch3)&64) != 0) goto fail;
		*out++ = (ch0 << 2) | ((ch1 >> 4) & 0x3);
		*out++ = ((ch1 & 0xF) << 4) | ((ch2 >> 2) & 0xF);
		*out++ = ((ch2 & 0x3) << 6) | ch3;
		in += 4;
		remaining -= 3;
	}
	switch(remaining) {
		case 1: 
			ch0 = b64_decode_1(in[0]); 
			ch1 = b64_decode_1(in[1]); 
			if(((ch0|ch1)&64) != 0) goto fail;
			*out = (ch0 << 2)|((ch1 >> 4) & 0x3);
			break;
		case 2:
			ch0 = b64_decode_1(in[0]); 
			ch1 = b64_decode_1(in[1]);
			ch2 = b64_decode_1(in[2]);
			if(((ch0|ch1|ch2)&64) != 0) goto fail;
			*out++ = (ch0 << 2)|((ch1 >> 4) & 0x3);
			*out++ = ((ch1 & 0xF) << 4)|((ch2 >> 2) & 0xF);
			break;
	}
	luaL_addsize(&buff, outsz);
	luaL_pushresult(&buff);
	return 1;
fail:
	luaL_pushfail(L);
	lua_pushstring(L,"invalid base64 format!");
	return 2;
}

static const struct luaL_Reg btextlib[] = { 
  {"b64_encode", b64_encode},
  {"b64_decode", b64_decode},
  {"hex_encode", hex_encode},
  {"hex_decode", hex_decode},
  {NULL, NULL}
};

int luaopen_bintext(lua_State *L) { 
   luaL_newlib(L, btextlib); 
   return 1; 
}
