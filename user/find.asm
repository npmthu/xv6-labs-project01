
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h" // User-level system calls (open, read, close, stat, printf, etc.)
#include "kernel/fs.h" // File system structure (such as directory entry dirent)

// Find all files in the current directory and its subdirectories
// Find function: Recursively search for files in the current directory and its subdirectories
void find(char* path, char *target) {
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	25213823          	sd	s2,592(sp)
  10:	25313423          	sd	s3,584(sp)
  14:	1c80                	addi	s0,sp,624
  16:	89aa                	mv	s3,a0
  18:	892e                	mv	s2,a1
    struct dirent de; // A dirent structure to store the file dir entry (name, inode#)
    struct stat st; // A stat structure to store the file metadata (type, size)
    // Dirent vs stat: dirent stores basic file info (name, inode#), stat stores more detailed file info (type, size)

    // Open the directory
    if((fd = open(path, 0)) < 0){
  1a:	4581                	li	a1,0
  1c:	482000ef          	jal	49e <open>
  20:	0c054b63          	bltz	a0,f6 <find+0xf6>
  24:	24913c23          	sd	s1,600(sp)
  28:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path); // Error message if the directory cannot be opened
        return;
    }

    // Get metadata of the dir using fstat
    if(fstat(fd, &st) < 0) {
  2a:	d9840593          	addi	a1,s0,-616
  2e:	488000ef          	jal	4b6 <fstat>
  32:	0c054b63          	bltz	a0,108 <find+0x108>
        close(fd); // Close the directory
        return;
    }

    // Check if the dir is a directory
    if (st.type != T_DIR) {
  36:	da041703          	lh	a4,-608(s0)
  3a:	4785                	li	a5,1
  3c:	0ef71463          	bne	a4,a5,124 <find+0x124>
  40:	25413023          	sd	s4,576(sp)
  44:	23513c23          	sd	s5,568(sp)
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
        // int read(int fd, void *buf, int n);
        // fd: file descriptor of the dir; buf: buffer to store the file dir entry; n: number of bytes to read
        // read function returns: number of bytes read if successful, -1 if failed

        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
  48:	00001a17          	auipc	s4,0x1
  4c:	a40a0a13          	addi	s4,s4,-1472 # a88 <malloc+0x15e>
  50:	00001a97          	auipc	s5,0x1
  54:	a40a8a93          	addi	s5,s5,-1472 # a90 <malloc+0x166>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
  58:	4641                	li	a2,16
  5a:	db040593          	addi	a1,s0,-592
  5e:	8526                	mv	a0,s1
  60:	416000ef          	jal	476 <read>
  64:	47c1                	li	a5,16
  66:	12f51a63          	bne	a0,a5,19a <find+0x19a>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
  6a:	db045783          	lhu	a5,-592(s0)
  6e:	d7ed                	beqz	a5,58 <find+0x58>
  70:	85d2                	mv	a1,s4
  72:	db240513          	addi	a0,s0,-590
  76:	1ac000ef          	jal	222 <strcmp>
  7a:	dd79                	beqz	a0,58 <find+0x58>
  7c:	85d6                	mv	a1,s5
  7e:	db240513          	addi	a0,s0,-590
  82:	1a0000ef          	jal	222 <strcmp>
  86:	d969                	beqz	a0,58 <find+0x58>
  88:	23613823          	sd	s6,560(sp)
        // Construct the full path of the cur dir entry:
        // 1. Copy the base path -> buf
        // 2. Move pointer p to the end of the base path (buf)
        // 3. Append a '/' to the end of the base path (buf)
        // 4. Append the name of the cur dir entry (de.name) to the end of the base path (buf)
        strcpy(buf, path);
  8c:	85ce                	mv	a1,s3
  8e:	dc040513          	addi	a0,s0,-576
  92:	174000ef          	jal	206 <strcpy>
        p = buf + strlen(buf);
  96:	dc040513          	addi	a0,s0,-576
  9a:	1b4000ef          	jal	24e <strlen>
  9e:	02051793          	slli	a5,a0,0x20
  a2:	9381                	srli	a5,a5,0x20
  a4:	dc040713          	addi	a4,s0,-576
  a8:	97ba                	add	a5,a5,a4
        *p++ = '/';
  aa:	02f00713          	li	a4,47
  ae:	00e78023          	sb	a4,0(a5)
        strcpy(p, de.name);
  b2:	db240593          	addi	a1,s0,-590
  b6:	00178513          	addi	a0,a5,1
  ba:	14c000ef          	jal	206 <strcpy>
        // The result formate looks like: path/de.name

        // Get the metadata of the cur dir entry using fstat
        int fd_stat = open(buf, 0);
  be:	4581                	li	a1,0
  c0:	dc040513          	addi	a0,s0,-576
  c4:	3da000ef          	jal	49e <open>
  c8:	8b2a                	mv	s6,a0
        if (fd_stat < 0) {
  ca:	06054b63          	bltz	a0,140 <find+0x140>

            fprintf(2, "find: cannot open %s\n", buf);
            continue;
        }

        if (fstat(fd_stat, &st) < 0) {
  ce:	d9840593          	addi	a1,s0,-616
  d2:	3e4000ef          	jal	4b6 <fstat>
  d6:	08054163          	bltz	a0,158 <find+0x158>
            fprintf(2, "find: cannot stat %s\n", buf);
            continue;
        }

        // Check if the cur dir entry is a directory
        if (st.type == T_DIR) {
  da:	da041783          	lh	a5,-608(s0)
  de:	4705                	li	a4,1
  e0:	08e78863          	beq	a5,a4,170 <find+0x170>
            // T_DIR: directory type defined in fs.h
            
            find(buf, target); // Recursively search for files in the cur dir entry (subdir)
        }
        else if (st.type == T_FILE && strcmp(de.name, target) == 0) {
  e4:	4709                	li	a4,2
  e6:	08e78b63          	beq	a5,a4,17c <find+0x17c>
            // strcmp(de.name, target) == 0: the cur dir entry (inside a base dir) matches searched target

            printf("%s\n", buf); // Print the full path of the target file
        }

        close(fd_stat); // Close the cur dir entry
  ea:	855a                	mv	a0,s6
  ec:	39a000ef          	jal	486 <close>
  f0:	23013b03          	ld	s6,560(sp)
  f4:	b795                	j	58 <find+0x58>
        fprintf(2, "find: cannot open %s\n", path); // Error message if the directory cannot be opened
  f6:	864e                	mv	a2,s3
  f8:	00001597          	auipc	a1,0x1
  fc:	93858593          	addi	a1,a1,-1736 # a30 <malloc+0x106>
 100:	4509                	li	a0,2
 102:	74a000ef          	jal	84c <fprintf>
        return;
 106:	a05d                	j	1ac <find+0x1ac>
        fprintf(2, "find: cannot stat %s\n", path);
 108:	864e                	mv	a2,s3
 10a:	00001597          	auipc	a1,0x1
 10e:	94658593          	addi	a1,a1,-1722 # a50 <malloc+0x126>
 112:	4509                	li	a0,2
 114:	738000ef          	jal	84c <fprintf>
        close(fd); // Close the directory
 118:	8526                	mv	a0,s1
 11a:	36c000ef          	jal	486 <close>
        return;
 11e:	25813483          	ld	s1,600(sp)
 122:	a069                	j	1ac <find+0x1ac>
        fprintf(2, "find: %s is not a directory\n", path);
 124:	864e                	mv	a2,s3
 126:	00001597          	auipc	a1,0x1
 12a:	94258593          	addi	a1,a1,-1726 # a68 <malloc+0x13e>
 12e:	4509                	li	a0,2
 130:	71c000ef          	jal	84c <fprintf>
        close(fd); // Close the directory
 134:	8526                	mv	a0,s1
 136:	350000ef          	jal	486 <close>
        return;
 13a:	25813483          	ld	s1,600(sp)
 13e:	a0bd                	j	1ac <find+0x1ac>
            fprintf(2, "find: cannot open %s\n", buf);
 140:	dc040613          	addi	a2,s0,-576
 144:	00001597          	auipc	a1,0x1
 148:	8ec58593          	addi	a1,a1,-1812 # a30 <malloc+0x106>
 14c:	4509                	li	a0,2
 14e:	6fe000ef          	jal	84c <fprintf>
            continue;
 152:	23013b03          	ld	s6,560(sp)
 156:	b709                	j	58 <find+0x58>
            fprintf(2, "find: cannot stat %s\n", buf);
 158:	dc040613          	addi	a2,s0,-576
 15c:	00001597          	auipc	a1,0x1
 160:	8f458593          	addi	a1,a1,-1804 # a50 <malloc+0x126>
 164:	4509                	li	a0,2
 166:	6e6000ef          	jal	84c <fprintf>
            continue;
 16a:	23013b03          	ld	s6,560(sp)
 16e:	b5ed                	j	58 <find+0x58>
            find(buf, target); // Recursively search for files in the cur dir entry (subdir)
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	e8bff0ef          	jal	0 <find>
 17a:	bf85                	j	ea <find+0xea>
        else if (st.type == T_FILE && strcmp(de.name, target) == 0) {
 17c:	85ca                	mv	a1,s2
 17e:	db240513          	addi	a0,s0,-590
 182:	0a0000ef          	jal	222 <strcmp>
 186:	f135                	bnez	a0,ea <find+0xea>
            printf("%s\n", buf); // Print the full path of the target file
 188:	dc040593          	addi	a1,s0,-576
 18c:	00001517          	auipc	a0,0x1
 190:	90c50513          	addi	a0,a0,-1780 # a98 <malloc+0x16e>
 194:	6e2000ef          	jal	876 <printf>
 198:	bf89                	j	ea <find+0xea>
    }
    close(fd); // Close the directory
 19a:	8526                	mv	a0,s1
 19c:	2ea000ef          	jal	486 <close>
 1a0:	25813483          	ld	s1,600(sp)
 1a4:	24013a03          	ld	s4,576(sp)
 1a8:	23813a83          	ld	s5,568(sp)
}
 1ac:	26813083          	ld	ra,616(sp)
 1b0:	26013403          	ld	s0,608(sp)
 1b4:	25013903          	ld	s2,592(sp)
 1b8:	24813983          	ld	s3,584(sp)
 1bc:	27010113          	addi	sp,sp,624
 1c0:	8082                	ret

