
_lab2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
	
	int PScheduler(void);

  printf(1, "\n This program tests the correctness of your lab#2\n");
   9:	c7 44 24 04 d8 09 00 	movl   $0x9d8,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 a3 04 00 00       	call   4c0 <printf>
  
	PScheduler();
  1d:	e8 0e 00 00 00       	call   30 <PScheduler>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <PScheduler>:
	return 0;
 }
  
    
     int PScheduler(void){
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
    printf(1, "\n  Step 2: testing the priority scheduler and setpriority(int priority)) systema call:\n");
    printf(1, "\n  Step 2: Assuming that the priorities range between range between 0 to 31\n");
    printf(1, "\n  Step 2: 0 is the highest priority. All processes have a default priority of 10\n");
    printf(1, "\n  Step 2: The parent processes will switch to priority 0\n");
    setpriority(0);
    for (i = 0; i <  3; i++) {
  34:	31 db                	xor    %ebx,%ebx
     int PScheduler(void){
  36:	83 ec 24             	sub    $0x24,%esp
    printf(1, "\n  Step 2: testing the priority scheduler and setpriority(int priority)) systema call:\n");
  39:	c7 44 24 04 28 08 00 	movl   $0x828,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 73 04 00 00       	call   4c0 <printf>
    printf(1, "\n  Step 2: Assuming that the priorities range between range between 0 to 31\n");
  4d:	c7 44 24 04 80 08 00 	movl   $0x880,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 5f 04 00 00       	call   4c0 <printf>
    printf(1, "\n  Step 2: 0 is the highest priority. All processes have a default priority of 10\n");
  61:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 4b 04 00 00       	call   4c0 <printf>
    printf(1, "\n  Step 2: The parent processes will switch to priority 0\n");
  75:	c7 44 24 04 24 09 00 	movl   $0x924,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  84:	e8 37 04 00 00       	call   4c0 <printf>
    setpriority(0);
  89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  90:	e8 7d 03 00 00       	call   412 <setpriority>
	pid = fork();
  95:	e8 d0 02 00 00       	call   36a <fork>
	if (pid > 0 ) {
  9a:	83 f8 00             	cmp    $0x0,%eax
  9d:	7e 34                	jle    d3 <PScheduler+0xa3>
    for (i = 0; i <  3; i++) {
  9f:	83 c3 01             	add    $0x1,%ebx
  a2:	83 fb 03             	cmp    $0x3,%ebx
  a5:	75 ee                	jne    95 <PScheduler+0x65>
			printf(2," \n Error \n");
			
        }
	}

	if(pid > 0) {
  a7:	85 c0                	test   %eax,%eax
  a9:	7e 23                	jle    ce <PScheduler+0x9e>
		for (i = 0; i <  3; i++) {
			wait();
  ab:	e8 ca 02 00 00       	call   37a <wait>
  b0:	e8 c5 02 00 00       	call   37a <wait>
  b5:	e8 c0 02 00 00       	call   37a <wait>

		}
                     printf(1,"\n if processes with highest priority finished first then its correct \n");
  ba:	c7 44 24 04 90 09 00 	movl   $0x990,0x4(%esp)
  c1:	00 
  c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c9:	e8 f2 03 00 00       	call   4c0 <printf>
}
	exit();		
  ce:	e8 9f 02 00 00       	call   372 <exit>
	else if ( pid == 0) {
  d3:	74 1c                	je     f1 <PScheduler+0xc1>
			printf(2," \n Error \n");
  d5:	c7 44 24 04 0c 0a 00 	movl   $0xa0c,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e7:	e8 d4 03 00 00       	call   4c0 <printf>
  ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ef:	eb ae                	jmp    9f <PScheduler+0x6f>
		setpriority(30-10*i);	
  f1:	6b db f6             	imul   $0xfffffff6,%ebx,%ebx
  f4:	83 c3 1e             	add    $0x1e,%ebx
  f7:	89 1c 24             	mov    %ebx,(%esp)
  fa:	e8 13 03 00 00       	call   412 <setpriority>
  ff:	ba 50 c3 00 00       	mov    $0xc350,%edx
 104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i <  3; i++) {
 108:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 10d:	8d 76 00             	lea    0x0(%esi),%esi
				asm("nop"); }}
 110:	90                   	nop
			for(k=0;k<1000;k++) {
 111:	83 e8 01             	sub    $0x1,%eax
 114:	75 fa                	jne    110 <PScheduler+0xe0>
		for (j=0;j<50000;j++) {
 116:	83 ea 01             	sub    $0x1,%edx
 119:	75 ed                	jne    108 <PScheduler+0xd8>
		printf(1, "\n child# %d with priority %d has finished! \n",getpid(),30-10*i);		
 11b:	e8 d2 02 00 00       	call   3f2 <getpid>
 120:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 124:	c7 44 24 04 60 09 00 	movl   $0x960,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	89 44 24 08          	mov    %eax,0x8(%esp)
 137:	e8 84 03 00 00       	call   4c0 <printf>
		exit();
 13c:	e8 31 02 00 00       	call   372 <exit>
 141:	66 90                	xchg   %ax,%ax
 143:	66 90                	xchg   %ax,%ax
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 159:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	89 c2                	mov    %eax,%edx
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 160:	83 c1 01             	add    $0x1,%ecx
 163:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 167:	83 c2 01             	add    $0x1,%edx
 16a:	84 db                	test   %bl,%bl
 16c:	88 5a ff             	mov    %bl,-0x1(%edx)
 16f:	75 ef                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 171:	5b                   	pop    %ebx
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 17a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 55 08             	mov    0x8(%ebp),%edx
 186:	53                   	push   %ebx
 187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 18a:	0f b6 02             	movzbl (%edx),%eax
 18d:	84 c0                	test   %al,%al
 18f:	74 2d                	je     1be <strcmp+0x3e>
 191:	0f b6 19             	movzbl (%ecx),%ebx
 194:	38 d8                	cmp    %bl,%al
 196:	74 0e                	je     1a6 <strcmp+0x26>
 198:	eb 2b                	jmp    1c5 <strcmp+0x45>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a0:	38 c8                	cmp    %cl,%al
 1a2:	75 15                	jne    1b9 <strcmp+0x39>
    p++, q++;
 1a4:	89 d9                	mov    %ebx,%ecx
 1a6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1ac:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 1b3:	84 c0                	test   %al,%al
 1b5:	75 e9                	jne    1a0 <strcmp+0x20>
 1b7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1b9:	29 c8                	sub    %ecx,%eax
}
 1bb:	5b                   	pop    %ebx
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    
 1be:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 1c1:	31 c0                	xor    %eax,%eax
 1c3:	eb f4                	jmp    1b9 <strcmp+0x39>
 1c5:	0f b6 cb             	movzbl %bl,%ecx
 1c8:	eb ef                	jmp    1b9 <strcmp+0x39>
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1d6:	80 39 00             	cmpb   $0x0,(%ecx)
 1d9:	74 12                	je     1ed <strlen+0x1d>
 1db:	31 d2                	xor    %edx,%edx
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1e7:	89 d0                	mov    %edx,%eax
 1e9:	75 f5                	jne    1e0 <strlen+0x10>
    ;
  return n;
}
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1ed:	31 c0                	xor    %eax,%eax
}
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	eb 0d                	jmp    200 <memset>
 1f3:	90                   	nop
 1f4:	90                   	nop
 1f5:	90                   	nop
 1f6:	90                   	nop
 1f7:	90                   	nop
 1f8:	90                   	nop
 1f9:	90                   	nop
 1fa:	90                   	nop
 1fb:	90                   	nop
 1fc:	90                   	nop
 1fd:	90                   	nop
 1fe:	90                   	nop
 1ff:	90                   	nop

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 207:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 d7                	mov    %edx,%edi
 20f:	fc                   	cld    
 210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 212:	89 d0                	mov    %edx,%eax
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	53                   	push   %ebx
 227:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 22a:	0f b6 18             	movzbl (%eax),%ebx
 22d:	84 db                	test   %bl,%bl
 22f:	74 1d                	je     24e <strchr+0x2e>
    if(*s == c)
 231:	38 d3                	cmp    %dl,%bl
 233:	89 d1                	mov    %edx,%ecx
 235:	75 0d                	jne    244 <strchr+0x24>
 237:	eb 17                	jmp    250 <strchr+0x30>
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 240:	38 ca                	cmp    %cl,%dl
 242:	74 0c                	je     250 <strchr+0x30>
  for(; *s; s++)
 244:	83 c0 01             	add    $0x1,%eax
 247:	0f b6 10             	movzbl (%eax),%edx
 24a:	84 d2                	test   %dl,%dl
 24c:	75 f2                	jne    240 <strchr+0x20>
      return (char*)s;
  return 0;
 24e:	31 c0                	xor    %eax,%eax
}
 250:	5b                   	pop    %ebx
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <gets>:

char*
gets(char *buf, int max)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 265:	31 f6                	xor    %esi,%esi
{
 267:	53                   	push   %ebx
 268:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 26b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 26e:	eb 31                	jmp    2a1 <gets+0x41>
    cc = read(0, &c, 1);
 270:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 277:	00 
 278:	89 7c 24 04          	mov    %edi,0x4(%esp)
 27c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 283:	e8 02 01 00 00       	call   38a <read>
    if(cc < 1)
 288:	85 c0                	test   %eax,%eax
 28a:	7e 1d                	jle    2a9 <gets+0x49>
      break;
    buf[i++] = c;
 28c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 290:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 292:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 295:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 297:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 29b:	74 0c                	je     2a9 <gets+0x49>
 29d:	3c 0a                	cmp    $0xa,%al
 29f:	74 08                	je     2a9 <gets+0x49>
  for(i=0; i+1 < max; ){
 2a1:	8d 5e 01             	lea    0x1(%esi),%ebx
 2a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a7:	7c c7                	jl     270 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2b0:	83 c4 2c             	add    $0x2c,%esp
 2b3:	5b                   	pop    %ebx
 2b4:	5e                   	pop    %esi
 2b5:	5f                   	pop    %edi
 2b6:	5d                   	pop    %ebp
 2b7:	c3                   	ret    
 2b8:	90                   	nop
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
 2c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d2:	00 
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 d7 00 00 00       	call   3b2 <open>
  if(fd < 0)
 2db:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 2dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2df:	78 27                	js     308 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e4:	89 1c 24             	mov    %ebx,(%esp)
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	e8 da 00 00 00       	call   3ca <fstat>
  close(fd);
 2f0:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2f3:	89 c6                	mov    %eax,%esi
  close(fd);
 2f5:	e8 a0 00 00 00       	call   39a <close>
  return r;
 2fa:	89 f0                	mov    %esi,%eax
}
 2fc:	83 c4 10             	add    $0x10,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	90                   	nop
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30d:	eb ed                	jmp    2fc <stat+0x3c>
 30f:	90                   	nop

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
 316:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 11             	movsbl (%ecx),%edx
 31a:	8d 42 d0             	lea    -0x30(%edx),%eax
 31d:	3c 09                	cmp    $0x9,%al
  n = 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 324:	77 17                	ja     33d <atoi+0x2d>
 326:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 328:	83 c1 01             	add    $0x1,%ecx
 32b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 32e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 332:	0f be 11             	movsbl (%ecx),%edx
 335:	8d 5a d0             	lea    -0x30(%edx),%ebx
 338:	80 fb 09             	cmp    $0x9,%bl
 33b:	76 eb                	jbe    328 <atoi+0x18>
  return n;
}
 33d:	5b                   	pop    %ebx
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    

