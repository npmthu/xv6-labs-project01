
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){
   0:	c8010113          	addi	sp,sp,-896
   4:	36113c23          	sd	ra,888(sp)
   8:	36813823          	sd	s0,880(sp)
   c:	36913423          	sd	s1,872(sp)
  10:	37213023          	sd	s2,864(sp)
  14:	35313c23          	sd	s3,856(sp)
  18:	35413823          	sd	s4,848(sp)
  1c:	35513423          	sd	s5,840(sp)
  20:	35613023          	sd	s6,832(sp)
  24:	33713c23          	sd	s7,824(sp)
  28:	33813823          	sd	s8,816(sp)
  2c:	33913423          	sd	s9,808(sp)
  30:	33a13023          	sd	s10,800(sp)
  34:	31b13c23          	sd	s11,792(sp)
  38:	0700                	addi	s0,sp,896
  3a:	8c2a                	mv	s8,a0
    char buf[512];
    char *x_argv[MAXARG];
    int x_argc = argc - 1;
  3c:	fff50d1b          	addiw	s10,a0,-1
    char *arg_s, *arg_e;
    char ch;
    int read_bytes, has_arg = 0, child_pid;

    for(int i = 1; i < argc; i++){
  40:	4785                	li	a5,1
  42:	02a7d563          	bge	a5,a0,6c <main+0x6c>
  46:	00858713          	addi	a4,a1,8
  4a:	c9040793          	addi	a5,s0,-880
  4e:	ffe5061b          	addiw	a2,a0,-2
  52:	02061693          	slli	a3,a2,0x20
  56:	01d6d613          	srli	a2,a3,0x1d
  5a:	c9840693          	addi	a3,s0,-872
  5e:	9636                	add	a2,a2,a3
        x_argv[i - 1] = argv[i];
  60:	6314                	ld	a3,0(a4)
  62:	e394                	sd	a3,0(a5)
    for(int i = 1; i < argc; i++){
  64:	0721                	addi	a4,a4,8
  66:	07a1                	addi	a5,a5,8
  68:	fec79ce3          	bne	a5,a2,60 <main+0x60>
    int x_argc = argc - 1;
  6c:	89ea                	mv	s3,s10
    int read_bytes, has_arg = 0, child_pid;
  6e:	4a01                	li	s4,0
    }

    arg_s = arg_e = buf;
  70:	d9040913          	addi	s2,s0,-624

    while((read_bytes = read(0, &ch, sizeof(char))) == 1){
        if(arg_e >= buf + 512 - 1){
  74:	f8f40a93          	addi	s5,s0,-113
            fprintf(2, "xargs: argument too long\n");
            arg_s = arg_e = buf; // reset buffer
            continue;
        }
        if(ch == '\n' || ch == ' '){
  78:	4b29                	li	s6,10
            if(has_arg){
                *arg_e = '\0';
                if(x_argc >= MAXARG - 1){
  7a:	4cf9                	li	s9,30
                    fprintf(2, "xargs: too many arguments\n");
  7c:	00001d97          	auipc	s11,0x1
  80:	9f4d8d93          	addi	s11,s11,-1548 # a70 <malloc+0x11c>
        if(ch == '\n' || ch == ' '){
  84:	02000b93          	li	s7,32
  88:	a811                	j	9c <main+0x9c>
            fprintf(2, "xargs: argument too long\n");
  8a:	00001597          	auipc	a1,0x1
  8e:	9c658593          	addi	a1,a1,-1594 # a50 <malloc+0xfc>
  92:	4509                	li	a0,2
  94:	7e2000ef          	jal	876 <fprintf>
            arg_s = arg_e = buf; // reset buffer
  98:	d9040913          	addi	s2,s0,-624
    while((read_bytes = read(0, &ch, sizeof(char))) == 1){
  9c:	4605                	li	a2,1
  9e:	c8f40593          	addi	a1,s0,-881
  a2:	4501                	li	a0,0
  a4:	3fc000ef          	jal	4a0 <read>
  a8:	84aa                	mv	s1,a0
  aa:	4785                	li	a5,1
  ac:	06f51a63          	bne	a0,a5,120 <main+0x120>
        if(arg_e >= buf + 512 - 1){
  b0:	fd597de3          	bgeu	s2,s5,8a <main+0x8a>
        if(ch == '\n' || ch == ' '){
  b4:	c8f44783          	lbu	a5,-881(s0)
  b8:	0f678d63          	beq	a5,s6,1b2 <main+0x1b2>
  bc:	11778463          	beq	a5,s7,1c4 <main+0x1c4>
                }
                x_argc = argc - 1; // reset arg list
                arg_s = arg_e = buf;
            }
        } else{
            *arg_e++ = ch;
  c0:	00f90023          	sb	a5,0(s2)
            has_arg = 1;
  c4:	8a26                	mv	s4,s1
            *arg_e++ = ch;
  c6:	0905                	addi	s2,s2,1
  c8:	bfd1                	j	9c <main+0x9c>
                    x_argv[x_argc] = 0;
  ca:	098e                	slli	s3,s3,0x3
  cc:	f9098793          	addi	a5,s3,-112
  d0:	008789b3          	add	s3,a5,s0
  d4:	d009b023          	sd	zero,-768(s3)
                    if((child_pid = fork()) < 0){
  d8:	3a8000ef          	jal	480 <fork>
  dc:	00054863          	bltz	a0,ec <main+0xec>
                    } else if(child_pid == 0){
  e0:	c105                	beqz	a0,100 <main+0x100>
                x_argc = argc - 1; // reset arg list
  e2:	89ea                	mv	s3,s10
  e4:	4a01                	li	s4,0
                arg_s = arg_e = buf;
  e6:	d9040913          	addi	s2,s0,-624
  ea:	bf4d                	j	9c <main+0x9c>
                        fprintf(2, "xargs: fork failed\n");
  ec:	00001597          	auipc	a1,0x1
  f0:	9a458593          	addi	a1,a1,-1628 # a90 <malloc+0x13c>
  f4:	4509                	li	a0,2
  f6:	780000ef          	jal	876 <fprintf>
                        exit(1);
  fa:	4505                	li	a0,1
  fc:	38c000ef          	jal	488 <exit>
                        exec(x_argv[0], x_argv);
 100:	c9040593          	addi	a1,s0,-880
 104:	c9043503          	ld	a0,-880(s0)
 108:	3b8000ef          	jal	4c0 <exec>
                        fprintf(2, "xargs: exec failed\n");
 10c:	00001597          	auipc	a1,0x1
 110:	99c58593          	addi	a1,a1,-1636 # aa8 <malloc+0x154>
 114:	4509                	li	a0,2
 116:	760000ef          	jal	876 <fprintf>
                        exit(1);
 11a:	4505                	li	a0,1
 11c:	36c000ef          	jal	488 <exit>
        }
    }

    // execute the last command if input does not end with '\n'
    if(has_arg){
 120:	040a0763          	beqz	s4,16e <main+0x16e>
        *arg_e = '\0';
 124:	00090023          	sb	zero,0(s2)
        if(x_argc >= MAXARG - 1){
 128:	47f9                	li	a5,30
 12a:	0137dc63          	bge	a5,s3,142 <main+0x142>
            fprintf(2, "xargs: too many arguments\n");
 12e:	00001597          	auipc	a1,0x1
 132:	94258593          	addi	a1,a1,-1726 # a70 <malloc+0x11c>
 136:	4509                	li	a0,2
 138:	73e000ef          	jal	876 <fprintf>
            exit(1);
 13c:	4505                	li	a0,1
 13e:	34a000ef          	jal	488 <exit>
        }
        x_argv[x_argc++] = arg_s;
 142:	00399793          	slli	a5,s3,0x3
 146:	f9078793          	addi	a5,a5,-112
 14a:	97a2                	add	a5,a5,s0
 14c:	d9040713          	addi	a4,s0,-624
 150:	d0e7b023          	sd	a4,-768(a5)
        x_argv[x_argc] = 0;
 154:	0019879b          	addiw	a5,s3,1
 158:	078e                	slli	a5,a5,0x3
 15a:	f9078793          	addi	a5,a5,-112
 15e:	97a2                	add	a5,a5,s0
 160:	d007b023          	sd	zero,-768(a5)

        if((child_pid = fork()) < 0){
 164:	31c000ef          	jal	480 <fork>
 168:	00054b63          	bltz	a0,17e <main+0x17e>
            fprintf(2, "xargs: fork failed\n");
            exit(1);
        } else if(child_pid == 0){
 16c:	c11d                	beqz	a0,192 <main+0x192>
            fprintf(2, "xargs: exec failed\n");
            exit(1);
        }
    }

    while(wait(0) > 0);
 16e:	4501                	li	a0,0
 170:	320000ef          	jal	490 <wait>
 174:	fea04de3          	bgtz	a0,16e <main+0x16e>

    exit(0);
 178:	4501                	li	a0,0
 17a:	30e000ef          	jal	488 <exit>
            fprintf(2, "xargs: fork failed\n");
 17e:	00001597          	auipc	a1,0x1
 182:	91258593          	addi	a1,a1,-1774 # a90 <malloc+0x13c>
 186:	4509                	li	a0,2
 188:	6ee000ef          	jal	876 <fprintf>
            exit(1);
 18c:	4505                	li	a0,1
 18e:	2fa000ef          	jal	488 <exit>
            exec(x_argv[0], x_argv);
 192:	c9040593          	addi	a1,s0,-880
 196:	c9043503          	ld	a0,-880(s0)
 19a:	326000ef          	jal	4c0 <exec>
            fprintf(2, "xargs: exec failed\n");
 19e:	00001597          	auipc	a1,0x1
 1a2:	90a58593          	addi	a1,a1,-1782 # aa8 <malloc+0x154>
 1a6:	4509                	li	a0,2
 1a8:	6ce000ef          	jal	876 <fprintf>
            exit(1);
 1ac:	4505                	li	a0,1
 1ae:	2da000ef          	jal	488 <exit>
            if(has_arg){
 1b2:	040a1963          	bnez	s4,204 <main+0x204>
                if(x_argc > argc - 1){
 1b6:	f189dae3          	bge	s3,s8,ca <main+0xca>
                x_argc = argc - 1; // reset arg list
 1ba:	89ea                	mv	s3,s10
 1bc:	4a01                	li	s4,0
                arg_s = arg_e = buf;
 1be:	d9040913          	addi	s2,s0,-624
 1c2:	bde9                	j	9c <main+0x9c>
            if(has_arg){
 1c4:	000a1463          	bnez	s4,1cc <main+0x1cc>
            arg_e++;
 1c8:	0905                	addi	s2,s2,1
            if(ch == '\n'){
 1ca:	bdc9                	j	9c <main+0x9c>
                *arg_e = '\0';
 1cc:	00090023          	sb	zero,0(s2)
                if(x_argc >= MAXARG - 1){
 1d0:	033cce63          	blt	s9,s3,20c <main+0x20c>
                x_argv[x_argc++] = arg_s;
 1d4:	00399793          	slli	a5,s3,0x3
 1d8:	f9078793          	addi	a5,a5,-112
 1dc:	97a2                	add	a5,a5,s0
 1de:	d9040713          	addi	a4,s0,-624
 1e2:	d0e7b023          	sd	a4,-768(a5)
            arg_e++;
 1e6:	0905                	addi	s2,s2,1
                x_argv[x_argc++] = arg_s;
 1e8:	2985                	addiw	s3,s3,1
            arg_e++;
 1ea:	4a01                	li	s4,0
 1ec:	bd45                	j	9c <main+0x9c>
                x_argv[x_argc++] = arg_s;
 1ee:	00399793          	slli	a5,s3,0x3
 1f2:	f9078793          	addi	a5,a5,-112
 1f6:	97a2                	add	a5,a5,s0
 1f8:	d9040713          	addi	a4,s0,-624
 1fc:	d0e7b023          	sd	a4,-768(a5)
 200:	2985                	addiw	s3,s3,1
 202:	bf55                	j	1b6 <main+0x1b6>
                *arg_e = '\0';
 204:	00090023          	sb	zero,0(s2)
                if(x_argc >= MAXARG - 1){
 208:	ff3cd3e3          	bge	s9,s3,1ee <main+0x1ee>
                    fprintf(2, "xargs: too many arguments\n");
 20c:	85ee                	mv	a1,s11
 20e:	4509                	li	a0,2
 210:	666000ef          	jal	876 <fprintf>
                    continue;
 214:	8a26                	mv	s4,s1
                    x_argc = argc - 1;
 216:	89ea                	mv	s3,s10
                    arg_s = arg_e = buf;
 218:	d9040913          	addi	s2,s0,-624
                    continue;
 21c:	b541                	j	9c <main+0x9c>

000000000000021e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
  extern int main();
  main();
 226:	ddbff0ef          	jal	0 <main>
  exit(0);
 22a:	4501                	li	a0,0
 22c:	25c000ef          	jal	488 <exit>

0000000000000230 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 236:	87aa                	mv	a5,a0
 238:	0585                	addi	a1,a1,1
 23a:	0785                	addi	a5,a5,1
 23c:	fff5c703          	lbu	a4,-1(a1)
 240:	fee78fa3          	sb	a4,-1(a5)
 244:	fb75                	bnez	a4,238 <strcpy+0x8>
    ;
  return os;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	cb91                	beqz	a5,26a <strcmp+0x1e>
 258:	0005c703          	lbu	a4,0(a1)
 25c:	00f71763          	bne	a4,a5,26a <strcmp+0x1e>
    p++, q++;
 260:	0505                	addi	a0,a0,1
 262:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	fbe5                	bnez	a5,258 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 26a:	0005c503          	lbu	a0,0(a1)
}
 26e:	40a7853b          	subw	a0,a5,a0
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <strlen>:

uint
strlen(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27e:	00054783          	lbu	a5,0(a0)
 282:	cf91                	beqz	a5,29e <strlen+0x26>
 284:	0505                	addi	a0,a0,1
 286:	87aa                	mv	a5,a0
 288:	86be                	mv	a3,a5
 28a:	0785                	addi	a5,a5,1
 28c:	fff7c703          	lbu	a4,-1(a5)
 290:	ff65                	bnez	a4,288 <strlen+0x10>
 292:	40a6853b          	subw	a0,a3,a0
 296:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  for(n = 0; s[n]; n++)
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <strlen+0x20>

00000000000002a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2a8:	ca19                	beqz	a2,2be <memset+0x1c>
 2aa:	87aa                	mv	a5,a0
 2ac:	1602                	slli	a2,a2,0x20
 2ae:	9201                	srli	a2,a2,0x20
 2b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2b8:	0785                	addi	a5,a5,1
 2ba:	fee79de3          	bne	a5,a4,2b4 <memset+0x12>
  }
  return dst;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strchr>:

char*
strchr(const char *s, char c)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb99                	beqz	a5,2e4 <strchr+0x20>
    if(*s == c)
 2d0:	00f58763          	beq	a1,a5,2de <strchr+0x1a>
  for(; *s; s++)
 2d4:	0505                	addi	a0,a0,1
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbfd                	bnez	a5,2d0 <strchr+0xc>
      return (char*)s;
  return 0;
 2dc:	4501                	li	a0,0
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strchr+0x1a>

00000000000002e8 <gets>:

char*
gets(char *buf, int max)
{
 2e8:	711d                	addi	sp,sp,-96
 2ea:	ec86                	sd	ra,88(sp)
 2ec:	e8a2                	sd	s0,80(sp)
 2ee:	e4a6                	sd	s1,72(sp)
 2f0:	e0ca                	sd	s2,64(sp)
 2f2:	fc4e                	sd	s3,56(sp)
 2f4:	f852                	sd	s4,48(sp)
 2f6:	f456                	sd	s5,40(sp)
 2f8:	f05a                	sd	s6,32(sp)
 2fa:	ec5e                	sd	s7,24(sp)
 2fc:	1080                	addi	s0,sp,96
 2fe:	8baa                	mv	s7,a0
 300:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 302:	892a                	mv	s2,a0
 304:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 306:	4aa9                	li	s5,10
 308:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 30a:	89a6                	mv	s3,s1
 30c:	2485                	addiw	s1,s1,1
 30e:	0344d663          	bge	s1,s4,33a <gets+0x52>
    cc = read(0, &c, 1);
 312:	4605                	li	a2,1
 314:	faf40593          	addi	a1,s0,-81
 318:	4501                	li	a0,0
 31a:	186000ef          	jal	4a0 <read>
    if(cc < 1)
 31e:	00a05e63          	blez	a0,33a <gets+0x52>
    buf[i++] = c;
 322:	faf44783          	lbu	a5,-81(s0)
 326:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 32a:	01578763          	beq	a5,s5,338 <gets+0x50>
 32e:	0905                	addi	s2,s2,1
 330:	fd679de3          	bne	a5,s6,30a <gets+0x22>
    buf[i++] = c;
 334:	89a6                	mv	s3,s1
 336:	a011                	j	33a <gets+0x52>
 338:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 33a:	99de                	add	s3,s3,s7
 33c:	00098023          	sb	zero,0(s3)
  return buf;
}
 340:	855e                	mv	a0,s7
 342:	60e6                	ld	ra,88(sp)
 344:	6446                	ld	s0,80(sp)
 346:	64a6                	ld	s1,72(sp)
 348:	6906                	ld	s2,64(sp)
 34a:	79e2                	ld	s3,56(sp)
 34c:	7a42                	ld	s4,48(sp)
 34e:	7aa2                	ld	s5,40(sp)
 350:	7b02                	ld	s6,32(sp)
 352:	6be2                	ld	s7,24(sp)
 354:	6125                	addi	sp,sp,96
 356:	8082                	ret

0000000000000358 <stat>:

int
stat(const char *n, struct stat *st)
{
 358:	1101                	addi	sp,sp,-32
 35a:	ec06                	sd	ra,24(sp)
 35c:	e822                	sd	s0,16(sp)
 35e:	e04a                	sd	s2,0(sp)
 360:	1000                	addi	s0,sp,32
 362:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 364:	4581                	li	a1,0
 366:	162000ef          	jal	4c8 <open>
  if(fd < 0)
 36a:	02054263          	bltz	a0,38e <stat+0x36>
 36e:	e426                	sd	s1,8(sp)
 370:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 372:	85ca                	mv	a1,s2
 374:	16c000ef          	jal	4e0 <fstat>
 378:	892a                	mv	s2,a0
  close(fd);
 37a:	8526                	mv	a0,s1
 37c:	134000ef          	jal	4b0 <close>
  return r;
 380:	64a2                	ld	s1,8(sp)
}
 382:	854a                	mv	a0,s2
 384:	60e2                	ld	ra,24(sp)
 386:	6442                	ld	s0,16(sp)
 388:	6902                	ld	s2,0(sp)
 38a:	6105                	addi	sp,sp,32
 38c:	8082                	ret
    return -1;
 38e:	597d                	li	s2,-1
 390:	bfcd                	j	382 <stat+0x2a>

0000000000000392 <atoi>:

int
atoi(const char *s)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 398:	00054683          	lbu	a3,0(a0)
 39c:	fd06879b          	addiw	a5,a3,-48
 3a0:	0ff7f793          	zext.b	a5,a5
 3a4:	4625                	li	a2,9
 3a6:	02f66863          	bltu	a2,a5,3d6 <atoi+0x44>
 3aa:	872a                	mv	a4,a0
  n = 0;
 3ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ae:	0705                	addi	a4,a4,1
 3b0:	0025179b          	slliw	a5,a0,0x2
 3b4:	9fa9                	addw	a5,a5,a0
 3b6:	0017979b          	slliw	a5,a5,0x1
 3ba:	9fb5                	addw	a5,a5,a3
 3bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c0:	00074683          	lbu	a3,0(a4)
 3c4:	fd06879b          	addiw	a5,a3,-48
 3c8:	0ff7f793          	zext.b	a5,a5
 3cc:	fef671e3          	bgeu	a2,a5,3ae <atoi+0x1c>
  return n;
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret
  n = 0;
 3d6:	4501                	li	a0,0
 3d8:	bfe5                	j	3d0 <atoi+0x3e>

00000000000003da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e422                	sd	s0,8(sp)
 3de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e0:	02b57463          	bgeu	a0,a1,408 <memmove+0x2e>
    while(n-- > 0)
 3e4:	00c05f63          	blez	a2,402 <memmove+0x28>
 3e8:	1602                	slli	a2,a2,0x20
 3ea:	9201                	srli	a2,a2,0x20
 3ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f2:	0585                	addi	a1,a1,1
 3f4:	0705                	addi	a4,a4,1
 3f6:	fff5c683          	lbu	a3,-1(a1)
 3fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fe:	fef71ae3          	bne	a4,a5,3f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret
    dst += n;
 408:	00c50733          	add	a4,a0,a2
    src += n;
 40c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40e:	fec05ae3          	blez	a2,402 <memmove+0x28>
 412:	fff6079b          	addiw	a5,a2,-1
 416:	1782                	slli	a5,a5,0x20
 418:	9381                	srli	a5,a5,0x20
 41a:	fff7c793          	not	a5,a5
 41e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 420:	15fd                	addi	a1,a1,-1
 422:	177d                	addi	a4,a4,-1
 424:	0005c683          	lbu	a3,0(a1)
 428:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42c:	fee79ae3          	bne	a5,a4,420 <memmove+0x46>
 430:	bfc9                	j	402 <memmove+0x28>

0000000000000432 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e422                	sd	s0,8(sp)
 436:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 438:	ca05                	beqz	a2,468 <memcmp+0x36>
 43a:	fff6069b          	addiw	a3,a2,-1
 43e:	1682                	slli	a3,a3,0x20
 440:	9281                	srli	a3,a3,0x20
 442:	0685                	addi	a3,a3,1
 444:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 446:	00054783          	lbu	a5,0(a0)
 44a:	0005c703          	lbu	a4,0(a1)
 44e:	00e79863          	bne	a5,a4,45e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 452:	0505                	addi	a0,a0,1
    p2++;
 454:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 456:	fed518e3          	bne	a0,a3,446 <memcmp+0x14>
  }
  return 0;
 45a:	4501                	li	a0,0
 45c:	a019                	j	462 <memcmp+0x30>
      return *p1 - *p2;
 45e:	40e7853b          	subw	a0,a5,a4
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
  return 0;
 468:	4501                	li	a0,0
 46a:	bfe5                	j	462 <memcmp+0x30>

000000000000046c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e406                	sd	ra,8(sp)
 470:	e022                	sd	s0,0(sp)
 472:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 474:	f67ff0ef          	jal	3da <memmove>
}
 478:	60a2                	ld	ra,8(sp)
 47a:	6402                	ld	s0,0(sp)
 47c:	0141                	addi	sp,sp,16
 47e:	8082                	ret

0000000000000480 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 480:	4885                	li	a7,1
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <exit>:
.global exit
exit:
 li a7, SYS_exit
 488:	4889                	li	a7,2
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <wait>:
.global wait
wait:
 li a7, SYS_wait
 490:	488d                	li	a7,3
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 498:	4891                	li	a7,4
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	4895                	li	a7,5
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <write>:
.global write
write:
 li a7, SYS_write
 4a8:	48c1                	li	a7,16
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <close>:
.global close
close:
 li a7, SYS_close
 4b0:	48d5                	li	a7,21
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b8:	4899                	li	a7,6
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c0:	489d                	li	a7,7
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <open>:
.global open
open:
 li a7, SYS_open
 4c8:	48bd                	li	a7,15
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d0:	48c5                	li	a7,17
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d8:	48c9                	li	a7,18
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e0:	48a1                	li	a7,8
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <link>:
.global link
link:
 li a7, SYS_link
 4e8:	48cd                	li	a7,19
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f0:	48d1                	li	a7,20
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f8:	48a5                	li	a7,9
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <dup>:
.global dup
dup:
 li a7, SYS_dup
 500:	48a9                	li	a7,10
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 508:	48ad                	li	a7,11
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 510:	48b1                	li	a7,12
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 518:	48b5                	li	a7,13
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 520:	48b9                	li	a7,14
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 528:	1101                	addi	sp,sp,-32
 52a:	ec06                	sd	ra,24(sp)
 52c:	e822                	sd	s0,16(sp)
 52e:	1000                	addi	s0,sp,32
 530:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 534:	4605                	li	a2,1
 536:	fef40593          	addi	a1,s0,-17
 53a:	f6fff0ef          	jal	4a8 <write>
}
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	6105                	addi	sp,sp,32
 544:	8082                	ret

0000000000000546 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 546:	7139                	addi	sp,sp,-64
 548:	fc06                	sd	ra,56(sp)
 54a:	f822                	sd	s0,48(sp)
 54c:	f426                	sd	s1,40(sp)
 54e:	0080                	addi	s0,sp,64
 550:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 552:	c299                	beqz	a3,558 <printint+0x12>
 554:	0805c963          	bltz	a1,5e6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 558:	2581                	sext.w	a1,a1
  neg = 0;
 55a:	4881                	li	a7,0
 55c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 560:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 562:	2601                	sext.w	a2,a2
 564:	00000517          	auipc	a0,0x0
 568:	56450513          	addi	a0,a0,1380 # ac8 <digits>
 56c:	883a                	mv	a6,a4
 56e:	2705                	addiw	a4,a4,1
 570:	02c5f7bb          	remuw	a5,a1,a2
 574:	1782                	slli	a5,a5,0x20
 576:	9381                	srli	a5,a5,0x20
 578:	97aa                	add	a5,a5,a0
 57a:	0007c783          	lbu	a5,0(a5)
 57e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 582:	0005879b          	sext.w	a5,a1
 586:	02c5d5bb          	divuw	a1,a1,a2
 58a:	0685                	addi	a3,a3,1
 58c:	fec7f0e3          	bgeu	a5,a2,56c <printint+0x26>
  if(neg)
 590:	00088c63          	beqz	a7,5a8 <printint+0x62>
    buf[i++] = '-';
 594:	fd070793          	addi	a5,a4,-48
 598:	00878733          	add	a4,a5,s0
 59c:	02d00793          	li	a5,45
 5a0:	fef70823          	sb	a5,-16(a4)
 5a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a8:	02e05a63          	blez	a4,5dc <printint+0x96>
 5ac:	f04a                	sd	s2,32(sp)
 5ae:	ec4e                	sd	s3,24(sp)
 5b0:	fc040793          	addi	a5,s0,-64
 5b4:	00e78933          	add	s2,a5,a4
 5b8:	fff78993          	addi	s3,a5,-1
 5bc:	99ba                	add	s3,s3,a4
 5be:	377d                	addiw	a4,a4,-1
 5c0:	1702                	slli	a4,a4,0x20
 5c2:	9301                	srli	a4,a4,0x20
 5c4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c8:	fff94583          	lbu	a1,-1(s2)
 5cc:	8526                	mv	a0,s1
 5ce:	f5bff0ef          	jal	528 <putc>
  while(--i >= 0)
 5d2:	197d                	addi	s2,s2,-1
 5d4:	ff391ae3          	bne	s2,s3,5c8 <printint+0x82>
 5d8:	7902                	ld	s2,32(sp)
 5da:	69e2                	ld	s3,24(sp)
}
 5dc:	70e2                	ld	ra,56(sp)
 5de:	7442                	ld	s0,48(sp)
 5e0:	74a2                	ld	s1,40(sp)
 5e2:	6121                	addi	sp,sp,64
 5e4:	8082                	ret
    x = -xx;
 5e6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ea:	4885                	li	a7,1
    x = -xx;
 5ec:	bf85                	j	55c <printint+0x16>

00000000000005ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ee:	711d                	addi	sp,sp,-96
 5f0:	ec86                	sd	ra,88(sp)
 5f2:	e8a2                	sd	s0,80(sp)
 5f4:	e0ca                	sd	s2,64(sp)
 5f6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f8:	0005c903          	lbu	s2,0(a1)
 5fc:	26090863          	beqz	s2,86c <vprintf+0x27e>
 600:	e4a6                	sd	s1,72(sp)
 602:	fc4e                	sd	s3,56(sp)
 604:	f852                	sd	s4,48(sp)
 606:	f456                	sd	s5,40(sp)
 608:	f05a                	sd	s6,32(sp)
 60a:	ec5e                	sd	s7,24(sp)
 60c:	e862                	sd	s8,16(sp)
 60e:	e466                	sd	s9,8(sp)
 610:	8b2a                	mv	s6,a0
 612:	8a2e                	mv	s4,a1
 614:	8bb2                	mv	s7,a2
  state = 0;
 616:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 618:	4481                	li	s1,0
 61a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 61c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 620:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 624:	06c00c93          	li	s9,108
 628:	a005                	j	648 <vprintf+0x5a>
        putc(fd, c0);
 62a:	85ca                	mv	a1,s2
 62c:	855a                	mv	a0,s6
 62e:	efbff0ef          	jal	528 <putc>
 632:	a019                	j	638 <vprintf+0x4a>
    } else if(state == '%'){
 634:	03598263          	beq	s3,s5,658 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 638:	2485                	addiw	s1,s1,1
 63a:	8726                	mv	a4,s1
 63c:	009a07b3          	add	a5,s4,s1
 640:	0007c903          	lbu	s2,0(a5)
 644:	20090c63          	beqz	s2,85c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 648:	0009079b          	sext.w	a5,s2
    if(state == 0){
 64c:	fe0994e3          	bnez	s3,634 <vprintf+0x46>
      if(c0 == '%'){
 650:	fd579de3          	bne	a5,s5,62a <vprintf+0x3c>
        state = '%';
 654:	89be                	mv	s3,a5
 656:	b7cd                	j	638 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 658:	00ea06b3          	add	a3,s4,a4
 65c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 660:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 662:	c681                	beqz	a3,66a <vprintf+0x7c>
 664:	9752                	add	a4,a4,s4
 666:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 66a:	03878f63          	beq	a5,s8,6a8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 66e:	05978963          	beq	a5,s9,6c0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 672:	07500713          	li	a4,117
 676:	0ee78363          	beq	a5,a4,75c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 67a:	07800713          	li	a4,120
 67e:	12e78563          	beq	a5,a4,7a8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 682:	07000713          	li	a4,112
 686:	14e78a63          	beq	a5,a4,7da <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 68a:	07300713          	li	a4,115
 68e:	18e78a63          	beq	a5,a4,822 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 692:	02500713          	li	a4,37
 696:	04e79563          	bne	a5,a4,6e0 <vprintf+0xf2>
        putc(fd, '%');
 69a:	02500593          	li	a1,37
 69e:	855a                	mv	a0,s6
 6a0:	e89ff0ef          	jal	528 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf49                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4685                	li	a3,1
 6ae:	4629                	li	a2,10
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	e91ff0ef          	jal	546 <printint>
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bfad                	j	638 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6c0:	06400793          	li	a5,100
 6c4:	02f68963          	beq	a3,a5,6f6 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c8:	06c00793          	li	a5,108
 6cc:	04f68263          	beq	a3,a5,710 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6d0:	07500793          	li	a5,117
 6d4:	0af68063          	beq	a3,a5,774 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6d8:	07800793          	li	a5,120
 6dc:	0ef68263          	beq	a3,a5,7c0 <vprintf+0x1d2>
        putc(fd, '%');
 6e0:	02500593          	li	a1,37
 6e4:	855a                	mv	a0,s6
 6e6:	e43ff0ef          	jal	528 <putc>
        putc(fd, c0);
 6ea:	85ca                	mv	a1,s2
 6ec:	855a                	mv	a0,s6
 6ee:	e3bff0ef          	jal	528 <putc>
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b791                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f6:	008b8913          	addi	s2,s7,8
 6fa:	4685                	li	a3,1
 6fc:	4629                	li	a2,10
 6fe:	000ba583          	lw	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	e43ff0ef          	jal	546 <printint>
        i += 1;
 708:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 1;
 70e:	b72d                	j	638 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 710:	06400793          	li	a5,100
 714:	02f60763          	beq	a2,a5,742 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 718:	07500793          	li	a5,117
 71c:	06f60963          	beq	a2,a5,78e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 720:	07800793          	li	a5,120
 724:	faf61ee3          	bne	a2,a5,6e0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	e11ff0ef          	jal	546 <printint>
        i += 2;
 73a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 2;
 740:	bde5                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 742:	008b8913          	addi	s2,s7,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	df7ff0ef          	jal	546 <printint>
        i += 2;
 754:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
        i += 2;
 75a:	bdf9                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 75c:	008b8913          	addi	s2,s7,8
 760:	4681                	li	a3,0
 762:	4629                	li	a2,10
 764:	000ba583          	lw	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	dddff0ef          	jal	546 <printint>
 76e:	8bca                	mv	s7,s2
      state = 0;
 770:	4981                	li	s3,0
 772:	b5d9                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 774:	008b8913          	addi	s2,s7,8
 778:	4681                	li	a3,0
 77a:	4629                	li	a2,10
 77c:	000ba583          	lw	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	dc5ff0ef          	jal	546 <printint>
        i += 1;
 786:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 1;
 78c:	b575                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78e:	008b8913          	addi	s2,s7,8
 792:	4681                	li	a3,0
 794:	4629                	li	a2,10
 796:	000ba583          	lw	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	dabff0ef          	jal	546 <printint>
        i += 2;
 7a0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
        i += 2;
 7a6:	bd49                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7a8:	008b8913          	addi	s2,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4641                	li	a2,16
 7b0:	000ba583          	lw	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	d91ff0ef          	jal	546 <printint>
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bdad                	j	638 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	4681                	li	a3,0
 7c6:	4641                	li	a2,16
 7c8:	000ba583          	lw	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	d79ff0ef          	jal	546 <printint>
        i += 1;
 7d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
        i += 1;
 7d8:	b585                	j	638 <vprintf+0x4a>
 7da:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7dc:	008b8d13          	addi	s10,s7,8
 7e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e4:	03000593          	li	a1,48
 7e8:	855a                	mv	a0,s6
 7ea:	d3fff0ef          	jal	528 <putc>
  putc(fd, 'x');
 7ee:	07800593          	li	a1,120
 7f2:	855a                	mv	a0,s6
 7f4:	d35ff0ef          	jal	528 <putc>
 7f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fa:	00000b97          	auipc	s7,0x0
 7fe:	2ceb8b93          	addi	s7,s7,718 # ac8 <digits>
 802:	03c9d793          	srli	a5,s3,0x3c
 806:	97de                	add	a5,a5,s7
 808:	0007c583          	lbu	a1,0(a5)
 80c:	855a                	mv	a0,s6
 80e:	d1bff0ef          	jal	528 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 812:	0992                	slli	s3,s3,0x4
 814:	397d                	addiw	s2,s2,-1
 816:	fe0916e3          	bnez	s2,802 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 81a:	8bea                	mv	s7,s10
      state = 0;
 81c:	4981                	li	s3,0
 81e:	6d02                	ld	s10,0(sp)
 820:	bd21                	j	638 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 822:	008b8993          	addi	s3,s7,8
 826:	000bb903          	ld	s2,0(s7)
 82a:	00090f63          	beqz	s2,848 <vprintf+0x25a>
        for(; *s; s++)
 82e:	00094583          	lbu	a1,0(s2)
 832:	c195                	beqz	a1,856 <vprintf+0x268>
          putc(fd, *s);
 834:	855a                	mv	a0,s6
 836:	cf3ff0ef          	jal	528 <putc>
        for(; *s; s++)
 83a:	0905                	addi	s2,s2,1
 83c:	00094583          	lbu	a1,0(s2)
 840:	f9f5                	bnez	a1,834 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 842:	8bce                	mv	s7,s3
      state = 0;
 844:	4981                	li	s3,0
 846:	bbcd                	j	638 <vprintf+0x4a>
          s = "(null)";
 848:	00000917          	auipc	s2,0x0
 84c:	27890913          	addi	s2,s2,632 # ac0 <malloc+0x16c>
        for(; *s; s++)
 850:	02800593          	li	a1,40
 854:	b7c5                	j	834 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 856:	8bce                	mv	s7,s3
      state = 0;
 858:	4981                	li	s3,0
 85a:	bbf9                	j	638 <vprintf+0x4a>
 85c:	64a6                	ld	s1,72(sp)
 85e:	79e2                	ld	s3,56(sp)
 860:	7a42                	ld	s4,48(sp)
 862:	7aa2                	ld	s5,40(sp)
 864:	7b02                	ld	s6,32(sp)
 866:	6be2                	ld	s7,24(sp)
 868:	6c42                	ld	s8,16(sp)
 86a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 86c:	60e6                	ld	ra,88(sp)
 86e:	6446                	ld	s0,80(sp)
 870:	6906                	ld	s2,64(sp)
 872:	6125                	addi	sp,sp,96
 874:	8082                	ret

0000000000000876 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 876:	715d                	addi	sp,sp,-80
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e010                	sd	a2,0(s0)
 880:	e414                	sd	a3,8(s0)
 882:	e818                	sd	a4,16(s0)
 884:	ec1c                	sd	a5,24(s0)
 886:	03043023          	sd	a6,32(s0)
 88a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 892:	8622                	mv	a2,s0
 894:	d5bff0ef          	jal	5ee <vprintf>
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	6161                	addi	sp,sp,80
 89e:	8082                	ret

00000000000008a0 <printf>:

void
printf(const char *fmt, ...)
{
 8a0:	711d                	addi	sp,sp,-96
 8a2:	ec06                	sd	ra,24(sp)
 8a4:	e822                	sd	s0,16(sp)
 8a6:	1000                	addi	s0,sp,32
 8a8:	e40c                	sd	a1,8(s0)
 8aa:	e810                	sd	a2,16(s0)
 8ac:	ec14                	sd	a3,24(s0)
 8ae:	f018                	sd	a4,32(s0)
 8b0:	f41c                	sd	a5,40(s0)
 8b2:	03043823          	sd	a6,48(s0)
 8b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ba:	00840613          	addi	a2,s0,8
 8be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c2:	85aa                	mv	a1,a0
 8c4:	4505                	li	a0,1
 8c6:	d29ff0ef          	jal	5ee <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6125                	addi	sp,sp,96
 8d0:	8082                	ret

00000000000008d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d2:	1141                	addi	sp,sp,-16
 8d4:	e422                	sd	s0,8(sp)
 8d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	00000797          	auipc	a5,0x0
 8e0:	7247b783          	ld	a5,1828(a5) # 1000 <freep>
 8e4:	a02d                	j	90e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e6:	4618                	lw	a4,8(a2)
 8e8:	9f2d                	addw	a4,a4,a1
 8ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ee:	6398                	ld	a4,0(a5)
 8f0:	6310                	ld	a2,0(a4)
 8f2:	a83d                	j	930 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f4:	ff852703          	lw	a4,-8(a0)
 8f8:	9f31                	addw	a4,a4,a2
 8fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8fc:	ff053683          	ld	a3,-16(a0)
 900:	a091                	j	944 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	6398                	ld	a4,0(a5)
 904:	00e7e463          	bltu	a5,a4,90c <free+0x3a>
 908:	00e6ea63          	bltu	a3,a4,91c <free+0x4a>
{
 90c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	fed7fae3          	bgeu	a5,a3,902 <free+0x30>
 912:	6398                	ld	a4,0(a5)
 914:	00e6e463          	bltu	a3,a4,91c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	fee7eae3          	bltu	a5,a4,90c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 91c:	ff852583          	lw	a1,-8(a0)
 920:	6390                	ld	a2,0(a5)
 922:	02059813          	slli	a6,a1,0x20
 926:	01c85713          	srli	a4,a6,0x1c
 92a:	9736                	add	a4,a4,a3
 92c:	fae60de3          	beq	a2,a4,8e6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 930:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 934:	4790                	lw	a2,8(a5)
 936:	02061593          	slli	a1,a2,0x20
 93a:	01c5d713          	srli	a4,a1,0x1c
 93e:	973e                	add	a4,a4,a5
 940:	fae68ae3          	beq	a3,a4,8f4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 944:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 946:	00000717          	auipc	a4,0x0
 94a:	6af73d23          	sd	a5,1722(a4) # 1000 <freep>
}
 94e:	6422                	ld	s0,8(sp)
 950:	0141                	addi	sp,sp,16
 952:	8082                	ret

0000000000000954 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 954:	7139                	addi	sp,sp,-64
 956:	fc06                	sd	ra,56(sp)
 958:	f822                	sd	s0,48(sp)
 95a:	f426                	sd	s1,40(sp)
 95c:	ec4e                	sd	s3,24(sp)
 95e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 960:	02051493          	slli	s1,a0,0x20
 964:	9081                	srli	s1,s1,0x20
 966:	04bd                	addi	s1,s1,15
 968:	8091                	srli	s1,s1,0x4
 96a:	0014899b          	addiw	s3,s1,1
 96e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 970:	00000517          	auipc	a0,0x0
 974:	69053503          	ld	a0,1680(a0) # 1000 <freep>
 978:	c915                	beqz	a0,9ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97c:	4798                	lw	a4,8(a5)
 97e:	08977a63          	bgeu	a4,s1,a12 <malloc+0xbe>
 982:	f04a                	sd	s2,32(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 98a:	8a4e                	mv	s4,s3
 98c:	0009871b          	sext.w	a4,s3
 990:	6685                	lui	a3,0x1
 992:	00d77363          	bgeu	a4,a3,998 <malloc+0x44>
 996:	6a05                	lui	s4,0x1
 998:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a0:	00000917          	auipc	s2,0x0
 9a4:	66090913          	addi	s2,s2,1632 # 1000 <freep>
  if(p == (char*)-1)
 9a8:	5afd                	li	s5,-1
 9aa:	a081                	j	9ea <malloc+0x96>
 9ac:	f04a                	sd	s2,32(sp)
 9ae:	e852                	sd	s4,16(sp)
 9b0:	e456                	sd	s5,8(sp)
 9b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b4:	00000797          	auipc	a5,0x0
 9b8:	65c78793          	addi	a5,a5,1628 # 1010 <base>
 9bc:	00000717          	auipc	a4,0x0
 9c0:	64f73223          	sd	a5,1604(a4) # 1000 <freep>
 9c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ca:	b7c1                	j	98a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9cc:	6398                	ld	a4,0(a5)
 9ce:	e118                	sd	a4,0(a0)
 9d0:	a8a9                	j	a2a <malloc+0xd6>
  hp->s.size = nu;
 9d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d6:	0541                	addi	a0,a0,16
 9d8:	efbff0ef          	jal	8d2 <free>
  return freep;
 9dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e0:	c12d                	beqz	a0,a42 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e4:	4798                	lw	a4,8(a5)
 9e6:	02977263          	bgeu	a4,s1,a0a <malloc+0xb6>
    if(p == freep)
 9ea:	00093703          	ld	a4,0(s2)
 9ee:	853e                	mv	a0,a5
 9f0:	fef719e3          	bne	a4,a5,9e2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f4:	8552                	mv	a0,s4
 9f6:	b1bff0ef          	jal	510 <sbrk>
  if(p == (char*)-1)
 9fa:	fd551ce3          	bne	a0,s5,9d2 <malloc+0x7e>
        return 0;
 9fe:	4501                	li	a0,0
 a00:	7902                	ld	s2,32(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
 a08:	a03d                	j	a36 <malloc+0xe2>
 a0a:	7902                	ld	s2,32(sp)
 a0c:	6a42                	ld	s4,16(sp)
 a0e:	6aa2                	ld	s5,8(sp)
 a10:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a12:	fae48de3          	beq	s1,a4,9cc <malloc+0x78>
        p->s.size -= nunits;
 a16:	4137073b          	subw	a4,a4,s3
 a1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1c:	02071693          	slli	a3,a4,0x20
 a20:	01c6d713          	srli	a4,a3,0x1c
 a24:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a26:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a2a:	00000717          	auipc	a4,0x0
 a2e:	5ca73b23          	sd	a0,1494(a4) # 1000 <freep>
      return (void*)(p + 1);
 a32:	01078513          	addi	a0,a5,16
  }
}
 a36:	70e2                	ld	ra,56(sp)
 a38:	7442                	ld	s0,48(sp)
 a3a:	74a2                	ld	s1,40(sp)
 a3c:	69e2                	ld	s3,24(sp)
 a3e:	6121                	addi	sp,sp,64
 a40:	8082                	ret
 a42:	7902                	ld	s2,32(sp)
 a44:	6a42                	ld	s4,16(sp)
 a46:	6aa2                	ld	s5,8(sp)
 a48:	6b02                	ld	s6,0(sp)
 a4a:	b7f5                	j	a36 <malloc+0xe2>
