
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
  6c:	8aea                	mv	s5,s10
    int read_bytes, has_arg = 0, child_pid;
  6e:	4981                	li	s3,0
    }

    arg_s = arg_e = buf;
  70:	d9040913          	addi	s2,s0,-624

    while((read_bytes = read(0, &ch, sizeof(char))) == 1){
        if(arg_e >= buf + 512 - 1){
  74:	f8f40a13          	addi	s4,s0,-113
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
  80:	a24d8d93          	addi	s11,s11,-1500 # aa0 <malloc+0x126>
        if(ch == '\n' || ch == ' '){
  84:	02000b93          	li	s7,32
  88:	a811                	j	9c <main+0x9c>
            fprintf(2, "xargs: argument too long\n");
  8a:	00001597          	auipc	a1,0x1
  8e:	9f658593          	addi	a1,a1,-1546 # a80 <malloc+0x106>
  92:	4509                	li	a0,2
  94:	009000ef          	jal	89c <fprintf>
            arg_s = arg_e = buf; // reset buffer
  98:	d9040913          	addi	s2,s0,-624
    while((read_bytes = read(0, &ch, sizeof(char))) == 1){
  9c:	4605                	li	a2,1
  9e:	c8f40593          	addi	a1,s0,-881
  a2:	4501                	li	a0,0
  a4:	422000ef          	jal	4c6 <read>
  a8:	84aa                	mv	s1,a0
  aa:	4785                	li	a5,1
  ac:	08f51d63          	bne	a0,a5,146 <main+0x146>
        if(arg_e >= buf + 512 - 1){
  b0:	fd497de3          	bgeu	s2,s4,8a <main+0x8a>
        if(ch == '\n' || ch == ' '){
  b4:	c8f44783          	lbu	a5,-881(s0)
  b8:	13678063          	beq	a5,s6,1d8 <main+0x1d8>
  bc:	13778763          	beq	a5,s7,1ea <main+0x1ea>
                }
                x_argc = argc - 1; // reset arg list
                arg_s = arg_e = buf;
            }
        } else{
            *arg_e++ = ch;
  c0:	00f90023          	sb	a5,0(s2)
            has_arg = 1;
  c4:	89a6                	mv	s3,s1
            *arg_e++ = ch;
  c6:	0905                	addi	s2,s2,1
  c8:	bfd1                	j	9c <main+0x9c>
                    x_argv[x_argc] = 0;
  ca:	003a9793          	slli	a5,s5,0x3
  ce:	f9078793          	addi	a5,a5,-112
  d2:	97a2                	add	a5,a5,s0
  d4:	d007b023          	sd	zero,-768(a5)
                    if((child_pid = fork()) < 0){
  d8:	3ce000ef          	jal	4a6 <fork>
  dc:	84aa                	mv	s1,a0
  de:	00054863          	bltz	a0,ee <main+0xee>
                    } else if(child_pid == 0){
  e2:	c105                	beqz	a0,102 <main+0x102>
                x_argc = argc - 1; // reset arg list
  e4:	8aea                	mv	s5,s10
  e6:	4981                	li	s3,0
                arg_s = arg_e = buf;
  e8:	d9040913          	addi	s2,s0,-624
  ec:	bf45                	j	9c <main+0x9c>
                        fprintf(2, "xargs: fork failed\n");
  ee:	00001597          	auipc	a1,0x1
  f2:	9d258593          	addi	a1,a1,-1582 # ac0 <malloc+0x146>
  f6:	4509                	li	a0,2
  f8:	7a4000ef          	jal	89c <fprintf>
                        exit(1);
  fc:	4505                	li	a0,1
  fe:	3b0000ef          	jal	4ae <exit>
 102:	c9040913          	addi	s2,s0,-880
                            fprintf(2, "xargs: arg[%d] = %s\n", i, x_argv[i]);
 106:	00001997          	auipc	s3,0x1
 10a:	9d298993          	addi	s3,s3,-1582 # ad8 <malloc+0x15e>
 10e:	a811                	j	122 <main+0x122>
 110:	00093683          	ld	a3,0(s2)
 114:	8626                	mv	a2,s1
 116:	85ce                	mv	a1,s3
 118:	4509                	li	a0,2
 11a:	782000ef          	jal	89c <fprintf>
                        for(int i = 0; i < x_argc; i++){
 11e:	2485                	addiw	s1,s1,1
 120:	0921                	addi	s2,s2,8
 122:	ff54c7e3          	blt	s1,s5,110 <main+0x110>
                        exec(x_argv[0], x_argv);
 126:	c9040593          	addi	a1,s0,-880
 12a:	c9043503          	ld	a0,-880(s0)
 12e:	3b8000ef          	jal	4e6 <exec>
                        fprintf(2, "xargs: exec failed\n");
 132:	00001597          	auipc	a1,0x1
 136:	9be58593          	addi	a1,a1,-1602 # af0 <malloc+0x176>
 13a:	4509                	li	a0,2
 13c:	760000ef          	jal	89c <fprintf>
                        exit(1);
 140:	4505                	li	a0,1
 142:	36c000ef          	jal	4ae <exit>
        }
    }

    // execute the last command if input does not end with '\n'
    if(has_arg){
 146:	04098763          	beqz	s3,194 <main+0x194>
        *arg_e = '\0';
 14a:	00090023          	sb	zero,0(s2)
        if(x_argc >= MAXARG - 1){
 14e:	47f9                	li	a5,30
 150:	0157dc63          	bge	a5,s5,168 <main+0x168>
            fprintf(2, "xargs: too many arguments\n");
 154:	00001597          	auipc	a1,0x1
 158:	94c58593          	addi	a1,a1,-1716 # aa0 <malloc+0x126>
 15c:	4509                	li	a0,2
 15e:	73e000ef          	jal	89c <fprintf>
            exit(1);
 162:	4505                	li	a0,1
 164:	34a000ef          	jal	4ae <exit>
        }
        x_argv[x_argc++] = arg_s;
 168:	003a9793          	slli	a5,s5,0x3
 16c:	f9078793          	addi	a5,a5,-112
 170:	97a2                	add	a5,a5,s0
 172:	d9040713          	addi	a4,s0,-624
 176:	d0e7b023          	sd	a4,-768(a5)
        x_argv[x_argc] = 0;
 17a:	001a879b          	addiw	a5,s5,1
 17e:	078e                	slli	a5,a5,0x3
 180:	f9078793          	addi	a5,a5,-112
 184:	97a2                	add	a5,a5,s0
 186:	d007b023          	sd	zero,-768(a5)

        if((child_pid = fork()) < 0){
 18a:	31c000ef          	jal	4a6 <fork>
 18e:	00054b63          	bltz	a0,1a4 <main+0x1a4>
            fprintf(2, "xargs: fork failed\n");
            exit(1);
        } else if(child_pid == 0){
 192:	c11d                	beqz	a0,1b8 <main+0x1b8>
            fprintf(2, "xargs: exec failed\n");
            exit(1);
        }
    }

    while(wait(0) > 0);
 194:	4501                	li	a0,0
 196:	320000ef          	jal	4b6 <wait>
 19a:	fea04de3          	bgtz	a0,194 <main+0x194>

    exit(0);
 19e:	4501                	li	a0,0
 1a0:	30e000ef          	jal	4ae <exit>
            fprintf(2, "xargs: fork failed\n");
 1a4:	00001597          	auipc	a1,0x1
 1a8:	91c58593          	addi	a1,a1,-1764 # ac0 <malloc+0x146>
 1ac:	4509                	li	a0,2
 1ae:	6ee000ef          	jal	89c <fprintf>
            exit(1);
 1b2:	4505                	li	a0,1
 1b4:	2fa000ef          	jal	4ae <exit>
            exec(x_argv[0], x_argv);
 1b8:	c9040593          	addi	a1,s0,-880
 1bc:	c9043503          	ld	a0,-880(s0)
 1c0:	326000ef          	jal	4e6 <exec>
            fprintf(2, "xargs: exec failed\n");
 1c4:	00001597          	auipc	a1,0x1
 1c8:	92c58593          	addi	a1,a1,-1748 # af0 <malloc+0x176>
 1cc:	4509                	li	a0,2
 1ce:	6ce000ef          	jal	89c <fprintf>
            exit(1);
 1d2:	4505                	li	a0,1
 1d4:	2da000ef          	jal	4ae <exit>
            if(has_arg){
 1d8:	04099963          	bnez	s3,22a <main+0x22a>
                if(x_argc > argc - 1){
 1dc:	ef8ad7e3          	bge	s5,s8,ca <main+0xca>
                x_argc = argc - 1; // reset arg list
 1e0:	8aea                	mv	s5,s10
 1e2:	4981                	li	s3,0
                arg_s = arg_e = buf;
 1e4:	d9040913          	addi	s2,s0,-624
 1e8:	bd55                	j	9c <main+0x9c>
            if(has_arg){
 1ea:	00099463          	bnez	s3,1f2 <main+0x1f2>
            arg_e++;
 1ee:	0905                	addi	s2,s2,1
            if(ch == '\n'){
 1f0:	b575                	j	9c <main+0x9c>
                *arg_e = '\0';
 1f2:	00090023          	sb	zero,0(s2)
                if(x_argc >= MAXARG - 1){
 1f6:	035cce63          	blt	s9,s5,232 <main+0x232>
                x_argv[x_argc++] = arg_s;
 1fa:	003a9793          	slli	a5,s5,0x3
 1fe:	f9078793          	addi	a5,a5,-112
 202:	97a2                	add	a5,a5,s0
 204:	d9040713          	addi	a4,s0,-624
 208:	d0e7b023          	sd	a4,-768(a5)
            arg_e++;
 20c:	0905                	addi	s2,s2,1
                x_argv[x_argc++] = arg_s;
 20e:	2a85                	addiw	s5,s5,1
            arg_e++;
 210:	4981                	li	s3,0
 212:	b569                	j	9c <main+0x9c>
                x_argv[x_argc++] = arg_s;
 214:	003a9793          	slli	a5,s5,0x3
 218:	f9078793          	addi	a5,a5,-112
 21c:	97a2                	add	a5,a5,s0
 21e:	d9040713          	addi	a4,s0,-624
 222:	d0e7b023          	sd	a4,-768(a5)
 226:	2a85                	addiw	s5,s5,1
 228:	bf55                	j	1dc <main+0x1dc>
                *arg_e = '\0';
 22a:	00090023          	sb	zero,0(s2)
                if(x_argc >= MAXARG - 1){
 22e:	ff5cd3e3          	bge	s9,s5,214 <main+0x214>
                    fprintf(2, "xargs: too many arguments\n");
 232:	85ee                	mv	a1,s11
 234:	4509                	li	a0,2
 236:	666000ef          	jal	89c <fprintf>
                    continue;
 23a:	89a6                	mv	s3,s1
                    x_argc = argc - 1;
 23c:	8aea                	mv	s5,s10
                    arg_s = arg_e = buf;
 23e:	d9040913          	addi	s2,s0,-624
                    continue;
 242:	bda9                	j	9c <main+0x9c>

0000000000000244 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 24c:	db5ff0ef          	jal	0 <main>
  exit(0);
 250:	4501                	li	a0,0
 252:	25c000ef          	jal	4ae <exit>

0000000000000256 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25c:	87aa                	mv	a5,a0
 25e:	0585                	addi	a1,a1,1
 260:	0785                	addi	a5,a5,1
 262:	fff5c703          	lbu	a4,-1(a1)
 266:	fee78fa3          	sb	a4,-1(a5)
 26a:	fb75                	bnez	a4,25e <strcpy+0x8>
    ;
  return os;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret

0000000000000272 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	cb91                	beqz	a5,290 <strcmp+0x1e>
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00f71763          	bne	a4,a5,290 <strcmp+0x1e>
    p++, q++;
 286:	0505                	addi	a0,a0,1
 288:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	fbe5                	bnez	a5,27e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 290:	0005c503          	lbu	a0,0(a1)
}
 294:	40a7853b          	subw	a0,a5,a0
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret

000000000000029e <strlen>:

uint
strlen(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	cf91                	beqz	a5,2c4 <strlen+0x26>
 2aa:	0505                	addi	a0,a0,1
 2ac:	87aa                	mv	a5,a0
 2ae:	86be                	mv	a3,a5
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff7c703          	lbu	a4,-1(a5)
 2b6:	ff65                	bnez	a4,2ae <strlen+0x10>
 2b8:	40a6853b          	subw	a0,a3,a0
 2bc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  for(n = 0; s[n]; n++)
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <strlen+0x20>

00000000000002c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ce:	ca19                	beqz	a2,2e4 <memset+0x1c>
 2d0:	87aa                	mv	a5,a0
 2d2:	1602                	slli	a2,a2,0x20
 2d4:	9201                	srli	a2,a2,0x20
 2d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2de:	0785                	addi	a5,a5,1
 2e0:	fee79de3          	bne	a5,a4,2da <memset+0x12>
  }
  return dst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strchr>:

char*
strchr(const char *s, char c)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cb99                	beqz	a5,30a <strchr+0x20>
    if(*s == c)
 2f6:	00f58763          	beq	a1,a5,304 <strchr+0x1a>
  for(; *s; s++)
 2fa:	0505                	addi	a0,a0,1
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbfd                	bnez	a5,2f6 <strchr+0xc>
      return (char*)s;
  return 0;
 302:	4501                	li	a0,0
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  return 0;
 30a:	4501                	li	a0,0
 30c:	bfe5                	j	304 <strchr+0x1a>

000000000000030e <gets>:

char*
gets(char *buf, int max)
{
 30e:	711d                	addi	sp,sp,-96
 310:	ec86                	sd	ra,88(sp)
 312:	e8a2                	sd	s0,80(sp)
 314:	e4a6                	sd	s1,72(sp)
 316:	e0ca                	sd	s2,64(sp)
 318:	fc4e                	sd	s3,56(sp)
 31a:	f852                	sd	s4,48(sp)
 31c:	f456                	sd	s5,40(sp)
 31e:	f05a                	sd	s6,32(sp)
 320:	ec5e                	sd	s7,24(sp)
 322:	1080                	addi	s0,sp,96
 324:	8baa                	mv	s7,a0
 326:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 328:	892a                	mv	s2,a0
 32a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 32c:	4aa9                	li	s5,10
 32e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 330:	89a6                	mv	s3,s1
 332:	2485                	addiw	s1,s1,1
 334:	0344d663          	bge	s1,s4,360 <gets+0x52>
    cc = read(0, &c, 1);
 338:	4605                	li	a2,1
 33a:	faf40593          	addi	a1,s0,-81
 33e:	4501                	li	a0,0
 340:	186000ef          	jal	4c6 <read>
    if(cc < 1)
 344:	00a05e63          	blez	a0,360 <gets+0x52>
    buf[i++] = c;
 348:	faf44783          	lbu	a5,-81(s0)
 34c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 350:	01578763          	beq	a5,s5,35e <gets+0x50>
 354:	0905                	addi	s2,s2,1
 356:	fd679de3          	bne	a5,s6,330 <gets+0x22>
    buf[i++] = c;
 35a:	89a6                	mv	s3,s1
 35c:	a011                	j	360 <gets+0x52>
 35e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 360:	99de                	add	s3,s3,s7
 362:	00098023          	sb	zero,0(s3)
  return buf;
}
 366:	855e                	mv	a0,s7
 368:	60e6                	ld	ra,88(sp)
 36a:	6446                	ld	s0,80(sp)
 36c:	64a6                	ld	s1,72(sp)
 36e:	6906                	ld	s2,64(sp)
 370:	79e2                	ld	s3,56(sp)
 372:	7a42                	ld	s4,48(sp)
 374:	7aa2                	ld	s5,40(sp)
 376:	7b02                	ld	s6,32(sp)
 378:	6be2                	ld	s7,24(sp)
 37a:	6125                	addi	sp,sp,96
 37c:	8082                	ret

000000000000037e <stat>:

int
stat(const char *n, struct stat *st)
{
 37e:	1101                	addi	sp,sp,-32
 380:	ec06                	sd	ra,24(sp)
 382:	e822                	sd	s0,16(sp)
 384:	e04a                	sd	s2,0(sp)
 386:	1000                	addi	s0,sp,32
 388:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 38a:	4581                	li	a1,0
 38c:	162000ef          	jal	4ee <open>
  if(fd < 0)
 390:	02054263          	bltz	a0,3b4 <stat+0x36>
 394:	e426                	sd	s1,8(sp)
 396:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 398:	85ca                	mv	a1,s2
 39a:	16c000ef          	jal	506 <fstat>
 39e:	892a                	mv	s2,a0
  close(fd);
 3a0:	8526                	mv	a0,s1
 3a2:	134000ef          	jal	4d6 <close>
  return r;
 3a6:	64a2                	ld	s1,8(sp)
}
 3a8:	854a                	mv	a0,s2
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	6902                	ld	s2,0(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret
    return -1;
 3b4:	597d                	li	s2,-1
 3b6:	bfcd                	j	3a8 <stat+0x2a>

00000000000003b8 <atoi>:

int
atoi(const char *s)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3be:	00054683          	lbu	a3,0(a0)
 3c2:	fd06879b          	addiw	a5,a3,-48
 3c6:	0ff7f793          	zext.b	a5,a5
 3ca:	4625                	li	a2,9
 3cc:	02f66863          	bltu	a2,a5,3fc <atoi+0x44>
 3d0:	872a                	mv	a4,a0
  n = 0;
 3d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d4:	0705                	addi	a4,a4,1
 3d6:	0025179b          	slliw	a5,a0,0x2
 3da:	9fa9                	addw	a5,a5,a0
 3dc:	0017979b          	slliw	a5,a5,0x1
 3e0:	9fb5                	addw	a5,a5,a3
 3e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e6:	00074683          	lbu	a3,0(a4)
 3ea:	fd06879b          	addiw	a5,a3,-48
 3ee:	0ff7f793          	zext.b	a5,a5
 3f2:	fef671e3          	bgeu	a2,a5,3d4 <atoi+0x1c>
  return n;
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  n = 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <atoi+0x3e>

0000000000000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 406:	02b57463          	bgeu	a0,a1,42e <memmove+0x2e>
    while(n-- > 0)
 40a:	00c05f63          	blez	a2,428 <memmove+0x28>
 40e:	1602                	slli	a2,a2,0x20
 410:	9201                	srli	a2,a2,0x20
 412:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 416:	872a                	mv	a4,a0
      *dst++ = *src++;
 418:	0585                	addi	a1,a1,1
 41a:	0705                	addi	a4,a4,1
 41c:	fff5c683          	lbu	a3,-1(a1)
 420:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 424:	fef71ae3          	bne	a4,a5,418 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
    dst += n;
 42e:	00c50733          	add	a4,a0,a2
    src += n;
 432:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 434:	fec05ae3          	blez	a2,428 <memmove+0x28>
 438:	fff6079b          	addiw	a5,a2,-1
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	fff7c793          	not	a5,a5
 444:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 446:	15fd                	addi	a1,a1,-1
 448:	177d                	addi	a4,a4,-1
 44a:	0005c683          	lbu	a3,0(a1)
 44e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 452:	fee79ae3          	bne	a5,a4,446 <memmove+0x46>
 456:	bfc9                	j	428 <memmove+0x28>

0000000000000458 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 45e:	ca05                	beqz	a2,48e <memcmp+0x36>
 460:	fff6069b          	addiw	a3,a2,-1
 464:	1682                	slli	a3,a3,0x20
 466:	9281                	srli	a3,a3,0x20
 468:	0685                	addi	a3,a3,1
 46a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 46c:	00054783          	lbu	a5,0(a0)
 470:	0005c703          	lbu	a4,0(a1)
 474:	00e79863          	bne	a5,a4,484 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 478:	0505                	addi	a0,a0,1
    p2++;
 47a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47c:	fed518e3          	bne	a0,a3,46c <memcmp+0x14>
  }
  return 0;
 480:	4501                	li	a0,0
 482:	a019                	j	488 <memcmp+0x30>
      return *p1 - *p2;
 484:	40e7853b          	subw	a0,a5,a4
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  return 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <memcmp+0x30>

0000000000000492 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e406                	sd	ra,8(sp)
 496:	e022                	sd	s0,0(sp)
 498:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 49a:	f67ff0ef          	jal	400 <memmove>
}
 49e:	60a2                	ld	ra,8(sp)
 4a0:	6402                	ld	s0,0(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a6:	4885                	li	a7,1
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ae:	4889                	li	a7,2
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b6:	488d                	li	a7,3
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4be:	4891                	li	a7,4
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <read>:
.global read
read:
 li a7, SYS_read
 4c6:	4895                	li	a7,5
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <write>:
.global write
write:
 li a7, SYS_write
 4ce:	48c1                	li	a7,16
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <close>:
.global close
close:
 li a7, SYS_close
 4d6:	48d5                	li	a7,21
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <kill>:
.global kill
kill:
 li a7, SYS_kill
 4de:	4899                	li	a7,6
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e6:	489d                	li	a7,7
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <open>:
.global open
open:
 li a7, SYS_open
 4ee:	48bd                	li	a7,15
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f6:	48c5                	li	a7,17
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4fe:	48c9                	li	a7,18
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 506:	48a1                	li	a7,8
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <link>:
.global link
link:
 li a7, SYS_link
 50e:	48cd                	li	a7,19
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 516:	48d1                	li	a7,20
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51e:	48a5                	li	a7,9
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <dup>:
.global dup
dup:
 li a7, SYS_dup
 526:	48a9                	li	a7,10
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52e:	48ad                	li	a7,11
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 536:	48b1                	li	a7,12
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53e:	48b5                	li	a7,13
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 546:	48b9                	li	a7,14
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 54e:	1101                	addi	sp,sp,-32
 550:	ec06                	sd	ra,24(sp)
 552:	e822                	sd	s0,16(sp)
 554:	1000                	addi	s0,sp,32
 556:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 55a:	4605                	li	a2,1
 55c:	fef40593          	addi	a1,s0,-17
 560:	f6fff0ef          	jal	4ce <write>
}
 564:	60e2                	ld	ra,24(sp)
 566:	6442                	ld	s0,16(sp)
 568:	6105                	addi	sp,sp,32
 56a:	8082                	ret

000000000000056c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 56c:	7139                	addi	sp,sp,-64
 56e:	fc06                	sd	ra,56(sp)
 570:	f822                	sd	s0,48(sp)
 572:	f426                	sd	s1,40(sp)
 574:	0080                	addi	s0,sp,64
 576:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 578:	c299                	beqz	a3,57e <printint+0x12>
 57a:	0805c963          	bltz	a1,60c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57e:	2581                	sext.w	a1,a1
  neg = 0;
 580:	4881                	li	a7,0
 582:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 586:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 588:	2601                	sext.w	a2,a2
 58a:	00000517          	auipc	a0,0x0
 58e:	58650513          	addi	a0,a0,1414 # b10 <digits>
 592:	883a                	mv	a6,a4
 594:	2705                	addiw	a4,a4,1
 596:	02c5f7bb          	remuw	a5,a1,a2
 59a:	1782                	slli	a5,a5,0x20
 59c:	9381                	srli	a5,a5,0x20
 59e:	97aa                	add	a5,a5,a0
 5a0:	0007c783          	lbu	a5,0(a5)
 5a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a8:	0005879b          	sext.w	a5,a1
 5ac:	02c5d5bb          	divuw	a1,a1,a2
 5b0:	0685                	addi	a3,a3,1
 5b2:	fec7f0e3          	bgeu	a5,a2,592 <printint+0x26>
  if(neg)
 5b6:	00088c63          	beqz	a7,5ce <printint+0x62>
    buf[i++] = '-';
 5ba:	fd070793          	addi	a5,a4,-48
 5be:	00878733          	add	a4,a5,s0
 5c2:	02d00793          	li	a5,45
 5c6:	fef70823          	sb	a5,-16(a4)
 5ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ce:	02e05a63          	blez	a4,602 <printint+0x96>
 5d2:	f04a                	sd	s2,32(sp)
 5d4:	ec4e                	sd	s3,24(sp)
 5d6:	fc040793          	addi	a5,s0,-64
 5da:	00e78933          	add	s2,a5,a4
 5de:	fff78993          	addi	s3,a5,-1
 5e2:	99ba                	add	s3,s3,a4
 5e4:	377d                	addiw	a4,a4,-1
 5e6:	1702                	slli	a4,a4,0x20
 5e8:	9301                	srli	a4,a4,0x20
 5ea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ee:	fff94583          	lbu	a1,-1(s2)
 5f2:	8526                	mv	a0,s1
 5f4:	f5bff0ef          	jal	54e <putc>
  while(--i >= 0)
 5f8:	197d                	addi	s2,s2,-1
 5fa:	ff391ae3          	bne	s2,s3,5ee <printint+0x82>
 5fe:	7902                	ld	s2,32(sp)
 600:	69e2                	ld	s3,24(sp)
}
 602:	70e2                	ld	ra,56(sp)
 604:	7442                	ld	s0,48(sp)
 606:	74a2                	ld	s1,40(sp)
 608:	6121                	addi	sp,sp,64
 60a:	8082                	ret
    x = -xx;
 60c:	40b005bb          	negw	a1,a1
    neg = 1;
 610:	4885                	li	a7,1
    x = -xx;
 612:	bf85                	j	582 <printint+0x16>

0000000000000614 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 614:	711d                	addi	sp,sp,-96
 616:	ec86                	sd	ra,88(sp)
 618:	e8a2                	sd	s0,80(sp)
 61a:	e0ca                	sd	s2,64(sp)
 61c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 61e:	0005c903          	lbu	s2,0(a1)
 622:	26090863          	beqz	s2,892 <vprintf+0x27e>
 626:	e4a6                	sd	s1,72(sp)
 628:	fc4e                	sd	s3,56(sp)
 62a:	f852                	sd	s4,48(sp)
 62c:	f456                	sd	s5,40(sp)
 62e:	f05a                	sd	s6,32(sp)
 630:	ec5e                	sd	s7,24(sp)
 632:	e862                	sd	s8,16(sp)
 634:	e466                	sd	s9,8(sp)
 636:	8b2a                	mv	s6,a0
 638:	8a2e                	mv	s4,a1
 63a:	8bb2                	mv	s7,a2
  state = 0;
 63c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 63e:	4481                	li	s1,0
 640:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 642:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 646:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 64a:	06c00c93          	li	s9,108
 64e:	a005                	j	66e <vprintf+0x5a>
        putc(fd, c0);
 650:	85ca                	mv	a1,s2
 652:	855a                	mv	a0,s6
 654:	efbff0ef          	jal	54e <putc>
 658:	a019                	j	65e <vprintf+0x4a>
    } else if(state == '%'){
 65a:	03598263          	beq	s3,s5,67e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 65e:	2485                	addiw	s1,s1,1
 660:	8726                	mv	a4,s1
 662:	009a07b3          	add	a5,s4,s1
 666:	0007c903          	lbu	s2,0(a5)
 66a:	20090c63          	beqz	s2,882 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 66e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 672:	fe0994e3          	bnez	s3,65a <vprintf+0x46>
      if(c0 == '%'){
 676:	fd579de3          	bne	a5,s5,650 <vprintf+0x3c>
        state = '%';
 67a:	89be                	mv	s3,a5
 67c:	b7cd                	j	65e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 67e:	00ea06b3          	add	a3,s4,a4
 682:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 686:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 688:	c681                	beqz	a3,690 <vprintf+0x7c>
 68a:	9752                	add	a4,a4,s4
 68c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 690:	03878f63          	beq	a5,s8,6ce <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 694:	05978963          	beq	a5,s9,6e6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 698:	07500713          	li	a4,117
 69c:	0ee78363          	beq	a5,a4,782 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6a0:	07800713          	li	a4,120
 6a4:	12e78563          	beq	a5,a4,7ce <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6a8:	07000713          	li	a4,112
 6ac:	14e78a63          	beq	a5,a4,800 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6b0:	07300713          	li	a4,115
 6b4:	18e78a63          	beq	a5,a4,848 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6b8:	02500713          	li	a4,37
 6bc:	04e79563          	bne	a5,a4,706 <vprintf+0xf2>
        putc(fd, '%');
 6c0:	02500593          	li	a1,37
 6c4:	855a                	mv	a0,s6
 6c6:	e89ff0ef          	jal	54e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bf49                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4685                	li	a3,1
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e91ff0ef          	jal	56c <printint>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bfad                	j	65e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6e6:	06400793          	li	a5,100
 6ea:	02f68963          	beq	a3,a5,71c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ee:	06c00793          	li	a5,108
 6f2:	04f68263          	beq	a3,a5,736 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6f6:	07500793          	li	a5,117
 6fa:	0af68063          	beq	a3,a5,79a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6fe:	07800793          	li	a5,120
 702:	0ef68263          	beq	a3,a5,7e6 <vprintf+0x1d2>
        putc(fd, '%');
 706:	02500593          	li	a1,37
 70a:	855a                	mv	a0,s6
 70c:	e43ff0ef          	jal	54e <putc>
        putc(fd, c0);
 710:	85ca                	mv	a1,s2
 712:	855a                	mv	a0,s6
 714:	e3bff0ef          	jal	54e <putc>
      state = 0;
 718:	4981                	li	s3,0
 71a:	b791                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 71c:	008b8913          	addi	s2,s7,8
 720:	4685                	li	a3,1
 722:	4629                	li	a2,10
 724:	000ba583          	lw	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	e43ff0ef          	jal	56c <printint>
        i += 1;
 72e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
        i += 1;
 734:	b72d                	j	65e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 736:	06400793          	li	a5,100
 73a:	02f60763          	beq	a2,a5,768 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 73e:	07500793          	li	a5,117
 742:	06f60963          	beq	a2,a5,7b4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 746:	07800793          	li	a5,120
 74a:	faf61ee3          	bne	a2,a5,706 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 74e:	008b8913          	addi	s2,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000ba583          	lw	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	e11ff0ef          	jal	56c <printint>
        i += 2;
 760:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	bde5                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	008b8913          	addi	s2,s7,8
 76c:	4685                	li	a3,1
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	df7ff0ef          	jal	56c <printint>
        i += 2;
 77a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 2;
 780:	bdf9                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	dddff0ef          	jal	56c <printint>
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	b5d9                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 79a:	008b8913          	addi	s2,s7,8
 79e:	4681                	li	a3,0
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	dc5ff0ef          	jal	56c <printint>
        i += 1;
 7ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
        i += 1;
 7b2:	b575                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	dabff0ef          	jal	56c <printint>
        i += 2;
 7c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 2;
 7cc:	bd49                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	d91ff0ef          	jal	56c <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bdad                	j	65e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	d79ff0ef          	jal	56c <printint>
        i += 1;
 7f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
        i += 1;
 7fe:	b585                	j	65e <vprintf+0x4a>
 800:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 802:	008b8d13          	addi	s10,s7,8
 806:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 80a:	03000593          	li	a1,48
 80e:	855a                	mv	a0,s6
 810:	d3fff0ef          	jal	54e <putc>
  putc(fd, 'x');
 814:	07800593          	li	a1,120
 818:	855a                	mv	a0,s6
 81a:	d35ff0ef          	jal	54e <putc>
 81e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 820:	00000b97          	auipc	s7,0x0
 824:	2f0b8b93          	addi	s7,s7,752 # b10 <digits>
 828:	03c9d793          	srli	a5,s3,0x3c
 82c:	97de                	add	a5,a5,s7
 82e:	0007c583          	lbu	a1,0(a5)
 832:	855a                	mv	a0,s6
 834:	d1bff0ef          	jal	54e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 838:	0992                	slli	s3,s3,0x4
 83a:	397d                	addiw	s2,s2,-1
 83c:	fe0916e3          	bnez	s2,828 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 840:	8bea                	mv	s7,s10
      state = 0;
 842:	4981                	li	s3,0
 844:	6d02                	ld	s10,0(sp)
 846:	bd21                	j	65e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 848:	008b8993          	addi	s3,s7,8
 84c:	000bb903          	ld	s2,0(s7)
 850:	00090f63          	beqz	s2,86e <vprintf+0x25a>
        for(; *s; s++)
 854:	00094583          	lbu	a1,0(s2)
 858:	c195                	beqz	a1,87c <vprintf+0x268>
          putc(fd, *s);
 85a:	855a                	mv	a0,s6
 85c:	cf3ff0ef          	jal	54e <putc>
        for(; *s; s++)
 860:	0905                	addi	s2,s2,1
 862:	00094583          	lbu	a1,0(s2)
 866:	f9f5                	bnez	a1,85a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 868:	8bce                	mv	s7,s3
      state = 0;
 86a:	4981                	li	s3,0
 86c:	bbcd                	j	65e <vprintf+0x4a>
          s = "(null)";
 86e:	00000917          	auipc	s2,0x0
 872:	29a90913          	addi	s2,s2,666 # b08 <malloc+0x18e>
        for(; *s; s++)
 876:	02800593          	li	a1,40
 87a:	b7c5                	j	85a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 87c:	8bce                	mv	s7,s3
      state = 0;
 87e:	4981                	li	s3,0
 880:	bbf9                	j	65e <vprintf+0x4a>
 882:	64a6                	ld	s1,72(sp)
 884:	79e2                	ld	s3,56(sp)
 886:	7a42                	ld	s4,48(sp)
 888:	7aa2                	ld	s5,40(sp)
 88a:	7b02                	ld	s6,32(sp)
 88c:	6be2                	ld	s7,24(sp)
 88e:	6c42                	ld	s8,16(sp)
 890:	6ca2                	ld	s9,8(sp)
    }
  }
}
 892:	60e6                	ld	ra,88(sp)
 894:	6446                	ld	s0,80(sp)
 896:	6906                	ld	s2,64(sp)
 898:	6125                	addi	sp,sp,96
 89a:	8082                	ret

000000000000089c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 89c:	715d                	addi	sp,sp,-80
 89e:	ec06                	sd	ra,24(sp)
 8a0:	e822                	sd	s0,16(sp)
 8a2:	1000                	addi	s0,sp,32
 8a4:	e010                	sd	a2,0(s0)
 8a6:	e414                	sd	a3,8(s0)
 8a8:	e818                	sd	a4,16(s0)
 8aa:	ec1c                	sd	a5,24(s0)
 8ac:	03043023          	sd	a6,32(s0)
 8b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b8:	8622                	mv	a2,s0
 8ba:	d5bff0ef          	jal	614 <vprintf>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6161                	addi	sp,sp,80
 8c4:	8082                	ret

00000000000008c6 <printf>:

void
printf(const char *fmt, ...)
{
 8c6:	711d                	addi	sp,sp,-96
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	addi	s0,sp,32
 8ce:	e40c                	sd	a1,8(s0)
 8d0:	e810                	sd	a2,16(s0)
 8d2:	ec14                	sd	a3,24(s0)
 8d4:	f018                	sd	a4,32(s0)
 8d6:	f41c                	sd	a5,40(s0)
 8d8:	03043823          	sd	a6,48(s0)
 8dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e0:	00840613          	addi	a2,s0,8
 8e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e8:	85aa                	mv	a1,a0
 8ea:	4505                	li	a0,1
 8ec:	d29ff0ef          	jal	614 <vprintf>
}
 8f0:	60e2                	ld	ra,24(sp)
 8f2:	6442                	ld	s0,16(sp)
 8f4:	6125                	addi	sp,sp,96
 8f6:	8082                	ret

00000000000008f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f8:	1141                	addi	sp,sp,-16
 8fa:	e422                	sd	s0,8(sp)
 8fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 902:	00000797          	auipc	a5,0x0
 906:	6fe7b783          	ld	a5,1790(a5) # 1000 <freep>
 90a:	a02d                	j	934 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90c:	4618                	lw	a4,8(a2)
 90e:	9f2d                	addw	a4,a4,a1
 910:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 914:	6398                	ld	a4,0(a5)
 916:	6310                	ld	a2,0(a4)
 918:	a83d                	j	956 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91a:	ff852703          	lw	a4,-8(a0)
 91e:	9f31                	addw	a4,a4,a2
 920:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 922:	ff053683          	ld	a3,-16(a0)
 926:	a091                	j	96a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 928:	6398                	ld	a4,0(a5)
 92a:	00e7e463          	bltu	a5,a4,932 <free+0x3a>
 92e:	00e6ea63          	bltu	a3,a4,942 <free+0x4a>
{
 932:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 934:	fed7fae3          	bgeu	a5,a3,928 <free+0x30>
 938:	6398                	ld	a4,0(a5)
 93a:	00e6e463          	bltu	a3,a4,942 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93e:	fee7eae3          	bltu	a5,a4,932 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 942:	ff852583          	lw	a1,-8(a0)
 946:	6390                	ld	a2,0(a5)
 948:	02059813          	slli	a6,a1,0x20
 94c:	01c85713          	srli	a4,a6,0x1c
 950:	9736                	add	a4,a4,a3
 952:	fae60de3          	beq	a2,a4,90c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 956:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95a:	4790                	lw	a2,8(a5)
 95c:	02061593          	slli	a1,a2,0x20
 960:	01c5d713          	srli	a4,a1,0x1c
 964:	973e                	add	a4,a4,a5
 966:	fae68ae3          	beq	a3,a4,91a <free+0x22>
    p->s.ptr = bp->s.ptr;
 96a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96c:	00000717          	auipc	a4,0x0
 970:	68f73a23          	sd	a5,1684(a4) # 1000 <freep>
}
 974:	6422                	ld	s0,8(sp)
 976:	0141                	addi	sp,sp,16
 978:	8082                	ret

000000000000097a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97a:	7139                	addi	sp,sp,-64
 97c:	fc06                	sd	ra,56(sp)
 97e:	f822                	sd	s0,48(sp)
 980:	f426                	sd	s1,40(sp)
 982:	ec4e                	sd	s3,24(sp)
 984:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 986:	02051493          	slli	s1,a0,0x20
 98a:	9081                	srli	s1,s1,0x20
 98c:	04bd                	addi	s1,s1,15
 98e:	8091                	srli	s1,s1,0x4
 990:	0014899b          	addiw	s3,s1,1
 994:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 996:	00000517          	auipc	a0,0x0
 99a:	66a53503          	ld	a0,1642(a0) # 1000 <freep>
 99e:	c915                	beqz	a0,9d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a2:	4798                	lw	a4,8(a5)
 9a4:	08977a63          	bgeu	a4,s1,a38 <malloc+0xbe>
 9a8:	f04a                	sd	s2,32(sp)
 9aa:	e852                	sd	s4,16(sp)
 9ac:	e456                	sd	s5,8(sp)
 9ae:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b0:	8a4e                	mv	s4,s3
 9b2:	0009871b          	sext.w	a4,s3
 9b6:	6685                	lui	a3,0x1
 9b8:	00d77363          	bgeu	a4,a3,9be <malloc+0x44>
 9bc:	6a05                	lui	s4,0x1
 9be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c6:	00000917          	auipc	s2,0x0
 9ca:	63a90913          	addi	s2,s2,1594 # 1000 <freep>
  if(p == (char*)-1)
 9ce:	5afd                	li	s5,-1
 9d0:	a081                	j	a10 <malloc+0x96>
 9d2:	f04a                	sd	s2,32(sp)
 9d4:	e852                	sd	s4,16(sp)
 9d6:	e456                	sd	s5,8(sp)
 9d8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9da:	00000797          	auipc	a5,0x0
 9de:	63678793          	addi	a5,a5,1590 # 1010 <base>
 9e2:	00000717          	auipc	a4,0x0
 9e6:	60f73f23          	sd	a5,1566(a4) # 1000 <freep>
 9ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f0:	b7c1                	j	9b0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9f2:	6398                	ld	a4,0(a5)
 9f4:	e118                	sd	a4,0(a0)
 9f6:	a8a9                	j	a50 <malloc+0xd6>
  hp->s.size = nu;
 9f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fc:	0541                	addi	a0,a0,16
 9fe:	efbff0ef          	jal	8f8 <free>
  return freep;
 a02:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a06:	c12d                	beqz	a0,a68 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0a:	4798                	lw	a4,8(a5)
 a0c:	02977263          	bgeu	a4,s1,a30 <malloc+0xb6>
    if(p == freep)
 a10:	00093703          	ld	a4,0(s2)
 a14:	853e                	mv	a0,a5
 a16:	fef719e3          	bne	a4,a5,a08 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a1a:	8552                	mv	a0,s4
 a1c:	b1bff0ef          	jal	536 <sbrk>
  if(p == (char*)-1)
 a20:	fd551ce3          	bne	a0,s5,9f8 <malloc+0x7e>
        return 0;
 a24:	4501                	li	a0,0
 a26:	7902                	ld	s2,32(sp)
 a28:	6a42                	ld	s4,16(sp)
 a2a:	6aa2                	ld	s5,8(sp)
 a2c:	6b02                	ld	s6,0(sp)
 a2e:	a03d                	j	a5c <malloc+0xe2>
 a30:	7902                	ld	s2,32(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a38:	fae48de3          	beq	s1,a4,9f2 <malloc+0x78>
        p->s.size -= nunits;
 a3c:	4137073b          	subw	a4,a4,s3
 a40:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a42:	02071693          	slli	a3,a4,0x20
 a46:	01c6d713          	srli	a4,a3,0x1c
 a4a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a50:	00000717          	auipc	a4,0x0
 a54:	5aa73823          	sd	a0,1456(a4) # 1000 <freep>
      return (void*)(p + 1);
 a58:	01078513          	addi	a0,a5,16
  }
}
 a5c:	70e2                	ld	ra,56(sp)
 a5e:	7442                	ld	s0,48(sp)
 a60:	74a2                	ld	s1,40(sp)
 a62:	69e2                	ld	s3,24(sp)
 a64:	6121                	addi	sp,sp,64
 a66:	8082                	ret
 a68:	7902                	ld	s2,32(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	b7f5                	j	a5c <malloc+0xe2>