00000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 341:	31 d2                	xor    %edx,%edx
{
 343:	89 e5                	mov    %esp,%ebp
 345:	56                   	push   %esi
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	53                   	push   %ebx
 34a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 34d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 350:	85 db                	test   %ebx,%ebx
 352:	7e 12                	jle    366 <memmove+0x26>
 354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 358:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 35c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 35f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 362:	39 da                	cmp    %ebx,%edx
 364:	75 f2                	jne    358 <memmove+0x18>
  return vdst;
}
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    

0000036a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exit>:
SYSCALL(exit)
 372:	b8 02 00 00 00       	mov    $0x2,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <wait>:
SYSCALL(wait)
 37a:	b8 03 00 00 00       	mov    $0x3,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <pipe>:
SYSCALL(pipe)
 382:	b8 04 00 00 00       	mov    $0x4,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <read>:
SYSCALL(read)
 38a:	b8 05 00 00 00       	mov    $0x5,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <write>:
SYSCALL(write)
 392:	b8 10 00 00 00       	mov    $0x10,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <close>:
SYSCALL(close)
 39a:	b8 15 00 00 00       	mov    $0x15,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <kill>:
SYSCALL(kill)
 3a2:	b8 06 00 00 00       	mov    $0x6,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <exec>:
SYSCALL(exec)
 3aa:	b8 07 00 00 00       	mov    $0x7,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <open>:
SYSCALL(open)
 3b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mknod>:
SYSCALL(mknod)
 3ba:	b8 11 00 00 00       	mov    $0x11,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <unlink>:
SYSCALL(unlink)
 3c2:	b8 12 00 00 00       	mov    $0x12,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <fstat>:
SYSCALL(fstat)
 3ca:	b8 08 00 00 00       	mov    $0x8,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <link>:
SYSCALL(link)
 3d2:	b8 13 00 00 00       	mov    $0x13,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mkdir>:
SYSCALL(mkdir)
 3da:	b8 14 00 00 00       	mov    $0x14,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <chdir>:
SYSCALL(chdir)
 3e2:	b8 09 00 00 00       	mov    $0x9,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <dup>:
SYSCALL(dup)
 3ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getpid>:
SYSCALL(getpid)
 3f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <sbrk>:
SYSCALL(sbrk)
 3fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sleep>:
SYSCALL(sleep)
 402:	b8 0d 00 00 00       	mov    $0xd,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <uptime>:
SYSCALL(uptime)
 40a:	b8 0e 00 00 00       	mov    $0xe,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <setpriority>:
SYSCALL(setpriority)
 412:	b8 16 00 00 00       	mov    $0x16,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    
 41a:	66 90                	xchg   %ax,%ax
 41c:	66 90                	xchg   %ax,%ax
 41e:	66 90                	xchg   %ax,%ax

00000420 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	89 c6                	mov    %eax,%esi
 427:	53                   	push   %ebx
 428:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 42b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 42e:	85 db                	test   %ebx,%ebx
 430:	74 09                	je     43b <printint+0x1b>
 432:	89 d0                	mov    %edx,%eax
 434:	c1 e8 1f             	shr    $0x1f,%eax
 437:	84 c0                	test   %al,%al
 439:	75 75                	jne    4b0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43b:	89 d0                	mov    %edx,%eax
  neg = 0;
 43d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 444:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 447:	31 ff                	xor    %edi,%edi
 449:	89 ce                	mov    %ecx,%esi
 44b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 44e:	eb 02                	jmp    452 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 450:	89 cf                	mov    %ecx,%edi
 452:	31 d2                	xor    %edx,%edx
 454:	f7 f6                	div    %esi
 456:	8d 4f 01             	lea    0x1(%edi),%ecx
 459:	0f b6 92 1e 0a 00 00 	movzbl 0xa1e(%edx),%edx
  }while((x /= base) != 0);
 460:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 462:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 465:	75 e9                	jne    450 <printint+0x30>
  if(neg)
 467:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 46a:	89 c8                	mov    %ecx,%eax
 46c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 46f:	85 d2                	test   %edx,%edx
 471:	74 08                	je     47b <printint+0x5b>
    buf[i++] = '-';
 473:	8d 4f 02             	lea    0x2(%edi),%ecx
 476:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 47b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 47e:	66 90                	xchg   %ax,%ax
 480:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 485:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 488:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48f:	00 
 490:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 494:	89 34 24             	mov    %esi,(%esp)
 497:	88 45 d7             	mov    %al,-0x29(%ebp)
 49a:	e8 f3 fe ff ff       	call   392 <write>
  while(--i >= 0)
 49f:	83 ff ff             	cmp    $0xffffffff,%edi
 4a2:	75 dc                	jne    480 <printint+0x60>
    putc(fd, buf[i]);
}
 4a4:	83 c4 4c             	add    $0x4c,%esp
 4a7:	5b                   	pop    %ebx
 4a8:	5e                   	pop    %esi
 4a9:	5f                   	pop    %edi
 4aa:	5d                   	pop    %ebp
 4ab:	c3                   	ret    
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	f7 d8                	neg    %eax
    neg = 1;
 4b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4bb:	eb 87                	jmp    444 <printint+0x24>
 4bd:	8d 76 00             	lea    0x0(%esi),%esi