00000000000001c2 <main>:

// Main function
int main(int argc, char *argv[]) {
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e406                	sd	ra,8(sp)
 1c6:	e022                	sd	s0,0(sp)
 1c8:	0800                	addi	s0,sp,16
    // Entry point: argc: number of arguments; argv: array of arguments
    // Expected format: find <path> <file> -> argc = 3
    if (argc != 3) {
 1ca:	470d                	li	a4,3
 1cc:	00e50c63          	beq	a0,a4,1e4 <main+0x22>
        fprintf(2, "Usage: find <path> <file>\n");
 1d0:	00001597          	auipc	a1,0x1
 1d4:	8d058593          	addi	a1,a1,-1840 # aa0 <malloc+0x176>
 1d8:	4509                	li	a0,2
 1da:	672000ef          	jal	84c <fprintf>
        // 2 means stderr (standard error output)
        // stderr: used to output error messages (e.g., file not found, permission denied)
        exit(1);
 1de:	4505                	li	a0,1
 1e0:	27e000ef          	jal	45e <exit>
 1e4:	87ae                	mv	a5,a1
    }

    // Call the find function to search for target in the base dir and its subdirs
    find(argv[1], argv[2]); // argv[1]: char* path; argv[2]: char* target
 1e6:	698c                	ld	a1,16(a1)
 1e8:	6788                	ld	a0,8(a5)
 1ea:	e17ff0ef          	jal	0 <find>

    exit(0);
 1ee:	4501                	li	a0,0
 1f0:	26e000ef          	jal	45e <exit>

00000000000001f4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e406                	sd	ra,8(sp)
 1f8:	e022                	sd	s0,0(sp)
 1fa:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1fc:	fc7ff0ef          	jal	1c2 <main>
  exit(0);
 200:	4501                	li	a0,0
 202:	25c000ef          	jal	45e <exit>

0000000000000206 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20c:	87aa                	mv	a5,a0
 20e:	0585                	addi	a1,a1,1
 210:	0785                	addi	a5,a5,1
 212:	fff5c703          	lbu	a4,-1(a1)
 216:	fee78fa3          	sb	a4,-1(a5)
 21a:	fb75                	bnez	a4,20e <strcpy+0x8>
    ;
  return os;
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret

0000000000000222 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 228:	00054783          	lbu	a5,0(a0)
 22c:	cb91                	beqz	a5,240 <strcmp+0x1e>
 22e:	0005c703          	lbu	a4,0(a1)
 232:	00f71763          	bne	a4,a5,240 <strcmp+0x1e>
    p++, q++;
 236:	0505                	addi	a0,a0,1
 238:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	fbe5                	bnez	a5,22e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 240:	0005c503          	lbu	a0,0(a1)
}
 244:	40a7853b          	subw	a0,a5,a0
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strlen>:

