
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/param.h"

#define BUF_SIZE 512

int main(int argc, char *argv[]) {
   0:	c9010113          	addi	sp,sp,-880
   4:	36113423          	sd	ra,872(sp)
   8:	36813023          	sd	s0,864(sp)
   c:	34913c23          	sd	s1,856(sp)
  10:	35213823          	sd	s2,848(sp)
  14:	35313423          	sd	s3,840(sp)
  18:	35413023          	sd	s4,832(sp)
  1c:	33513c23          	sd	s5,824(sp)
  20:	33613823          	sd	s6,816(sp)
  24:	33713423          	sd	s7,808(sp)
  28:	33813023          	sd	s8,800(sp)
  2c:	31913c23          	sd	s9,792(sp)
  30:	1e80                	addi	s0,sp,880
    char ch;
    int read_bytes, has_arg = 0, child_pid;

    // Copy command arguments, but ignore `-n 1`
    int base_argc = 0;
    for (int i = 1; i < argc; i++) {
  32:	4785                	li	a5,1
  34:	08a7de63          	bge	a5,a0,d0 <main+0xd0>
  38:	8aaa                	mv	s5,a0
  3a:	8b2e                	mv	s6,a1
  3c:	4485                	li	s1,1
    int base_argc = 0;
  3e:	4901                	li	s2,0
        if (strcmp(argv[i], "-n") == 0 && i + 1 < argc && strcmp(argv[i + 1], "1") == 0) {
  40:	00001b97          	auipc	s7,0x1
  44:	a00b8b93          	addi	s7,s7,-1536 # a40 <malloc+0x100>
  48:	00001c17          	auipc	s8,0x1
  4c:	a00c0c13          	addi	s8,s8,-1536 # a48 <malloc+0x108>
  50:	a821                	j	68 <main+0x68>
            i++;  // Skip "-n 1"
            continue;
        }
        x_argv[base_argc++] = argv[i];
  52:	00391793          	slli	a5,s2,0x3
  56:	fa078793          	addi	a5,a5,-96
  5a:	97a2                	add	a5,a5,s0
  5c:	d137b023          	sd	s3,-768(a5)
  60:	2905                	addiw	s2,s2,1
    for (int i = 1; i < argc; i++) {
  62:	2485                	addiw	s1,s1,1
  64:	0354da63          	bge	s1,s5,98 <main+0x98>
        if (strcmp(argv[i], "-n") == 0 && i + 1 < argc && strcmp(argv[i + 1], "1") == 0) {
  68:	00349a13          	slli	s4,s1,0x3
  6c:	014b07b3          	add	a5,s6,s4
  70:	0007b983          	ld	s3,0(a5)
  74:	85de                	mv	a1,s7
  76:	854e                	mv	a0,s3
  78:	1c0000ef          	jal	238 <strcmp>
  7c:	f979                	bnez	a0,52 <main+0x52>
  7e:	00148c9b          	addiw	s9,s1,1
  82:	fd5cd8e3          	bge	s9,s5,52 <main+0x52>
  86:	9a5a                	add	s4,s4,s6
  88:	85e2                	mv	a1,s8
  8a:	008a3503          	ld	a0,8(s4)
  8e:	1aa000ef          	jal	238 <strcmp>
  92:	f161                	bnez	a0,52 <main+0x52>
            i++;  // Skip "-n 1"
  94:	84e6                	mv	s1,s9
  96:	b7f1                	j	62 <main+0x62>
    }
    
    if (base_argc == 0) {
  98:	02090c63          	beqz	s2,d0 <main+0xd0>
        fprintf(2, "xargs: missing command\n");
        exit(1);
    }

    x_argv[base_argc] = 0;  // Null-terminate argument list
  9c:	00391793          	slli	a5,s2,0x3
  a0:	fa078793          	addi	a5,a5,-96
  a4:	97a2                	add	a5,a5,s0
  a6:	d007b023          	sd	zero,-768(a5)
    int read_bytes, has_arg = 0, child_pid;
  aa:	4a01                	li	s4,0

    arg_s = arg_e = buf;
  ac:	da040493          	addi	s1,s0,-608

    while ((read_bytes = read(0, &ch, sizeof(char))) == 1) {
        if (arg_e >= buf + BUF_SIZE - 1) {
  b0:	f9f40993          	addi	s3,s0,-97
        if (ch == '\n' || ch == ' ') {  
            if (has_arg) {  
                *arg_e = '\0';  // Null-terminate argument
                
                // Prepare command arguments
                x_argv[base_argc] = arg_s;
  b4:	00391b13          	slli	s6,s2,0x3
  b8:	fa0b0793          	addi	a5,s6,-96
  bc:	00878b33          	add	s6,a5,s0
                x_argv[base_argc + 1] = 0;  // Null-terminate
  c0:	00190a9b          	addiw	s5,s2,1
  c4:	0a8e                	slli	s5,s5,0x3
  c6:	fa0a8793          	addi	a5,s5,-96
  ca:	00878ab3          	add	s5,a5,s0
    while ((read_bytes = read(0, &ch, sizeof(char))) == 1) {
  ce:	a80d                	j	100 <main+0x100>
        fprintf(2, "xargs: missing command\n");
  d0:	00001597          	auipc	a1,0x1
  d4:	98058593          	addi	a1,a1,-1664 # a50 <malloc+0x110>
  d8:	4509                	li	a0,2
  da:	788000ef          	jal	862 <fprintf>
        exit(1);
  de:	4505                	li	a0,1
  e0:	394000ef          	jal	474 <exit>
            fprintf(2, "xargs: argument too long\n");
  e4:	00001597          	auipc	a1,0x1
  e8:	98458593          	addi	a1,a1,-1660 # a68 <malloc+0x128>
  ec:	4509                	li	a0,2
  ee:	774000ef          	jal	862 <fprintf>
            arg_s = arg_e = buf;  // Reset buffer
  f2:	da040493          	addi	s1,s0,-608
            continue;
  f6:	a029                	j	100 <main+0x100>
            if (has_arg) {  
  f8:	020a1d63          	bnez	s4,132 <main+0x132>
                }

                has_arg = 0;
                wait(0);  // Wait for process
            }
            arg_s = arg_e = buf;  // Reset buffer
  fc:	da040493          	addi	s1,s0,-608
    while ((read_bytes = read(0, &ch, sizeof(char))) == 1) {
 100:	4605                	li	a2,1
 102:	c9f40593          	addi	a1,s0,-865
 106:	4501                	li	a0,0
 108:	384000ef          	jal	48c <read>
 10c:	4785                	li	a5,1
 10e:	08f51263          	bne	a0,a5,192 <main+0x192>
        if (arg_e >= buf + BUF_SIZE - 1) {
 112:	fd34f9e3          	bgeu	s1,s3,e4 <main+0xe4>
        if (ch == '\n' || ch == ' ') {  
 116:	c9f44783          	lbu	a5,-865(s0)
 11a:	4729                	li	a4,10
 11c:	fce78ee3          	beq	a5,a4,f8 <main+0xf8>
 120:	02000713          	li	a4,32
 124:	fce78ae3          	beq	a5,a4,f8 <main+0xf8>
        } else {
            *arg_e++ = ch;
 128:	00f48023          	sb	a5,0(s1)
            has_arg = 1;
 12c:	8a2a                	mv	s4,a0
            *arg_e++ = ch;
 12e:	0485                	addi	s1,s1,1
 130:	bfc1                	j	100 <main+0x100>
                *arg_e = '\0';  // Null-terminate argument
 132:	00048023          	sb	zero,0(s1)
                x_argv[base_argc] = arg_s;
 136:	da040793          	addi	a5,s0,-608
 13a:	d0fb3023          	sd	a5,-768(s6)
                x_argv[base_argc + 1] = 0;  // Null-terminate
 13e:	d00ab023          	sd	zero,-768(s5)
                if ((child_pid = fork()) < 0) {
 142:	32a000ef          	jal	46c <fork>
 146:	00054a63          	bltz	a0,15a <main+0x15a>
                } else if (child_pid == 0) {
 14a:	c115                	beqz	a0,16e <main+0x16e>
                wait(0);  // Wait for process
 14c:	4501                	li	a0,0
 14e:	32e000ef          	jal	47c <wait>
                has_arg = 0;
 152:	4a01                	li	s4,0
            arg_s = arg_e = buf;  // Reset buffer
 154:	da040493          	addi	s1,s0,-608
 158:	b765                	j	100 <main+0x100>
                    fprintf(2, "xargs: fork failed\n");
 15a:	00001597          	auipc	a1,0x1
 15e:	92e58593          	addi	a1,a1,-1746 # a88 <malloc+0x148>
 162:	4509                	li	a0,2
 164:	6fe000ef          	jal	862 <fprintf>
                    exit(1);
 168:	4505                	li	a0,1
 16a:	30a000ef          	jal	474 <exit>
                    exec(x_argv[0], x_argv);
 16e:	ca040593          	addi	a1,s0,-864
 172:	ca043503          	ld	a0,-864(s0)
 176:	336000ef          	jal	4ac <exec>
                    fprintf(2, "xargs: exec failed (command: %s)\n", x_argv[0]);
 17a:	ca043603          	ld	a2,-864(s0)
 17e:	00001597          	auipc	a1,0x1
 182:	92258593          	addi	a1,a1,-1758 # aa0 <malloc+0x160>
 186:	4509                	li	a0,2
 188:	6da000ef          	jal	862 <fprintf>
                    exit(1);
 18c:	4505                	li	a0,1
 18e:	2e6000ef          	jal	474 <exit>
        }
    }

    // Handle last argument if input doesn't end with newline
    if (has_arg) {
 192:	060a0963          	beqz	s4,204 <main+0x204>
        *arg_e = '\0';
 196:	00048023          	sb	zero,0(s1)

        x_argv[base_argc] = arg_s;
 19a:	00391793          	slli	a5,s2,0x3
 19e:	fa078793          	addi	a5,a5,-96
 1a2:	97a2                	add	a5,a5,s0
 1a4:	da040713          	addi	a4,s0,-608
 1a8:	d0e7b023          	sd	a4,-768(a5)
        x_argv[base_argc + 1] = 0;
 1ac:	0019079b          	addiw	a5,s2,1
 1b0:	078e                	slli	a5,a5,0x3
 1b2:	fa078793          	addi	a5,a5,-96
 1b6:	97a2                	add	a5,a5,s0
 1b8:	d007b023          	sd	zero,-768(a5)

        if ((child_pid = fork()) < 0) {
 1bc:	2b0000ef          	jal	46c <fork>
 1c0:	02054563          	bltz	a0,1ea <main+0x1ea>
            fprintf(2, "xargs: fork failed\n");
            exit(1);
        } else if (child_pid == 0) {
 1c4:	ed0d                	bnez	a0,1fe <main+0x1fe>
            exec(x_argv[0], x_argv);
 1c6:	ca040593          	addi	a1,s0,-864
 1ca:	ca043503          	ld	a0,-864(s0)
 1ce:	2de000ef          	jal	4ac <exec>
            fprintf(2, "xargs: exec failed (command: %s)\n", x_argv[0]);
 1d2:	ca043603          	ld	a2,-864(s0)
 1d6:	00001597          	auipc	a1,0x1
 1da:	8ca58593          	addi	a1,a1,-1846 # aa0 <malloc+0x160>
 1de:	4509                	li	a0,2
 1e0:	682000ef          	jal	862 <fprintf>
            exit(1);
 1e4:	4505                	li	a0,1
 1e6:	28e000ef          	jal	474 <exit>
            fprintf(2, "xargs: fork failed\n");
 1ea:	00001597          	auipc	a1,0x1
 1ee:	89e58593          	addi	a1,a1,-1890 # a88 <malloc+0x148>
 1f2:	4509                	li	a0,2
 1f4:	66e000ef          	jal	862 <fprintf>
            exit(1);
 1f8:	4505                	li	a0,1
 1fa:	27a000ef          	jal	474 <exit>
        }
        wait(0);
 1fe:	4501                	li	a0,0
 200:	27c000ef          	jal	47c <wait>
    }

    exit(0);
 204:	4501                	li	a0,0
 206:	26e000ef          	jal	474 <exit>

000000000000020a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
  extern int main();
  main();
 212:	defff0ef          	jal	0 <main>
  exit(0);
 216:	4501                	li	a0,0
 218:	25c000ef          	jal	474 <exit>

000000000000021c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 222:	87aa                	mv	a5,a0
 224:	0585                	addi	a1,a1,1
 226:	0785                	addi	a5,a5,1
 228:	fff5c703          	lbu	a4,-1(a1)
 22c:	fee78fa3          	sb	a4,-1(a5)
 230:	fb75                	bnez	a4,224 <strcpy+0x8>
    ;
  return os;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb91                	beqz	a5,256 <strcmp+0x1e>
 244:	0005c703          	lbu	a4,0(a1)
 248:	00f71763          	bne	a4,a5,256 <strcmp+0x1e>
    p++, q++;
 24c:	0505                	addi	a0,a0,1
 24e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 250:	00054783          	lbu	a5,0(a0)
 254:	fbe5                	bnez	a5,244 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 256:	0005c503          	lbu	a0,0(a1)
}
 25a:	40a7853b          	subw	a0,a5,a0
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strlen>:

uint
strlen(const char *s)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cf91                	beqz	a5,28a <strlen+0x26>
 270:	0505                	addi	a0,a0,1
 272:	87aa                	mv	a5,a0
 274:	86be                	mv	a3,a5
 276:	0785                	addi	a5,a5,1
 278:	fff7c703          	lbu	a4,-1(a5)
 27c:	ff65                	bnez	a4,274 <strlen+0x10>
 27e:	40a6853b          	subw	a0,a3,a0
 282:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  for(n = 0; s[n]; n++)
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <strlen+0x20>

000000000000028e <memset>:

void*
memset(void *dst, int c, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 294:	ca19                	beqz	a2,2aa <memset+0x1c>
 296:	87aa                	mv	a5,a0
 298:	1602                	slli	a2,a2,0x20
 29a:	9201                	srli	a2,a2,0x20
 29c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a4:	0785                	addi	a5,a5,1
 2a6:	fee79de3          	bne	a5,a4,2a0 <memset+0x12>
  }
  return dst;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	cb99                	beqz	a5,2d0 <strchr+0x20>
    if(*s == c)
 2bc:	00f58763          	beq	a1,a5,2ca <strchr+0x1a>
  for(; *s; s++)
 2c0:	0505                	addi	a0,a0,1
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	fbfd                	bnez	a5,2bc <strchr+0xc>
      return (char*)s;
  return 0;
 2c8:	4501                	li	a0,0
}
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfe5                	j	2ca <strchr+0x1a>

00000000000002d4 <gets>:

char*
gets(char *buf, int max)
{
 2d4:	711d                	addi	sp,sp,-96
 2d6:	ec86                	sd	ra,88(sp)
 2d8:	e8a2                	sd	s0,80(sp)
 2da:	e4a6                	sd	s1,72(sp)
 2dc:	e0ca                	sd	s2,64(sp)
 2de:	fc4e                	sd	s3,56(sp)
 2e0:	f852                	sd	s4,48(sp)
 2e2:	f456                	sd	s5,40(sp)
 2e4:	f05a                	sd	s6,32(sp)
 2e6:	ec5e                	sd	s7,24(sp)
 2e8:	1080                	addi	s0,sp,96
 2ea:	8baa                	mv	s7,a0
 2ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ee:	892a                	mv	s2,a0
 2f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f2:	4aa9                	li	s5,10
 2f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f6:	89a6                	mv	s3,s1
 2f8:	2485                	addiw	s1,s1,1
 2fa:	0344d663          	bge	s1,s4,326 <gets+0x52>
    cc = read(0, &c, 1);
 2fe:	4605                	li	a2,1
 300:	faf40593          	addi	a1,s0,-81
 304:	4501                	li	a0,0
 306:	186000ef          	jal	48c <read>
    if(cc < 1)
 30a:	00a05e63          	blez	a0,326 <gets+0x52>
    buf[i++] = c;
 30e:	faf44783          	lbu	a5,-81(s0)
 312:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 316:	01578763          	beq	a5,s5,324 <gets+0x50>
 31a:	0905                	addi	s2,s2,1
 31c:	fd679de3          	bne	a5,s6,2f6 <gets+0x22>
    buf[i++] = c;
 320:	89a6                	mv	s3,s1
 322:	a011                	j	326 <gets+0x52>
 324:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 326:	99de                	add	s3,s3,s7
 328:	00098023          	sb	zero,0(s3)
  return buf;
}
 32c:	855e                	mv	a0,s7
 32e:	60e6                	ld	ra,88(sp)
 330:	6446                	ld	s0,80(sp)
 332:	64a6                	ld	s1,72(sp)
 334:	6906                	ld	s2,64(sp)
 336:	79e2                	ld	s3,56(sp)
 338:	7a42                	ld	s4,48(sp)
 33a:	7aa2                	ld	s5,40(sp)
 33c:	7b02                	ld	s6,32(sp)
 33e:	6be2                	ld	s7,24(sp)
 340:	6125                	addi	sp,sp,96
 342:	8082                	ret

0000000000000344 <stat>:

int
stat(const char *n, struct stat *st)
{
 344:	1101                	addi	sp,sp,-32
 346:	ec06                	sd	ra,24(sp)
 348:	e822                	sd	s0,16(sp)
 34a:	e04a                	sd	s2,0(sp)
 34c:	1000                	addi	s0,sp,32
 34e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 350:	4581                	li	a1,0
 352:	162000ef          	jal	4b4 <open>
  if(fd < 0)
 356:	02054263          	bltz	a0,37a <stat+0x36>
 35a:	e426                	sd	s1,8(sp)
 35c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 35e:	85ca                	mv	a1,s2
 360:	16c000ef          	jal	4cc <fstat>
 364:	892a                	mv	s2,a0
  close(fd);
 366:	8526                	mv	a0,s1
 368:	134000ef          	jal	49c <close>
  return r;
 36c:	64a2                	ld	s1,8(sp)
}
 36e:	854a                	mv	a0,s2
 370:	60e2                	ld	ra,24(sp)
 372:	6442                	ld	s0,16(sp)
 374:	6902                	ld	s2,0(sp)
 376:	6105                	addi	sp,sp,32
 378:	8082                	ret
    return -1;
 37a:	597d                	li	s2,-1
 37c:	bfcd                	j	36e <stat+0x2a>

000000000000037e <atoi>:

int
atoi(const char *s)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 384:	00054683          	lbu	a3,0(a0)
 388:	fd06879b          	addiw	a5,a3,-48
 38c:	0ff7f793          	zext.b	a5,a5
 390:	4625                	li	a2,9
 392:	02f66863          	bltu	a2,a5,3c2 <atoi+0x44>
 396:	872a                	mv	a4,a0
  n = 0;
 398:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 39a:	0705                	addi	a4,a4,1
 39c:	0025179b          	slliw	a5,a0,0x2
 3a0:	9fa9                	addw	a5,a5,a0
 3a2:	0017979b          	slliw	a5,a5,0x1
 3a6:	9fb5                	addw	a5,a5,a3
 3a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ac:	00074683          	lbu	a3,0(a4)
 3b0:	fd06879b          	addiw	a5,a3,-48
 3b4:	0ff7f793          	zext.b	a5,a5
 3b8:	fef671e3          	bgeu	a2,a5,39a <atoi+0x1c>
  return n;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
  n = 0;
 3c2:	4501                	li	a0,0
 3c4:	bfe5                	j	3bc <atoi+0x3e>

00000000000003c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3cc:	02b57463          	bgeu	a0,a1,3f4 <memmove+0x2e>
    while(n-- > 0)
 3d0:	00c05f63          	blez	a2,3ee <memmove+0x28>
 3d4:	1602                	slli	a2,a2,0x20
 3d6:	9201                	srli	a2,a2,0x20
 3d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 3de:	0585                	addi	a1,a1,1
 3e0:	0705                	addi	a4,a4,1
 3e2:	fff5c683          	lbu	a3,-1(a1)
 3e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ea:	fef71ae3          	bne	a4,a5,3de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
    dst += n;
 3f4:	00c50733          	add	a4,a0,a2
    src += n;
 3f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3fa:	fec05ae3          	blez	a2,3ee <memmove+0x28>
 3fe:	fff6079b          	addiw	a5,a2,-1
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	fff7c793          	not	a5,a5
 40a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 40c:	15fd                	addi	a1,a1,-1
 40e:	177d                	addi	a4,a4,-1
 410:	0005c683          	lbu	a3,0(a1)
 414:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 418:	fee79ae3          	bne	a5,a4,40c <memmove+0x46>
 41c:	bfc9                	j	3ee <memmove+0x28>

000000000000041e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 424:	ca05                	beqz	a2,454 <memcmp+0x36>
 426:	fff6069b          	addiw	a3,a2,-1
 42a:	1682                	slli	a3,a3,0x20
 42c:	9281                	srli	a3,a3,0x20
 42e:	0685                	addi	a3,a3,1
 430:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 432:	00054783          	lbu	a5,0(a0)
 436:	0005c703          	lbu	a4,0(a1)
 43a:	00e79863          	bne	a5,a4,44a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 43e:	0505                	addi	a0,a0,1
    p2++;
 440:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 442:	fed518e3          	bne	a0,a3,432 <memcmp+0x14>
  }
  return 0;
 446:	4501                	li	a0,0
 448:	a019                	j	44e <memcmp+0x30>
      return *p1 - *p2;
 44a:	40e7853b          	subw	a0,a5,a4
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  return 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <memcmp+0x30>

0000000000000458 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e406                	sd	ra,8(sp)
 45c:	e022                	sd	s0,0(sp)
 45e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 460:	f67ff0ef          	jal	3c6 <memmove>
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret

000000000000046c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 46c:	4885                	li	a7,1
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <exit>:
.global exit
exit:
 li a7, SYS_exit
 474:	4889                	li	a7,2
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <wait>:
.global wait
wait:
 li a7, SYS_wait
 47c:	488d                	li	a7,3
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 484:	4891                	li	a7,4
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <read>:
.global read
read:
 li a7, SYS_read
 48c:	4895                	li	a7,5
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <write>:
.global write
write:
 li a7, SYS_write
 494:	48c1                	li	a7,16
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <close>:
.global close
close:
 li a7, SYS_close
 49c:	48d5                	li	a7,21
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a4:	4899                	li	a7,6
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ac:	489d                	li	a7,7
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <open>:
.global open
open:
 li a7, SYS_open
 4b4:	48bd                	li	a7,15
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4bc:	48c5                	li	a7,17
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c4:	48c9                	li	a7,18
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4cc:	48a1                	li	a7,8
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <link>:
.global link
link:
 li a7, SYS_link
 4d4:	48cd                	li	a7,19
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4dc:	48d1                	li	a7,20
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e4:	48a5                	li	a7,9
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ec:	48a9                	li	a7,10
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f4:	48ad                	li	a7,11
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4fc:	48b1                	li	a7,12
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 504:	48b5                	li	a7,13
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 50c:	48b9                	li	a7,14
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 514:	1101                	addi	sp,sp,-32
 516:	ec06                	sd	ra,24(sp)
 518:	e822                	sd	s0,16(sp)
 51a:	1000                	addi	s0,sp,32
 51c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 520:	4605                	li	a2,1
 522:	fef40593          	addi	a1,s0,-17
 526:	f6fff0ef          	jal	494 <write>
}
 52a:	60e2                	ld	ra,24(sp)
 52c:	6442                	ld	s0,16(sp)
 52e:	6105                	addi	sp,sp,32
 530:	8082                	ret

0000000000000532 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 532:	7139                	addi	sp,sp,-64
 534:	fc06                	sd	ra,56(sp)
 536:	f822                	sd	s0,48(sp)
 538:	f426                	sd	s1,40(sp)
 53a:	0080                	addi	s0,sp,64
 53c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53e:	c299                	beqz	a3,544 <printint+0x12>
 540:	0805c963          	bltz	a1,5d2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 544:	2581                	sext.w	a1,a1
  neg = 0;
 546:	4881                	li	a7,0
 548:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54e:	2601                	sext.w	a2,a2
 550:	00000517          	auipc	a0,0x0
 554:	58050513          	addi	a0,a0,1408 # ad0 <digits>
 558:	883a                	mv	a6,a4
 55a:	2705                	addiw	a4,a4,1
 55c:	02c5f7bb          	remuw	a5,a1,a2
 560:	1782                	slli	a5,a5,0x20
 562:	9381                	srli	a5,a5,0x20
 564:	97aa                	add	a5,a5,a0
 566:	0007c783          	lbu	a5,0(a5)
 56a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56e:	0005879b          	sext.w	a5,a1
 572:	02c5d5bb          	divuw	a1,a1,a2
 576:	0685                	addi	a3,a3,1
 578:	fec7f0e3          	bgeu	a5,a2,558 <printint+0x26>
  if(neg)
 57c:	00088c63          	beqz	a7,594 <printint+0x62>
    buf[i++] = '-';
 580:	fd070793          	addi	a5,a4,-48
 584:	00878733          	add	a4,a5,s0
 588:	02d00793          	li	a5,45
 58c:	fef70823          	sb	a5,-16(a4)
 590:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 594:	02e05a63          	blez	a4,5c8 <printint+0x96>
 598:	f04a                	sd	s2,32(sp)
 59a:	ec4e                	sd	s3,24(sp)
 59c:	fc040793          	addi	a5,s0,-64
 5a0:	00e78933          	add	s2,a5,a4
 5a4:	fff78993          	addi	s3,a5,-1
 5a8:	99ba                	add	s3,s3,a4
 5aa:	377d                	addiw	a4,a4,-1
 5ac:	1702                	slli	a4,a4,0x20
 5ae:	9301                	srli	a4,a4,0x20
 5b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b4:	fff94583          	lbu	a1,-1(s2)
 5b8:	8526                	mv	a0,s1
 5ba:	f5bff0ef          	jal	514 <putc>
  while(--i >= 0)
 5be:	197d                	addi	s2,s2,-1
 5c0:	ff391ae3          	bne	s2,s3,5b4 <printint+0x82>
 5c4:	7902                	ld	s2,32(sp)
 5c6:	69e2                	ld	s3,24(sp)
}
 5c8:	70e2                	ld	ra,56(sp)
 5ca:	7442                	ld	s0,48(sp)
 5cc:	74a2                	ld	s1,40(sp)
 5ce:	6121                	addi	sp,sp,64
 5d0:	8082                	ret
    x = -xx;
 5d2:	40b005bb          	negw	a1,a1
    neg = 1;
 5d6:	4885                	li	a7,1
    x = -xx;
 5d8:	bf85                	j	548 <printint+0x16>

00000000000005da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5da:	711d                	addi	sp,sp,-96
 5dc:	ec86                	sd	ra,88(sp)
 5de:	e8a2                	sd	s0,80(sp)
 5e0:	e0ca                	sd	s2,64(sp)
 5e2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e4:	0005c903          	lbu	s2,0(a1)
 5e8:	26090863          	beqz	s2,858 <vprintf+0x27e>
 5ec:	e4a6                	sd	s1,72(sp)
 5ee:	fc4e                	sd	s3,56(sp)
 5f0:	f852                	sd	s4,48(sp)
 5f2:	f456                	sd	s5,40(sp)
 5f4:	f05a                	sd	s6,32(sp)
 5f6:	ec5e                	sd	s7,24(sp)
 5f8:	e862                	sd	s8,16(sp)
 5fa:	e466                	sd	s9,8(sp)
 5fc:	8b2a                	mv	s6,a0
 5fe:	8a2e                	mv	s4,a1
 600:	8bb2                	mv	s7,a2
  state = 0;
 602:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 604:	4481                	li	s1,0
 606:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 608:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 60c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 610:	06c00c93          	li	s9,108
 614:	a005                	j	634 <vprintf+0x5a>
        putc(fd, c0);
 616:	85ca                	mv	a1,s2
 618:	855a                	mv	a0,s6
 61a:	efbff0ef          	jal	514 <putc>
 61e:	a019                	j	624 <vprintf+0x4a>
    } else if(state == '%'){
 620:	03598263          	beq	s3,s5,644 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 624:	2485                	addiw	s1,s1,1
 626:	8726                	mv	a4,s1
 628:	009a07b3          	add	a5,s4,s1
 62c:	0007c903          	lbu	s2,0(a5)
 630:	20090c63          	beqz	s2,848 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 634:	0009079b          	sext.w	a5,s2
    if(state == 0){
 638:	fe0994e3          	bnez	s3,620 <vprintf+0x46>
      if(c0 == '%'){
 63c:	fd579de3          	bne	a5,s5,616 <vprintf+0x3c>
        state = '%';
 640:	89be                	mv	s3,a5
 642:	b7cd                	j	624 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 644:	00ea06b3          	add	a3,s4,a4
 648:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 64c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 64e:	c681                	beqz	a3,656 <vprintf+0x7c>
 650:	9752                	add	a4,a4,s4
 652:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 656:	03878f63          	beq	a5,s8,694 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 65a:	05978963          	beq	a5,s9,6ac <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 65e:	07500713          	li	a4,117
 662:	0ee78363          	beq	a5,a4,748 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 666:	07800713          	li	a4,120
 66a:	12e78563          	beq	a5,a4,794 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 66e:	07000713          	li	a4,112
 672:	14e78a63          	beq	a5,a4,7c6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 676:	07300713          	li	a4,115
 67a:	18e78a63          	beq	a5,a4,80e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 67e:	02500713          	li	a4,37
 682:	04e79563          	bne	a5,a4,6cc <vprintf+0xf2>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	855a                	mv	a0,s6
 68c:	e89ff0ef          	jal	514 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 690:	4981                	li	s3,0
 692:	bf49                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 694:	008b8913          	addi	s2,s7,8
 698:	4685                	li	a3,1
 69a:	4629                	li	a2,10
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	e91ff0ef          	jal	532 <printint>
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bfad                	j	624 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	06400793          	li	a5,100
 6b0:	02f68963          	beq	a3,a5,6e2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b4:	06c00793          	li	a5,108
 6b8:	04f68263          	beq	a3,a5,6fc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6bc:	07500793          	li	a5,117
 6c0:	0af68063          	beq	a3,a5,760 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6c4:	07800793          	li	a5,120
 6c8:	0ef68263          	beq	a3,a5,7ac <vprintf+0x1d2>
        putc(fd, '%');
 6cc:	02500593          	li	a1,37
 6d0:	855a                	mv	a0,s6
 6d2:	e43ff0ef          	jal	514 <putc>
        putc(fd, c0);
 6d6:	85ca                	mv	a1,s2
 6d8:	855a                	mv	a0,s6
 6da:	e3bff0ef          	jal	514 <putc>
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b791                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4685                	li	a3,1
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	e43ff0ef          	jal	532 <printint>
        i += 1;
 6f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
        i += 1;
 6fa:	b72d                	j	624 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6fc:	06400793          	li	a5,100
 700:	02f60763          	beq	a2,a5,72e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 704:	07500793          	li	a5,117
 708:	06f60963          	beq	a2,a5,77a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 70c:	07800793          	li	a5,120
 710:	faf61ee3          	bne	a2,a5,6cc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 714:	008b8913          	addi	s2,s7,8
 718:	4681                	li	a3,0
 71a:	4641                	li	a2,16
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e11ff0ef          	jal	532 <printint>
        i += 2;
 726:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 2;
 72c:	bde5                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72e:	008b8913          	addi	s2,s7,8
 732:	4685                	li	a3,1
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	df7ff0ef          	jal	532 <printint>
        i += 2;
 740:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
        i += 2;
 746:	bdf9                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 748:	008b8913          	addi	s2,s7,8
 74c:	4681                	li	a3,0
 74e:	4629                	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	dddff0ef          	jal	532 <printint>
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b5d9                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 760:	008b8913          	addi	s2,s7,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	dc5ff0ef          	jal	532 <printint>
        i += 1;
 772:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
        i += 1;
 778:	b575                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77a:	008b8913          	addi	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4629                	li	a2,10
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	dabff0ef          	jal	532 <printint>
        i += 2;
 78c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 78e:	8bca                	mv	s7,s2
      state = 0;
 790:	4981                	li	s3,0
        i += 2;
 792:	bd49                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 794:	008b8913          	addi	s2,s7,8
 798:	4681                	li	a3,0
 79a:	4641                	li	a2,16
 79c:	000ba583          	lw	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	d91ff0ef          	jal	532 <printint>
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bdad                	j	624 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4641                	li	a2,16
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	d79ff0ef          	jal	532 <printint>
        i += 1;
 7be:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
        i += 1;
 7c4:	b585                	j	624 <vprintf+0x4a>
 7c6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c8:	008b8d13          	addi	s10,s7,8
 7cc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d0:	03000593          	li	a1,48
 7d4:	855a                	mv	a0,s6
 7d6:	d3fff0ef          	jal	514 <putc>
  putc(fd, 'x');
 7da:	07800593          	li	a1,120
 7de:	855a                	mv	a0,s6
 7e0:	d35ff0ef          	jal	514 <putc>
 7e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e6:	00000b97          	auipc	s7,0x0
 7ea:	2eab8b93          	addi	s7,s7,746 # ad0 <digits>
 7ee:	03c9d793          	srli	a5,s3,0x3c
 7f2:	97de                	add	a5,a5,s7
 7f4:	0007c583          	lbu	a1,0(a5)
 7f8:	855a                	mv	a0,s6
 7fa:	d1bff0ef          	jal	514 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fe:	0992                	slli	s3,s3,0x4
 800:	397d                	addiw	s2,s2,-1
 802:	fe0916e3          	bnez	s2,7ee <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 806:	8bea                	mv	s7,s10
      state = 0;
 808:	4981                	li	s3,0
 80a:	6d02                	ld	s10,0(sp)
 80c:	bd21                	j	624 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 80e:	008b8993          	addi	s3,s7,8
 812:	000bb903          	ld	s2,0(s7)
 816:	00090f63          	beqz	s2,834 <vprintf+0x25a>
        for(; *s; s++)
 81a:	00094583          	lbu	a1,0(s2)
 81e:	c195                	beqz	a1,842 <vprintf+0x268>
          putc(fd, *s);
 820:	855a                	mv	a0,s6
 822:	cf3ff0ef          	jal	514 <putc>
        for(; *s; s++)
 826:	0905                	addi	s2,s2,1
 828:	00094583          	lbu	a1,0(s2)
 82c:	f9f5                	bnez	a1,820 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 82e:	8bce                	mv	s7,s3
      state = 0;
 830:	4981                	li	s3,0
 832:	bbcd                	j	624 <vprintf+0x4a>
          s = "(null)";
 834:	00000917          	auipc	s2,0x0
 838:	29490913          	addi	s2,s2,660 # ac8 <malloc+0x188>
        for(; *s; s++)
 83c:	02800593          	li	a1,40
 840:	b7c5                	j	820 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 842:	8bce                	mv	s7,s3
      state = 0;
 844:	4981                	li	s3,0
 846:	bbf9                	j	624 <vprintf+0x4a>
 848:	64a6                	ld	s1,72(sp)
 84a:	79e2                	ld	s3,56(sp)
 84c:	7a42                	ld	s4,48(sp)
 84e:	7aa2                	ld	s5,40(sp)
 850:	7b02                	ld	s6,32(sp)
 852:	6be2                	ld	s7,24(sp)
 854:	6c42                	ld	s8,16(sp)
 856:	6ca2                	ld	s9,8(sp)
    }
  }
}
 858:	60e6                	ld	ra,88(sp)
 85a:	6446                	ld	s0,80(sp)
 85c:	6906                	ld	s2,64(sp)
 85e:	6125                	addi	sp,sp,96
 860:	8082                	ret

0000000000000862 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 862:	715d                	addi	sp,sp,-80
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	addi	s0,sp,32
 86a:	e010                	sd	a2,0(s0)
 86c:	e414                	sd	a3,8(s0)
 86e:	e818                	sd	a4,16(s0)
 870:	ec1c                	sd	a5,24(s0)
 872:	03043023          	sd	a6,32(s0)
 876:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 87e:	8622                	mv	a2,s0
 880:	d5bff0ef          	jal	5da <vprintf>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6161                	addi	sp,sp,80
 88a:	8082                	ret

000000000000088c <printf>:

void
printf(const char *fmt, ...)
{
 88c:	711d                	addi	sp,sp,-96
 88e:	ec06                	sd	ra,24(sp)
 890:	e822                	sd	s0,16(sp)
 892:	1000                	addi	s0,sp,32
 894:	e40c                	sd	a1,8(s0)
 896:	e810                	sd	a2,16(s0)
 898:	ec14                	sd	a3,24(s0)
 89a:	f018                	sd	a4,32(s0)
 89c:	f41c                	sd	a5,40(s0)
 89e:	03043823          	sd	a6,48(s0)
 8a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a6:	00840613          	addi	a2,s0,8
 8aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ae:	85aa                	mv	a1,a0
 8b0:	4505                	li	a0,1
 8b2:	d29ff0ef          	jal	5da <vprintf>
}
 8b6:	60e2                	ld	ra,24(sp)
 8b8:	6442                	ld	s0,16(sp)
 8ba:	6125                	addi	sp,sp,96
 8bc:	8082                	ret

00000000000008be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8be:	1141                	addi	sp,sp,-16
 8c0:	e422                	sd	s0,8(sp)
 8c2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	00000797          	auipc	a5,0x0
 8cc:	7387b783          	ld	a5,1848(a5) # 1000 <freep>
 8d0:	a02d                	j	8fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d2:	4618                	lw	a4,8(a2)
 8d4:	9f2d                	addw	a4,a4,a1
 8d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	6310                	ld	a2,0(a4)
 8de:	a83d                	j	91c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e0:	ff852703          	lw	a4,-8(a0)
 8e4:	9f31                	addw	a4,a4,a2
 8e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e8:	ff053683          	ld	a3,-16(a0)
 8ec:	a091                	j	930 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ee:	6398                	ld	a4,0(a5)
 8f0:	00e7e463          	bltu	a5,a4,8f8 <free+0x3a>
 8f4:	00e6ea63          	bltu	a3,a4,908 <free+0x4a>
{
 8f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	fed7fae3          	bgeu	a5,a3,8ee <free+0x30>
 8fe:	6398                	ld	a4,0(a5)
 900:	00e6e463          	bltu	a3,a4,908 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	fee7eae3          	bltu	a5,a4,8f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 908:	ff852583          	lw	a1,-8(a0)
 90c:	6390                	ld	a2,0(a5)
 90e:	02059813          	slli	a6,a1,0x20
 912:	01c85713          	srli	a4,a6,0x1c
 916:	9736                	add	a4,a4,a3
 918:	fae60de3          	beq	a2,a4,8d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 91c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 920:	4790                	lw	a2,8(a5)
 922:	02061593          	slli	a1,a2,0x20
 926:	01c5d713          	srli	a4,a1,0x1c
 92a:	973e                	add	a4,a4,a5
 92c:	fae68ae3          	beq	a3,a4,8e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 930:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 932:	00000717          	auipc	a4,0x0
 936:	6cf73723          	sd	a5,1742(a4) # 1000 <freep>
}
 93a:	6422                	ld	s0,8(sp)
 93c:	0141                	addi	sp,sp,16
 93e:	8082                	ret

0000000000000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	7139                	addi	sp,sp,-64
 942:	fc06                	sd	ra,56(sp)
 944:	f822                	sd	s0,48(sp)
 946:	f426                	sd	s1,40(sp)
 948:	ec4e                	sd	s3,24(sp)
 94a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94c:	02051493          	slli	s1,a0,0x20
 950:	9081                	srli	s1,s1,0x20
 952:	04bd                	addi	s1,s1,15
 954:	8091                	srli	s1,s1,0x4
 956:	0014899b          	addiw	s3,s1,1
 95a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 95c:	00000517          	auipc	a0,0x0
 960:	6a453503          	ld	a0,1700(a0) # 1000 <freep>
 964:	c915                	beqz	a0,998 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 968:	4798                	lw	a4,8(a5)
 96a:	08977a63          	bgeu	a4,s1,9fe <malloc+0xbe>
 96e:	f04a                	sd	s2,32(sp)
 970:	e852                	sd	s4,16(sp)
 972:	e456                	sd	s5,8(sp)
 974:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 976:	8a4e                	mv	s4,s3
 978:	0009871b          	sext.w	a4,s3
 97c:	6685                	lui	a3,0x1
 97e:	00d77363          	bgeu	a4,a3,984 <malloc+0x44>
 982:	6a05                	lui	s4,0x1
 984:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 988:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 98c:	00000917          	auipc	s2,0x0
 990:	67490913          	addi	s2,s2,1652 # 1000 <freep>
  if(p == (char*)-1)
 994:	5afd                	li	s5,-1
 996:	a081                	j	9d6 <malloc+0x96>
 998:	f04a                	sd	s2,32(sp)
 99a:	e852                	sd	s4,16(sp)
 99c:	e456                	sd	s5,8(sp)
 99e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a0:	00000797          	auipc	a5,0x0
 9a4:	67078793          	addi	a5,a5,1648 # 1010 <base>
 9a8:	00000717          	auipc	a4,0x0
 9ac:	64f73c23          	sd	a5,1624(a4) # 1000 <freep>
 9b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b6:	b7c1                	j	976 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9b8:	6398                	ld	a4,0(a5)
 9ba:	e118                	sd	a4,0(a0)
 9bc:	a8a9                	j	a16 <malloc+0xd6>
  hp->s.size = nu;
 9be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c2:	0541                	addi	a0,a0,16
 9c4:	efbff0ef          	jal	8be <free>
  return freep;
 9c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9cc:	c12d                	beqz	a0,a2e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d0:	4798                	lw	a4,8(a5)
 9d2:	02977263          	bgeu	a4,s1,9f6 <malloc+0xb6>
    if(p == freep)
 9d6:	00093703          	ld	a4,0(s2)
 9da:	853e                	mv	a0,a5
 9dc:	fef719e3          	bne	a4,a5,9ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9e0:	8552                	mv	a0,s4
 9e2:	b1bff0ef          	jal	4fc <sbrk>
  if(p == (char*)-1)
 9e6:	fd551ce3          	bne	a0,s5,9be <malloc+0x7e>
        return 0;
 9ea:	4501                	li	a0,0
 9ec:	7902                	ld	s2,32(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
 9f4:	a03d                	j	a22 <malloc+0xe2>
 9f6:	7902                	ld	s2,32(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9fe:	fae48de3          	beq	s1,a4,9b8 <malloc+0x78>
        p->s.size -= nunits;
 a02:	4137073b          	subw	a4,a4,s3
 a06:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a08:	02071693          	slli	a3,a4,0x20
 a0c:	01c6d713          	srli	a4,a3,0x1c
 a10:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a12:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a16:	00000717          	auipc	a4,0x0
 a1a:	5ea73523          	sd	a0,1514(a4) # 1000 <freep>
      return (void*)(p + 1);
 a1e:	01078513          	addi	a0,a5,16
  }
}
 a22:	70e2                	ld	ra,56(sp)
 a24:	7442                	ld	s0,48(sp)
 a26:	74a2                	ld	s1,40(sp)
 a28:	69e2                	ld	s3,24(sp)
 a2a:	6121                	addi	sp,sp,64
 a2c:	8082                	ret
 a2e:	7902                	ld	s2,32(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	b7f5                	j	a22 <malloc+0xe2>