000004c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c4:	31 ff                	xor    %edi,%edi
{
 4c6:	56                   	push   %esi
 4c7:	53                   	push   %ebx
 4c8:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 4ce:	8d 45 10             	lea    0x10(%ebp),%eax
{
 4d1:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 4d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4d7:	0f b6 13             	movzbl (%ebx),%edx
 4da:	83 c3 01             	add    $0x1,%ebx
 4dd:	84 d2                	test   %dl,%dl
 4df:	75 39                	jne    51a <printf+0x5a>
 4e1:	e9 c2 00 00 00       	jmp    5a8 <printf+0xe8>
 4e6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4e8:	83 fa 25             	cmp    $0x25,%edx
 4eb:	0f 84 bf 00 00 00    	je     5b0 <printf+0xf0>
  write(fd, &c, 1);
 4f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4fb:	00 
 4fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 500:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 503:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 506:	e8 87 fe ff ff       	call   392 <write>
 50b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 50e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 512:	84 d2                	test   %dl,%dl
 514:	0f 84 8e 00 00 00    	je     5a8 <printf+0xe8>
    if(state == 0){
 51a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 51c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 51f:	74 c7                	je     4e8 <printf+0x28>
      }
    } else if(state == '%'){
 521:	83 ff 25             	cmp    $0x25,%edi
 524:	75 e5                	jne    50b <printf+0x4b>
      if(c == 'd'){
 526:	83 fa 64             	cmp    $0x64,%edx
 529:	0f 84 31 01 00 00    	je     660 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 52f:	25 f7 00 00 00       	and    $0xf7,%eax
 534:	83 f8 70             	cmp    $0x70,%eax
 537:	0f 84 83 00 00 00    	je     5c0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 53d:	83 fa 73             	cmp    $0x73,%edx
 540:	0f 84 a2 00 00 00    	je     5e8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 546:	83 fa 63             	cmp    $0x63,%edx
 549:	0f 84 35 01 00 00    	je     684 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 54f:	83 fa 25             	cmp    $0x25,%edx
 552:	0f 84 e0 00 00 00    	je     638 <printf+0x178>
  write(fd, &c, 1);
 558:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 55b:	83 c3 01             	add    $0x1,%ebx
 55e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 565:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 566:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 568:	89 44 24 04          	mov    %eax,0x4(%esp)
 56c:	89 34 24             	mov    %esi,(%esp)
 56f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 572:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 576:	e8 17 fe ff ff       	call   392 <write>
        putc(fd, c);
 57b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 57e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 581:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 588:	00 
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 590:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 593:	e8 fa fd ff ff       	call   392 <write>
  for(i = 0; fmt[i]; i++){
 598:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 59c:	84 d2                	test   %dl,%dl
 59e:	0f 85 76 ff ff ff    	jne    51a <printf+0x5a>
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 5a8:	83 c4 3c             	add    $0x3c,%esp
 5ab:	5b                   	pop    %ebx
 5ac:	5e                   	pop    %esi
 5ad:	5f                   	pop    %edi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    
        state = '%';
 5b0:	bf 25 00 00 00       	mov    $0x25,%edi
 5b5:	e9 51 ff ff ff       	jmp    50b <printf+0x4b>
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 5c8:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 5ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	89 f0                	mov    %esi,%eax
 5d5:	e8 46 fe ff ff       	call   420 <printint>
        ap++;
 5da:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5de:	e9 28 ff ff ff       	jmp    50b <printf+0x4b>
 5e3:	90                   	nop
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 5eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 5ef:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 5f1:	b8 17 0a 00 00       	mov    $0xa17,%eax
 5f6:	85 ff                	test   %edi,%edi
 5f8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 5fb:	0f b6 07             	movzbl (%edi),%eax
 5fe:	84 c0                	test   %al,%al
 600:	74 2a                	je     62c <printf+0x16c>
 602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 608:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 60b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 60e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 611:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 618:	00 
 619:	89 44 24 04          	mov    %eax,0x4(%esp)
 61d:	89 34 24             	mov    %esi,(%esp)
 620:	e8 6d fd ff ff       	call   392 <write>
        while(*s != 0){
 625:	0f b6 07             	movzbl (%edi),%eax
 628:	84 c0                	test   %al,%al
 62a:	75 dc                	jne    608 <printf+0x148>
      state = 0;
 62c:	31 ff                	xor    %edi,%edi
 62e:	e9 d8 fe ff ff       	jmp    50b <printf+0x4b>
 633:	90                   	nop
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 638:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 63b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 63d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 644:	00 
 645:	89 44 24 04          	mov    %eax,0x4(%esp)
 649:	89 34 24             	mov    %esi,(%esp)
 64c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 650:	e8 3d fd ff ff       	call   392 <write>
 655:	e9 b1 fe ff ff       	jmp    50b <printf+0x4b>
 65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 663:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 668:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 66b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 672:	8b 10                	mov    (%eax),%edx
 674:	89 f0                	mov    %esi,%eax
 676:	e8 a5 fd ff ff       	call   420 <printint>
        ap++;
 67b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 67f:	e9 87 fe ff ff       	jmp    50b <printf+0x4b>
        putc(fd, *ap);
 684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 687:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 689:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 68b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 692:	00 
 693:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 696:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 699:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 69c:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a0:	e8 ed fc ff ff       	call   392 <write>
        ap++;
 6a5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6a9:	e9 5d fe ff ff       	jmp    50b <printf+0x4b>
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	a1 b0 0c 00 00       	mov    0xcb0,%eax
{
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	57                   	push   %edi
 6b9:	56                   	push   %esi
 6ba:	53                   	push   %ebx
 6bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6be:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 6c0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c3:	39 d0                	cmp    %edx,%eax
 6c5:	72 11                	jb     6d8 <free+0x28>
 6c7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c8:	39 c8                	cmp    %ecx,%eax
 6ca:	72 04                	jb     6d0 <free+0x20>
 6cc:	39 ca                	cmp    %ecx,%edx
 6ce:	72 10                	jb     6e0 <free+0x30>
 6d0:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d4:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	73 f0                	jae    6c8 <free+0x18>
 6d8:	39 ca                	cmp    %ecx,%edx
 6da:	72 04                	jb     6e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dc:	39 c8                	cmp    %ecx,%eax
 6de:	72 f0                	jb     6d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6e3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6e6:	39 cf                	cmp    %ecx,%edi
 6e8:	74 1e                	je     708 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6ea:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ed:	8b 48 04             	mov    0x4(%eax),%ecx
 6f0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6f3:	39 f2                	cmp    %esi,%edx
 6f5:	74 28                	je     71f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6f7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f9:	a3 b0 0c 00 00       	mov    %eax,0xcb0
}
 6fe:	5b                   	pop    %ebx
 6ff:	5e                   	pop    %esi
 700:	5f                   	pop    %edi
 701:	5d                   	pop    %ebp
 702:	c3                   	ret    
 703:	90                   	nop
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 708:	03 71 04             	add    0x4(%ecx),%esi
 70b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 70e:	8b 08                	mov    (%eax),%ecx
 710:	8b 09                	mov    (%ecx),%ecx
 712:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 715:	8b 48 04             	mov    0x4(%eax),%ecx
 718:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 71b:	39 f2                	cmp    %esi,%edx
 71d:	75 d8                	jne    6f7 <free+0x47>
    p->s.size += bp->s.size;
 71f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 722:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    p->s.size += bp->s.size;
 727:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 72d:	89 10                	mov    %edx,(%eax)
}
 72f:	5b                   	pop    %ebx
 730:	5e                   	pop    %esi
 731:	5f                   	pop    %edi
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    
 734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 73a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	57                   	push   %edi
 744:	56                   	push   %esi
 745:	53                   	push   %ebx
 746:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 749:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 74c:	8b 1d b0 0c 00 00    	mov    0xcb0,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	8d 48 07             	lea    0x7(%eax),%ecx
 755:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 758:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 75d:	0f 84 9b 00 00 00    	je     7fe <malloc+0xbe>
 763:	8b 13                	mov    (%ebx),%edx
 765:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 768:	39 fe                	cmp    %edi,%esi
 76a:	76 64                	jbe    7d0 <malloc+0x90>
 76c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 773:	bb 00 80 00 00       	mov    $0x8000,%ebx
 778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 77b:	eb 0e                	jmp    78b <malloc+0x4b>
 77d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 780:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 782:	8b 78 04             	mov    0x4(%eax),%edi
 785:	39 fe                	cmp    %edi,%esi
 787:	76 4f                	jbe    7d8 <malloc+0x98>
 789:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78b:	3b 15 b0 0c 00 00    	cmp    0xcb0,%edx
 791:	75 ed                	jne    780 <malloc+0x40>
  if(nu < 4096)
 793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 796:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 79c:	bf 00 10 00 00       	mov    $0x1000,%edi
 7a1:	0f 43 fe             	cmovae %esi,%edi
 7a4:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 7a7:	89 04 24             	mov    %eax,(%esp)
 7aa:	e8 4b fc ff ff       	call   3fa <sbrk>
  if(p == (char*)-1)
 7af:	83 f8 ff             	cmp    $0xffffffff,%eax
 7b2:	74 18                	je     7cc <malloc+0x8c>
  hp->s.size = nu;
 7b4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7b7:	83 c0 08             	add    $0x8,%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 ee fe ff ff       	call   6b0 <free>
  return freep;
 7c2:	8b 15 b0 0c 00 00    	mov    0xcb0,%edx
      if((p = morecore(nunits)) == 0)
 7c8:	85 d2                	test   %edx,%edx
 7ca:	75 b4                	jne    780 <malloc+0x40>
        return 0;
 7cc:	31 c0                	xor    %eax,%eax
 7ce:	eb 20                	jmp    7f0 <malloc+0xb0>
    if(p->s.size >= nunits){
 7d0:	89 d0                	mov    %edx,%eax
 7d2:	89 da                	mov    %ebx,%edx
 7d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7d8:	39 fe                	cmp    %edi,%esi
 7da:	74 1c                	je     7f8 <malloc+0xb8>
        p->s.size -= nunits;
 7dc:	29 f7                	sub    %esi,%edi
 7de:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 7e1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 7e4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7e7:	89 15 b0 0c 00 00    	mov    %edx,0xcb0
      return (void*)(p + 1);
 7ed:	83 c0 08             	add    $0x8,%eax
  }
}
 7f0:	83 c4 1c             	add    $0x1c,%esp
 7f3:	5b                   	pop    %ebx
 7f4:	5e                   	pop    %esi
 7f5:	5f                   	pop    %edi
 7f6:	5d                   	pop    %ebp
 7f7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7f8:	8b 08                	mov    (%eax),%ecx
 7fa:	89 0a                	mov    %ecx,(%edx)
 7fc:	eb e9                	jmp    7e7 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 7fe:	c7 05 b0 0c 00 00 b4 	movl   $0xcb4,0xcb0
 805:	0c 00 00 
    base.s.size = 0;
 808:	ba b4 0c 00 00       	mov    $0xcb4,%edx
    base.s.ptr = freep = prevp = &base;
 80d:	c7 05 b4 0c 00 00 b4 	movl   $0xcb4,0xcb4
 814:	0c 00 00 
    base.s.size = 0;
 817:	c7 05 b8 0c 00 00 00 	movl   $0x0,0xcb8
 81e:	00 00 00 
 821:	e9 46 ff ff ff       	jmp    76c <malloc+0x2c>