uint
strlen(const char *s)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 254:	00054783          	lbu	a5,0(a0)
 258:	cf91                	beqz	a5,274 <strlen+0x26>
 25a:	0505                	addi	a0,a0,1
 25c:	87aa                	mv	a5,a0
 25e:	86be                	mv	a3,a5
 260:	0785                	addi	a5,a5,1
 262:	fff7c703          	lbu	a4,-1(a5)
 266:	ff65                	bnez	a4,25e <strlen+0x10>
 268:	40a6853b          	subw	a0,a3,a0
 26c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  for(n = 0; s[n]; n++)
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <strlen+0x20>

0000000000000278 <memset>:

void*
memset(void *dst, int c, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27e:	ca19                	beqz	a2,294 <memset+0x1c>
 280:	87aa                	mv	a5,a0
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 28a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28e:	0785                	addi	a5,a5,1
 290:	fee79de3          	bne	a5,a4,28a <memset+0x12>
  }
  return dst;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <strchr>:

char*
strchr(const char *s, char c)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	cb99                	beqz	a5,2ba <strchr+0x20>
    if(*s == c)
 2a6:	00f58763          	beq	a1,a5,2b4 <strchr+0x1a>
  for(; *s; s++)
 2aa:	0505                	addi	a0,a0,1
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	fbfd                	bnez	a5,2a6 <strchr+0xc>
      return (char*)s;
  return 0;
 2b2:	4501                	li	a0,0
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	bfe5                	j	2b4 <strchr+0x1a>

00000000000002be <gets>:

char*
gets(char *buf, int max)
{
 2be:	711d                	addi	sp,sp,-96
 2c0:	ec86                	sd	ra,88(sp)
 2c2:	e8a2                	sd	s0,80(sp)
 2c4:	e4a6                	sd	s1,72(sp)
 2c6:	e0ca                	sd	s2,64(sp)
 2c8:	fc4e                	sd	s3,56(sp)
 2ca:	f852                	sd	s4,48(sp)
 2cc:	f456                	sd	s5,40(sp)
 2ce:	f05a                	sd	s6,32(sp)
 2d0:	ec5e                	sd	s7,24(sp)
 2d2:	1080                	addi	s0,sp,96
 2d4:	8baa                	mv	s7,a0
 2d6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d8:	892a                	mv	s2,a0
 2da:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2dc:	4aa9                	li	s5,10
 2de:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2e0:	89a6                	mv	s3,s1
 2e2:	2485                	addiw	s1,s1,1
 2e4:	0344d663          	bge	s1,s4,310 <gets+0x52>
    cc = read(0, &c, 1);
 2e8:	4605                	li	a2,1
 2ea:	faf40593          	addi	a1,s0,-81
 2ee:	4501                	li	a0,0
 2f0:	186000ef          	jal	476 <read>
    if(cc < 1)
 2f4:	00a05e63          	blez	a0,310 <gets+0x52>
    buf[i++] = c;
 2f8:	faf44783          	lbu	a5,-81(s0)
 2fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 300:	01578763          	beq	a5,s5,30e <gets+0x50>
 304:	0905                	addi	s2,s2,1
 306:	fd679de3          	bne	a5,s6,2e0 <gets+0x22>
    buf[i++] = c;
 30a:	89a6                	mv	s3,s1
 30c:	a011                	j	310 <gets+0x52>
 30e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 310:	99de                	add	s3,s3,s7
 312:	00098023          	sb	zero,0(s3)
  return buf;
}
 316:	855e                	mv	a0,s7
 318:	60e6                	ld	ra,88(sp)
 31a:	6446                	ld	s0,80(sp)
 31c:	64a6                	ld	s1,72(sp)
 31e:	6906                	ld	s2,64(sp)
 320:	79e2                	ld	s3,56(sp)
 322:	7a42                	ld	s4,48(sp)
 324:	7aa2                	ld	s5,40(sp)
 326:	7b02                	ld	s6,32(sp)
 328:	6be2                	ld	s7,24(sp)
 32a:	6125                	addi	sp,sp,96
 32c:	8082                	ret

000000000000032e <stat>:

int
stat(const char *n, struct stat *st)
{
 32e:	1101                	addi	sp,sp,-32
 330:	ec06                	sd	ra,24(sp)
 332:	e822                	sd	s0,16(sp)
 334:	e04a                	sd	s2,0(sp)
 336:	1000                	addi	s0,sp,32
 338:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33a:	4581                	li	a1,0
 33c:	162000ef          	jal	49e <open>
  if(fd < 0)
 340:	02054263          	bltz	a0,364 <stat+0x36>
 344:	e426                	sd	s1,8(sp)
 346:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 348:	85ca                	mv	a1,s2
 34a:	16c000ef          	jal	4b6 <fstat>
 34e:	892a                	mv	s2,a0
  close(fd);
 350:	8526                	mv	a0,s1
 352:	134000ef          	jal	486 <close>
  return r;
 356:	64a2                	ld	s1,8(sp)
}
 358:	854a                	mv	a0,s2
 35a:	60e2                	ld	ra,24(sp)
 35c:	6442                	ld	s0,16(sp)
 35e:	6902                	ld	s2,0(sp)
 360:	6105                	addi	sp,sp,32
 362:	8082                	ret
    return -1;
 364:	597d                	li	s2,-1
 366:	bfcd                	j	358 <stat+0x2a>

0000000000000368 <atoi>:

int
atoi(const char *s)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36e:	00054683          	lbu	a3,0(a0)
 372:	fd06879b          	addiw	a5,a3,-48
 376:	0ff7f793          	zext.b	a5,a5
 37a:	4625                	li	a2,9
 37c:	02f66863          	bltu	a2,a5,3ac <atoi+0x44>
 380:	872a                	mv	a4,a0
  n = 0;
 382:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 384:	0705                	addi	a4,a4,1
 386:	0025179b          	slliw	a5,a0,0x2
 38a:	9fa9                	addw	a5,a5,a0
 38c:	0017979b          	slliw	a5,a5,0x1
 390:	9fb5                	addw	a5,a5,a3
 392:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 396:	00074683          	lbu	a3,0(a4)
 39a:	fd06879b          	addiw	a5,a3,-48
 39e:	0ff7f793          	zext.b	a5,a5
 3a2:	fef671e3          	bgeu	a2,a5,384 <atoi+0x1c>
  return n;
}
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  n = 0;
 3ac:	4501                	li	a0,0
 3ae:	bfe5                	j	3a6 <atoi+0x3e>

00000000000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3b6:	02b57463          	bgeu	a0,a1,3de <memmove+0x2e>
    while(n-- > 0)
 3ba:	00c05f63          	blez	a2,3d8 <memmove+0x28>
 3be:	1602                	slli	a2,a2,0x20
 3c0:	9201                	srli	a2,a2,0x20
 3c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c8:	0585                	addi	a1,a1,1
 3ca:	0705                	addi	a4,a4,1
 3cc:	fff5c683          	lbu	a3,-1(a1)
 3d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d4:	fef71ae3          	bne	a4,a5,3c8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
    dst += n;
 3de:	00c50733          	add	a4,a0,a2
    src += n;
 3e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e4:	fec05ae3          	blez	a2,3d8 <memmove+0x28>
 3e8:	fff6079b          	addiw	a5,a2,-1
 3ec:	1782                	slli	a5,a5,0x20
 3ee:	9381                	srli	a5,a5,0x20
 3f0:	fff7c793          	not	a5,a5
 3f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f6:	15fd                	addi	a1,a1,-1
 3f8:	177d                	addi	a4,a4,-1
 3fa:	0005c683          	lbu	a3,0(a1)
 3fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 402:	fee79ae3          	bne	a5,a4,3f6 <memmove+0x46>
 406:	bfc9                	j	3d8 <memmove+0x28>

0000000000000408 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40e:	ca05                	beqz	a2,43e <memcmp+0x36>
 410:	fff6069b          	addiw	a3,a2,-1
 414:	1682                	slli	a3,a3,0x20
 416:	9281                	srli	a3,a3,0x20
 418:	0685                	addi	a3,a3,1
 41a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 41c:	00054783          	lbu	a5,0(a0)
 420:	0005c703          	lbu	a4,0(a1)
 424:	00e79863          	bne	a5,a4,434 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 428:	0505                	addi	a0,a0,1
    p2++;
 42a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 42c:	fed518e3          	bne	a0,a3,41c <memcmp+0x14>
  }
  return 0;
 430:	4501                	li	a0,0
 432:	a019                	j	438 <memcmp+0x30>
      return *p1 - *p2;
 434:	40e7853b          	subw	a0,a5,a4
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
  return 0;
 43e:	4501                	li	a0,0
 440:	bfe5                	j	438 <memcmp+0x30>

0000000000000442 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 44a:	f67ff0ef          	jal	3b0 <memmove>
}
 44e:	60a2                	ld	ra,8(sp)
 450:	6402                	ld	s0,0(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret

0000000000000456 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 456:	4885                	li	a7,1
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <exit>:
.global exit
exit:
 li a7, SYS_exit
 45e:	4889                	li	a7,2
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <wait>:
.global wait
wait:
 li a7, SYS_wait
 466:	488d                	li	a7,3
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46e:	4891                	li	a7,4
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <read>:
.global read
read:
 li a7, SYS_read
 476:	4895                	li	a7,5
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <write>:
.global write
write:
 li a7, SYS_write
 47e:	48c1                	li	a7,16
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <close>:
.global close
close:
 li a7, SYS_close
 486:	48d5                	li	a7,21
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <kill>:
.global kill
kill:
 li a7, SYS_kill
 48e:	4899                	li	a7,6
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <exec>:
.global exec
exec:
 li a7, SYS_exec
 496:	489d                	li	a7,7
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <open>:
.global open
open:
 li a7, SYS_open
 49e:	48bd                	li	a7,15
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a6:	48c5                	li	a7,17
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4ae:	48c9                	li	a7,18
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b6:	48a1                	li	a7,8
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <link>:
.global link
link:
 li a7, SYS_link
 4be:	48cd                	li	a7,19
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c6:	48d1                	li	a7,20
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ce:	48a5                	li	a7,9
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d6:	48a9                	li	a7,10
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4de:	48ad                	li	a7,11
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e6:	48b1                	li	a7,12
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ee:	48b5                	li	a7,13
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f6:	48b9                	li	a7,14
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fe:	1101                	addi	sp,sp,-32
 500:	ec06                	sd	ra,24(sp)
 502:	e822                	sd	s0,16(sp)
 504:	1000                	addi	s0,sp,32
 506:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 50a:	4605                	li	a2,1
 50c:	fef40593          	addi	a1,s0,-17
 510:	f6fff0ef          	jal	47e <write>
}
 514:	60e2                	ld	ra,24(sp)
 516:	6442                	ld	s0,16(sp)
 518:	6105                	addi	sp,sp,32
 51a:	8082                	ret

000000000000051c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51c:	7139                	addi	sp,sp,-64
 51e:	fc06                	sd	ra,56(sp)
 520:	f822                	sd	s0,48(sp)
 522:	f426                	sd	s1,40(sp)
 524:	0080                	addi	s0,sp,64
 526:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 528:	c299                	beqz	a3,52e <printint+0x12>
 52a:	0805c963          	bltz	a1,5bc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52e:	2581                	sext.w	a1,a1
  neg = 0;
 530:	4881                	li	a7,0
 532:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 536:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 538:	2601                	sext.w	a2,a2
 53a:	00000517          	auipc	a0,0x0
 53e:	58e50513          	addi	a0,a0,1422 # ac8 <digits>
 542:	883a                	mv	a6,a4
 544:	2705                	addiw	a4,a4,1
 546:	02c5f7bb          	remuw	a5,a1,a2
 54a:	1782                	slli	a5,a5,0x20
 54c:	9381                	srli	a5,a5,0x20
 54e:	97aa                	add	a5,a5,a0
 550:	0007c783          	lbu	a5,0(a5)
 554:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 558:	0005879b          	sext.w	a5,a1
 55c:	02c5d5bb          	divuw	a1,a1,a2
 560:	0685                	addi	a3,a3,1
 562:	fec7f0e3          	bgeu	a5,a2,542 <printint+0x26>
  if(neg)
 566:	00088c63          	beqz	a7,57e <printint+0x62>
    buf[i++] = '-';
 56a:	fd070793          	addi	a5,a4,-48
 56e:	00878733          	add	a4,a5,s0
 572:	02d00793          	li	a5,45
 576:	fef70823          	sb	a5,-16(a4)
 57a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 57e:	02e05a63          	blez	a4,5b2 <printint+0x96>
 582:	f04a                	sd	s2,32(sp)
 584:	ec4e                	sd	s3,24(sp)
 586:	fc040793          	addi	a5,s0,-64
 58a:	00e78933          	add	s2,a5,a4
 58e:	fff78993          	addi	s3,a5,-1
 592:	99ba                	add	s3,s3,a4
 594:	377d                	addiw	a4,a4,-1
 596:	1702                	slli	a4,a4,0x20
 598:	9301                	srli	a4,a4,0x20
 59a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 59e:	fff94583          	lbu	a1,-1(s2)
 5a2:	8526                	mv	a0,s1
 5a4:	f5bff0ef          	jal	4fe <putc>
  while(--i >= 0)
 5a8:	197d                	addi	s2,s2,-1
 5aa:	ff391ae3          	bne	s2,s3,59e <printint+0x82>
 5ae:	7902                	ld	s2,32(sp)
 5b0:	69e2                	ld	s3,24(sp)
}
 5b2:	70e2                	ld	ra,56(sp)
 5b4:	7442                	ld	s0,48(sp)
 5b6:	74a2                	ld	s1,40(sp)
 5b8:	6121                	addi	sp,sp,64
 5ba:	8082                	ret
    x = -xx;
 5bc:	40b005bb          	negw	a1,a1
    neg = 1;
 5c0:	4885                	li	a7,1
    x = -xx;
 5c2:	bf85                	j	532 <printint+0x16>

00000000000005c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5c4:	711d                	addi	sp,sp,-96
 5c6:	ec86                	sd	ra,88(sp)
 5c8:	e8a2                	sd	s0,80(sp)
 5ca:	e0ca                	sd	s2,64(sp)
 5cc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ce:	0005c903          	lbu	s2,0(a1)
 5d2:	26090863          	beqz	s2,842 <vprintf+0x27e>
 5d6:	e4a6                	sd	s1,72(sp)
 5d8:	fc4e                	sd	s3,56(sp)
 5da:	f852                	sd	s4,48(sp)
 5dc:	f456                	sd	s5,40(sp)
 5de:	f05a                	sd	s6,32(sp)
 5e0:	ec5e                	sd	s7,24(sp)
 5e2:	e862                	sd	s8,16(sp)
 5e4:	e466                	sd	s9,8(sp)
 5e6:	8b2a                	mv	s6,a0
 5e8:	8a2e                	mv	s4,a1
 5ea:	8bb2                	mv	s7,a2
  state = 0;
 5ec:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5ee:	4481                	li	s1,0
 5f0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5f6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5fa:	06c00c93          	li	s9,108
 5fe:	a005                	j	61e <vprintf+0x5a>
        putc(fd, c0);
 600:	85ca                	mv	a1,s2
 602:	855a                	mv	a0,s6
 604:	efbff0ef          	jal	4fe <putc>
 608:	a019                	j	60e <vprintf+0x4a>
    } else if(state == '%'){
 60a:	03598263          	beq	s3,s5,62e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 60e:	2485                	addiw	s1,s1,1
 610:	8726                	mv	a4,s1
 612:	009a07b3          	add	a5,s4,s1
 616:	0007c903          	lbu	s2,0(a5)
 61a:	20090c63          	beqz	s2,832 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 61e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 622:	fe0994e3          	bnez	s3,60a <vprintf+0x46>
      if(c0 == '%'){
 626:	fd579de3          	bne	a5,s5,600 <vprintf+0x3c>
        state = '%';
 62a:	89be                	mv	s3,a5
 62c:	b7cd                	j	60e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 62e:	00ea06b3          	add	a3,s4,a4
 632:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 636:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 638:	c681                	beqz	a3,640 <vprintf+0x7c>
 63a:	9752                	add	a4,a4,s4
 63c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 640:	03878f63          	beq	a5,s8,67e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 644:	05978963          	beq	a5,s9,696 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 648:	07500713          	li	a4,117
 64c:	0ee78363          	beq	a5,a4,732 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 650:	07800713          	li	a4,120
 654:	12e78563          	beq	a5,a4,77e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 658:	07000713          	li	a4,112
 65c:	14e78a63          	beq	a5,a4,7b0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 660:	07300713          	li	a4,115
 664:	18e78a63          	beq	a5,a4,7f8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 668:	02500713          	li	a4,37
 66c:	04e79563          	bne	a5,a4,6b6 <vprintf+0xf2>
        putc(fd, '%');
 670:	02500593          	li	a1,37
 674:	855a                	mv	a0,s6
 676:	e89ff0ef          	jal	4fe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bf49                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 67e:	008b8913          	addi	s2,s7,8
 682:	4685                	li	a3,1
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e91ff0ef          	jal	51c <printint>
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bfad                	j	60e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 696:	06400793          	li	a5,100
 69a:	02f68963          	beq	a3,a5,6cc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69e:	06c00793          	li	a5,108
 6a2:	04f68263          	beq	a3,a5,6e6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6a6:	07500793          	li	a5,117
 6aa:	0af68063          	beq	a3,a5,74a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6ae:	07800793          	li	a5,120
 6b2:	0ef68263          	beq	a3,a5,796 <vprintf+0x1d2>
        putc(fd, '%');
 6b6:	02500593          	li	a1,37
 6ba:	855a                	mv	a0,s6
 6bc:	e43ff0ef          	jal	4fe <putc>
        putc(fd, c0);
 6c0:	85ca                	mv	a1,s2
 6c2:	855a                	mv	a0,s6
 6c4:	e3bff0ef          	jal	4fe <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b791                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4685                	li	a3,1
 6d2:	4629                	li	a2,10
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	e43ff0ef          	jal	51c <printint>
        i += 1;
 6de:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
        i += 1;
 6e4:	b72d                	j	60e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	06400793          	li	a5,100
 6ea:	02f60763          	beq	a2,a5,718 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ee:	07500793          	li	a5,117
 6f2:	06f60963          	beq	a2,a5,764 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f6:	07800793          	li	a5,120
 6fa:	faf61ee3          	bne	a2,a5,6b6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	008b8913          	addi	s2,s7,8
 702:	4681                	li	a3,0
 704:	4641                	li	a2,16
 706:	000ba583          	lw	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	e11ff0ef          	jal	51c <printint>
        i += 2;
 710:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
        i += 2;
 716:	bde5                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	008b8913          	addi	s2,s7,8
 71c:	4685                	li	a3,1
 71e:	4629                	li	a2,10
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	df7ff0ef          	jal	51c <printint>
        i += 2;
 72a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
        i += 2;
 730:	bdf9                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 732:	008b8913          	addi	s2,s7,8
 736:	4681                	li	a3,0
 738:	4629                	li	a2,10
 73a:	000ba583          	lw	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	dddff0ef          	jal	51c <printint>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	b5d9                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	008b8913          	addi	s2,s7,8
 74e:	4681                	li	a3,0
 750:	4629                	li	a2,10
 752:	000ba583          	lw	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	dc5ff0ef          	jal	51c <printint>
        i += 1;
 75c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	8bca                	mv	s7,s2
      state = 0;
 760:	4981                	li	s3,0
        i += 1;
 762:	b575                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	008b8913          	addi	s2,s7,8
 768:	4681                	li	a3,0
 76a:	4629                	li	a2,10
 76c:	000ba583          	lw	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	dabff0ef          	jal	51c <printint>
        i += 2;
 776:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	8bca                	mv	s7,s2
      state = 0;
 77a:	4981                	li	s3,0
        i += 2;
 77c:	bd49                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 77e:	008b8913          	addi	s2,s7,8
 782:	4681                	li	a3,0
 784:	4641                	li	a2,16
 786:	000ba583          	lw	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	d91ff0ef          	jal	51c <printint>
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
 794:	bdad                	j	60e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	008b8913          	addi	s2,s7,8
 79a:	4681                	li	a3,0
 79c:	4641                	li	a2,16
 79e:	000ba583          	lw	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	d79ff0ef          	jal	51c <printint>
        i += 1;
 7a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
        i += 1;
 7ae:	b585                	j	60e <vprintf+0x4a>
 7b0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b2:	008b8d13          	addi	s10,s7,8
 7b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ba:	03000593          	li	a1,48
 7be:	855a                	mv	a0,s6
 7c0:	d3fff0ef          	jal	4fe <putc>
  putc(fd, 'x');
 7c4:	07800593          	li	a1,120
 7c8:	855a                	mv	a0,s6
 7ca:	d35ff0ef          	jal	4fe <putc>
 7ce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d0:	00000b97          	auipc	s7,0x0
 7d4:	2f8b8b93          	addi	s7,s7,760 # ac8 <digits>
 7d8:	03c9d793          	srli	a5,s3,0x3c
 7dc:	97de                	add	a5,a5,s7
 7de:	0007c583          	lbu	a1,0(a5)
 7e2:	855a                	mv	a0,s6
 7e4:	d1bff0ef          	jal	4fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e8:	0992                	slli	s3,s3,0x4
 7ea:	397d                	addiw	s2,s2,-1
 7ec:	fe0916e3          	bnez	s2,7d8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7f0:	8bea                	mv	s7,s10
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	6d02                	ld	s10,0(sp)
 7f6:	bd21                	j	60e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7f8:	008b8993          	addi	s3,s7,8
 7fc:	000bb903          	ld	s2,0(s7)
 800:	00090f63          	beqz	s2,81e <vprintf+0x25a>
        for(; *s; s++)
 804:	00094583          	lbu	a1,0(s2)
 808:	c195                	beqz	a1,82c <vprintf+0x268>
          putc(fd, *s);
 80a:	855a                	mv	a0,s6
 80c:	cf3ff0ef          	jal	4fe <putc>
        for(; *s; s++)
 810:	0905                	addi	s2,s2,1
 812:	00094583          	lbu	a1,0(s2)
 816:	f9f5                	bnez	a1,80a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbcd                	j	60e <vprintf+0x4a>
          s = "(null)";
 81e:	00000917          	auipc	s2,0x0
 822:	2a290913          	addi	s2,s2,674 # ac0 <malloc+0x196>
        for(; *s; s++)
 826:	02800593          	li	a1,40
 82a:	b7c5                	j	80a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 82c:	8bce                	mv	s7,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	bbf9                	j	60e <vprintf+0x4a>
 832:	64a6                	ld	s1,72(sp)
 834:	79e2                	ld	s3,56(sp)
 836:	7a42                	ld	s4,48(sp)
 838:	7aa2                	ld	s5,40(sp)
 83a:	7b02                	ld	s6,32(sp)
 83c:	6be2                	ld	s7,24(sp)
 83e:	6c42                	ld	s8,16(sp)
 840:	6ca2                	ld	s9,8(sp)
    }
  }
}
 842:	60e6                	ld	ra,88(sp)
 844:	6446                	ld	s0,80(sp)
 846:	6906                	ld	s2,64(sp)
 848:	6125                	addi	sp,sp,96
 84a:	8082                	ret

000000000000084c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84c:	715d                	addi	sp,sp,-80
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	addi	s0,sp,32
 854:	e010                	sd	a2,0(s0)
 856:	e414                	sd	a3,8(s0)
 858:	e818                	sd	a4,16(s0)
 85a:	ec1c                	sd	a5,24(s0)
 85c:	03043023          	sd	a6,32(s0)
 860:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 868:	8622                	mv	a2,s0
 86a:	d5bff0ef          	jal	5c4 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6161                	addi	sp,sp,80
 874:	8082                	ret

0000000000000876 <printf>:

void
printf(const char *fmt, ...)
{
 876:	711d                	addi	sp,sp,-96
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e40c                	sd	a1,8(s0)
 880:	e810                	sd	a2,16(s0)
 882:	ec14                	sd	a3,24(s0)
 884:	f018                	sd	a4,32(s0)
 886:	f41c                	sd	a5,40(s0)
 888:	03043823          	sd	a6,48(s0)
 88c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	00840613          	addi	a2,s0,8
 894:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 898:	85aa                	mv	a1,a0
 89a:	4505                	li	a0,1
 89c:	d29ff0ef          	jal	5c4 <vprintf>
}
 8a0:	60e2                	ld	ra,24(sp)
 8a2:	6442                	ld	s0,16(sp)
 8a4:	6125                	addi	sp,sp,96
 8a6:	8082                	ret

00000000000008a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a8:	1141                	addi	sp,sp,-16
 8aa:	e422                	sd	s0,8(sp)
 8ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	00000797          	auipc	a5,0x0
 8b6:	74e7b783          	ld	a5,1870(a5) # 1000 <freep>
 8ba:	a02d                	j	8e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8bc:	4618                	lw	a4,8(a2)
 8be:	9f2d                	addw	a4,a4,a1
 8c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	6310                	ld	a2,0(a4)
 8c8:	a83d                	j	906 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ca:	ff852703          	lw	a4,-8(a0)
 8ce:	9f31                	addw	a4,a4,a2
 8d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d2:	ff053683          	ld	a3,-16(a0)
 8d6:	a091                	j	91a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	6398                	ld	a4,0(a5)
 8da:	00e7e463          	bltu	a5,a4,8e2 <free+0x3a>
 8de:	00e6ea63          	bltu	a3,a4,8f2 <free+0x4a>
{
 8e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e4:	fed7fae3          	bgeu	a5,a3,8d8 <free+0x30>
 8e8:	6398                	ld	a4,0(a5)
 8ea:	00e6e463          	bltu	a3,a4,8f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ee:	fee7eae3          	bltu	a5,a4,8e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f2:	ff852583          	lw	a1,-8(a0)
 8f6:	6390                	ld	a2,0(a5)
 8f8:	02059813          	slli	a6,a1,0x20
 8fc:	01c85713          	srli	a4,a6,0x1c
 900:	9736                	add	a4,a4,a3
 902:	fae60de3          	beq	a2,a4,8bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 906:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90a:	4790                	lw	a2,8(a5)
 90c:	02061593          	slli	a1,a2,0x20
 910:	01c5d713          	srli	a4,a1,0x1c
 914:	973e                	add	a4,a4,a5
 916:	fae68ae3          	beq	a3,a4,8ca <free+0x22>
    p->s.ptr = bp->s.ptr;
 91a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 91c:	00000717          	auipc	a4,0x0
 920:	6ef73223          	sd	a5,1764(a4) # 1000 <freep>
}
 924:	6422                	ld	s0,8(sp)
 926:	0141                	addi	sp,sp,16
 928:	8082                	ret

000000000000092a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 92a:	7139                	addi	sp,sp,-64
 92c:	fc06                	sd	ra,56(sp)
 92e:	f822                	sd	s0,48(sp)
 930:	f426                	sd	s1,40(sp)
 932:	ec4e                	sd	s3,24(sp)
 934:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 936:	02051493          	slli	s1,a0,0x20
 93a:	9081                	srli	s1,s1,0x20
 93c:	04bd                	addi	s1,s1,15
 93e:	8091                	srli	s1,s1,0x4
 940:	0014899b          	addiw	s3,s1,1
 944:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 946:	00000517          	auipc	a0,0x0
 94a:	6ba53503          	ld	a0,1722(a0) # 1000 <freep>
 94e:	c915                	beqz	a0,982 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	08977a63          	bgeu	a4,s1,9e8 <malloc+0xbe>
 958:	f04a                	sd	s2,32(sp)
 95a:	e852                	sd	s4,16(sp)
 95c:	e456                	sd	s5,8(sp)
 95e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 960:	8a4e                	mv	s4,s3
 962:	0009871b          	sext.w	a4,s3
 966:	6685                	lui	a3,0x1
 968:	00d77363          	bgeu	a4,a3,96e <malloc+0x44>
 96c:	6a05                	lui	s4,0x1
 96e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 972:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 976:	00000917          	auipc	s2,0x0
 97a:	68a90913          	addi	s2,s2,1674 # 1000 <freep>
  if(p == (char*)-1)
 97e:	5afd                	li	s5,-1
 980:	a081                	j	9c0 <malloc+0x96>
 982:	f04a                	sd	s2,32(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 98a:	00000797          	auipc	a5,0x0
 98e:	68678793          	addi	a5,a5,1670 # 1010 <base>
 992:	00000717          	auipc	a4,0x0
 996:	66f73723          	sd	a5,1646(a4) # 1000 <freep>
 99a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a0:	b7c1                	j	960 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9a2:	6398                	ld	a4,0(a5)
 9a4:	e118                	sd	a4,0(a0)
 9a6:	a8a9                	j	a00 <malloc+0xd6>
  hp->s.size = nu;
 9a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ac:	0541                	addi	a0,a0,16
 9ae:	efbff0ef          	jal	8a8 <free>
  return freep;
 9b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b6:	c12d                	beqz	a0,a18 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	02977263          	bgeu	a4,s1,9e0 <malloc+0xb6>
    if(p == freep)
 9c0:	00093703          	ld	a4,0(s2)
 9c4:	853e                	mv	a0,a5
 9c6:	fef719e3          	bne	a4,a5,9b8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9ca:	8552                	mv	a0,s4
 9cc:	b1bff0ef          	jal	4e6 <sbrk>
  if(p == (char*)-1)
 9d0:	fd551ce3          	bne	a0,s5,9a8 <malloc+0x7e>
        return 0;
 9d4:	4501                	li	a0,0
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	a03d                	j	a0c <malloc+0xe2>
 9e0:	7902                	ld	s2,32(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9e8:	fae48de3          	beq	s1,a4,9a2 <malloc+0x78>
        p->s.size -= nunits;
 9ec:	4137073b          	subw	a4,a4,s3
 9f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f2:	02071693          	slli	a3,a4,0x20
 9f6:	01c6d713          	srli	a4,a3,0x1c
 9fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a00:	00000717          	auipc	a4,0x0
 a04:	60a73023          	sd	a0,1536(a4) # 1000 <freep>
      return (void*)(p + 1);
 a08:	01078513          	addi	a0,a5,16
  }
}
 a0c:	70e2                	ld	ra,56(sp)
 a0e:	7442                	ld	s0,48(sp)
 a10:	74a2                	ld	s1,40(sp)
 a12:	69e2                	ld	s3,24(sp)
 a14:	6121                	addi	sp,sp,64
 a16:	8082                	ret
 a18:	7902                	ld	s2,32(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	b7f5                	j	a0c <malloc+0xe2>
