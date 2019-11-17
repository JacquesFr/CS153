
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2d 10 80       	mov    $0x80102dc0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 e0 6c 10 	movl   $0x80106ce0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 e0 3f 00 00       	call   80104040 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 e7 6c 10 	movl   $0x80106ce7,0x4(%esp)
8010009b:	80 
8010009c:	e8 6f 3e 00 00       	call   80103f10 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 c5 40 00 00       	call   801041b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ba 40 00 00       	call   80104220 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 df 3d 00 00       	call   80103f50 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 72 1f 00 00       	call   801020f0 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 ee 6c 10 80 	movl   $0x80106cee,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 3b 3e 00 00       	call   80103ff0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 ff 6c 10 80 	movl   $0x80106cff,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 fa 3d 00 00       	call   80103ff0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ae 3d 00 00       	call   80103fb0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 a2 3f 00 00       	call   801041b0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 cb 3f 00 00       	jmp    80104220 <release>
    panic("brelse");
80100255:	c7 04 24 06 6d 10 80 	movl   $0x80106d06,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 d9 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 1d 3f 00 00       	call   801041b0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 c3 33 00 00       	call   80103670 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 08 39 00 00       	call   80103bd0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 0a 3f 00 00       	call   80104220 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 62 13 00 00       	call   80101680 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 ec 3e 00 00       	call   80104220 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 44 13 00 00       	call   80101680 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 b5 23 00 00       	call   80102730 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 0d 6d 10 80 	movl   $0x80106d0d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 9f 76 10 80 	movl   $0x8010769f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ac 3c 00 00       	call   80104060 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 21 6d 10 80 	movl   $0x80106d21,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 82 53 00 00       	call   80105790 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 d2 52 00 00       	call   80105790 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 c6 52 00 00       	call   80105790 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ba 52 00 00       	call   80105790 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 0f 3e 00 00       	call   80104310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 3d 00 00       	call   80104270 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 25 6d 10 80 	movl   $0x80106d25,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 50 6d 10 80 	movzbl -0x7fef92b0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 59 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 9d 3b 00 00       	call   801041b0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 e5 3b 00 00       	call   80104220 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 3a 10 00 00       	call   80101680 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 28 3b 00 00       	call   80104220 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 38 6d 10 80       	mov    $0x80106d38,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 14 3a 00 00       	call   801041b0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 e6 39 00 00       	call   801041b0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 f4 39 00 00       	call   80104220 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 a9 34 00 00       	call   80103d60 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 14 35 00 00       	jmp    80103e40 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 48 6d 10 	movl   $0x80106d48,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 d6 36 00 00       	call   80104040 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 e4 18 00 00       	call   80102280 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 bf 2c 00 00       	call   80103670 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 24 21 00 00       	call   80102ae0 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 09 15 00 00       	call   80101ed0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 3f 02 00 00    	je     80100c10 <exec+0x270>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 a7 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 35 0f 00 00       	call   80101930 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 d8 0e 00 00       	call   801018e0 <iunlockput>
    end_op();
80100a08:	e8 43 21 00 00       	call   80102b50 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 4f 5f 00 00       	call   80106980 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 9d 0e 00 00       	call   80101930 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 19 5d 00 00       	call   801067f0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 18 5c 00 00       	call   80106730 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 d2 5d 00 00       	call   80106900 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 a5 0d 00 00       	call   801018e0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 0b 20 00 00       	call   80102b50 <end_op>
  if((sp = allocuvm(pgdir, STACKTOP - PGSIZE, STACKTOP)) == 0)
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100b52:	7f 
80100b53:	c7 44 24 04 ff ef ff 	movl   $0x7fffefff,0x4(%esp)
80100b5a:	7f 
80100b5b:	89 04 24             	mov    %eax,(%esp)
80100b5e:	e8 8d 5c 00 00       	call   801067f0 <allocuvm>
80100b63:	85 c0                	test   %eax,%eax
80100b65:	89 c3                	mov    %eax,%ebx
80100b67:	0f 84 8b 00 00 00    	je     80100bf8 <exec+0x258>
  for(argc = 0; argv[argc]; argc++) {
80100b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b70:	8b 00                	mov    (%eax),%eax
80100b72:	85 c0                	test   %eax,%eax
80100b74:	0f 84 8f 01 00 00    	je     80100d09 <exec+0x369>
80100b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b7d:	31 d2                	xor    %edx,%edx
80100b7f:	8d 71 04             	lea    0x4(%ecx),%esi
80100b82:	89 cf                	mov    %ecx,%edi
80100b84:	89 f1                	mov    %esi,%ecx
80100b86:	89 d6                	mov    %edx,%esi
80100b88:	89 ca                	mov    %ecx,%edx
80100b8a:	eb 2a                	jmp    80100bb6 <exec+0x216>
80100b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b90:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    ustack[3+argc] = sp;
80100b96:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100b9c:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ba3:	83 c6 01             	add    $0x1,%esi
80100ba6:	8b 02                	mov    (%edx),%eax
80100ba8:	89 d7                	mov    %edx,%edi
80100baa:	85 c0                	test   %eax,%eax
80100bac:	74 7d                	je     80100c2b <exec+0x28b>
80100bae:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bb1:	83 fe 20             	cmp    $0x20,%esi
80100bb4:	74 42                	je     80100bf8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bb6:	89 04 24             	mov    %eax,(%esp)
80100bb9:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bbf:	e8 cc 38 00 00       	call   80104490 <strlen>
80100bc4:	f7 d0                	not    %eax
80100bc6:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bc8:	8b 07                	mov    (%edi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bca:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bcd:	89 04 24             	mov    %eax,(%esp)
80100bd0:	e8 bb 38 00 00       	call   80104490 <strlen>
80100bd5:	83 c0 01             	add    $0x1,%eax
80100bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bdc:	8b 07                	mov    (%edi),%eax
80100bde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100be2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100be6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bec:	89 04 24             	mov    %eax,(%esp)
80100bef:	e8 5c 60 00 00       	call   80106c50 <copyout>
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	79 98                	jns    80100b90 <exec+0x1f0>
    freevm(pgdir);
80100bf8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bfe:	89 04 24             	mov    %eax,(%esp)
80100c01:	e8 fa 5c 00 00       	call   80106900 <freevm>
  return -1;
80100c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0b:	e9 02 fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100c10:	e8 3b 1f 00 00       	call   80102b50 <end_op>
    cprintf("exec: fail\n");
80100c15:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
80100c1c:	e8 2f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c26:	e9 e7 fd ff ff       	jmp    80100a12 <exec+0x72>
80100c2b:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100c2d:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c34:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c38:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c3f:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c45:	89 da                	mov    %ebx,%edx
80100c47:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c49:	83 c0 0c             	add    $0xc,%eax
80100c4c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c52:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c60:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c67:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c6a:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c6d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	e8 d8 5f 00 00       	call   80106c50 <copyout>
80100c78:	85 c0                	test   %eax,%eax
80100c7a:	0f 88 78 ff ff ff    	js     80100bf8 <exec+0x258>
  for(last=s=path; *s; s++)
80100c80:	8b 45 08             	mov    0x8(%ebp),%eax
80100c83:	0f b6 10             	movzbl (%eax),%edx
80100c86:	84 d2                	test   %dl,%dl
80100c88:	74 19                	je     80100ca3 <exec+0x303>
80100c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c8d:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100c90:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100c93:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100c96:	0f 44 c8             	cmove  %eax,%ecx
80100c99:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100c9c:	84 d2                	test   %dl,%dl
80100c9e:	75 f0                	jne    80100c90 <exec+0x2f0>
80100ca0:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ca3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cac:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cb3:	00 
80100cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb8:	89 f8                	mov    %edi,%eax
80100cba:	83 c0 6c             	add    $0x6c,%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 8b 37 00 00       	call   80104450 <safestrcpy>
  curproc->pgdir = pgdir;
80100cc5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100ccb:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cce:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100cd1:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100cd4:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cda:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cdc:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ce2:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ce5:	8b 47 18             	mov    0x18(%edi),%eax
80100ce8:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ceb:	89 3c 24             	mov    %edi,(%esp)
80100cee:	e8 ad 58 00 00       	call   801065a0 <switchuvm>
  freevm(oldpgdir);
80100cf3:	89 34 24             	mov    %esi,(%esp)
80100cf6:	e8 05 5c 00 00       	call   80106900 <freevm>
  return 0;
80100cfb:	31 c0                	xor    %eax,%eax
  curproc->stackPages = 1;
80100cfd:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
  return 0;
80100d04:	e9 09 fd ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d09:	31 d2                	xor    %edx,%edx
80100d0b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d11:	e9 17 ff ff ff       	jmp    80100c2d <exec+0x28d>
80100d16:	66 90                	xchg   %ax,%ax
80100d18:	66 90                	xchg   %ax,%ax
80100d1a:	66 90                	xchg   %ax,%ax
80100d1c:	66 90                	xchg   %ax,%ax
80100d1e:	66 90                	xchg   %ax,%ax

80100d20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d26:	c7 44 24 04 6d 6d 10 	movl   $0x80106d6d,0x4(%esp)
80100d2d:	80 
80100d2e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d35:	e8 06 33 00 00       	call   80104040 <initlock>
}
80100d3a:	c9                   	leave  
80100d3b:	c3                   	ret    
80100d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d44:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d49:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d53:	e8 58 34 00 00       	call   801041b0 <acquire>
80100d58:	eb 11                	jmp    80100d6b <filealloc+0x2b>
80100d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d60:	83 c3 18             	add    $0x18,%ebx
80100d63:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d69:	74 25                	je     80100d90 <filealloc+0x50>
    if(f->ref == 0){
80100d6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6e:	85 c0                	test   %eax,%eax
80100d70:	75 ee                	jne    80100d60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d72:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100d79:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d80:	e8 9b 34 00 00       	call   80104220 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d85:	83 c4 14             	add    $0x14,%esp
      return f;
80100d88:	89 d8                	mov    %ebx,%eax
}
80100d8a:	5b                   	pop    %ebx
80100d8b:	5d                   	pop    %ebp
80100d8c:	c3                   	ret    
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100d90:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d97:	e8 84 34 00 00       	call   80104220 <release>
}
80100d9c:	83 c4 14             	add    $0x14,%esp
  return 0;
80100d9f:	31 c0                	xor    %eax,%eax
}
80100da1:	5b                   	pop    %ebx
80100da2:	5d                   	pop    %ebp
80100da3:	c3                   	ret    
80100da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100db0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
80100db4:	83 ec 14             	sub    $0x14,%esp
80100db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dba:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc1:	e8 ea 33 00 00       	call   801041b0 <acquire>
  if(f->ref < 1)
80100dc6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc9:	85 c0                	test   %eax,%eax
80100dcb:	7e 1a                	jle    80100de7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dcd:	83 c0 01             	add    $0x1,%eax
80100dd0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dd3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dda:	e8 41 34 00 00       	call   80104220 <release>
  return f;
}
80100ddf:	83 c4 14             	add    $0x14,%esp
80100de2:	89 d8                	mov    %ebx,%eax
80100de4:	5b                   	pop    %ebx
80100de5:	5d                   	pop    %ebp
80100de6:	c3                   	ret    
    panic("filedup");
80100de7:	c7 04 24 74 6d 10 80 	movl   $0x80106d74,(%esp)
80100dee:	e8 6d f5 ff ff       	call   80100360 <panic>
80100df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	83 ec 1c             	sub    $0x1c,%esp
80100e09:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e0c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e13:	e8 98 33 00 00       	call   801041b0 <acquire>
  if(f->ref < 1)
80100e18:	8b 57 04             	mov    0x4(%edi),%edx
80100e1b:	85 d2                	test   %edx,%edx
80100e1d:	0f 8e 89 00 00 00    	jle    80100eac <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e23:	83 ea 01             	sub    $0x1,%edx
80100e26:	85 d2                	test   %edx,%edx
80100e28:	89 57 04             	mov    %edx,0x4(%edi)
80100e2b:	74 13                	je     80100e40 <fileclose+0x40>
    release(&ftable.lock);
80100e2d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e34:	83 c4 1c             	add    $0x1c,%esp
80100e37:	5b                   	pop    %ebx
80100e38:	5e                   	pop    %esi
80100e39:	5f                   	pop    %edi
80100e3a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e3b:	e9 e0 33 00 00       	jmp    80104220 <release>
  ff = *f;
80100e40:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e44:	8b 37                	mov    (%edi),%esi
80100e46:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e49:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e4f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e52:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e55:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e5f:	e8 bc 33 00 00       	call   80104220 <release>
  if(ff.type == FD_PIPE)
80100e64:	83 fe 01             	cmp    $0x1,%esi
80100e67:	74 0f                	je     80100e78 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e69:	83 fe 02             	cmp    $0x2,%esi
80100e6c:	74 22                	je     80100e90 <fileclose+0x90>
}
80100e6e:	83 c4 1c             	add    $0x1c,%esp
80100e71:	5b                   	pop    %ebx
80100e72:	5e                   	pop    %esi
80100e73:	5f                   	pop    %edi
80100e74:	5d                   	pop    %ebp
80100e75:	c3                   	ret    
80100e76:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100e78:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e7c:	89 1c 24             	mov    %ebx,(%esp)
80100e7f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e83:	e8 a8 23 00 00       	call   80103230 <pipeclose>
80100e88:	eb e4                	jmp    80100e6e <fileclose+0x6e>
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100e90:	e8 4b 1c 00 00       	call   80102ae0 <begin_op>
    iput(ff.ip);
80100e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e98:	89 04 24             	mov    %eax,(%esp)
80100e9b:	e8 00 09 00 00       	call   801017a0 <iput>
}
80100ea0:	83 c4 1c             	add    $0x1c,%esp
80100ea3:	5b                   	pop    %ebx
80100ea4:	5e                   	pop    %esi
80100ea5:	5f                   	pop    %edi
80100ea6:	5d                   	pop    %ebp
    end_op();
80100ea7:	e9 a4 1c 00 00       	jmp    80102b50 <end_op>
    panic("fileclose");
80100eac:	c7 04 24 7c 6d 10 80 	movl   $0x80106d7c,(%esp)
80100eb3:	e8 a8 f4 ff ff       	call   80100360 <panic>
80100eb8:	90                   	nop
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 14             	sub    $0x14,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ecd:	75 31                	jne    80100f00 <filestat+0x40>
    ilock(f->ip);
80100ecf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ed2:	89 04 24             	mov    %eax,(%esp)
80100ed5:	e8 a6 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100eda:	8b 45 0c             	mov    0xc(%ebp),%eax
80100edd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee4:	89 04 24             	mov    %eax,(%esp)
80100ee7:	e8 14 0a 00 00       	call   80101900 <stati>
    iunlock(f->ip);
80100eec:	8b 43 10             	mov    0x10(%ebx),%eax
80100eef:	89 04 24             	mov    %eax,(%esp)
80100ef2:	e8 69 08 00 00       	call   80101760 <iunlock>
    return 0;
  }
  return -1;
}
80100ef7:	83 c4 14             	add    $0x14,%esp
    return 0;
80100efa:	31 c0                	xor    %eax,%eax
}
80100efc:	5b                   	pop    %ebx
80100efd:	5d                   	pop    %ebp
80100efe:	c3                   	ret    
80100eff:	90                   	nop
80100f00:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f08:	5b                   	pop    %ebx
80100f09:	5d                   	pop    %ebp
80100f0a:	c3                   	ret    
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 1c             	sub    $0x1c,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f22:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f26:	74 68                	je     80100f90 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f28:	8b 03                	mov    (%ebx),%eax
80100f2a:	83 f8 01             	cmp    $0x1,%eax
80100f2d:	74 49                	je     80100f78 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f2f:	83 f8 02             	cmp    $0x2,%eax
80100f32:	75 63                	jne    80100f97 <fileread+0x87>
    ilock(f->ip);
80100f34:	8b 43 10             	mov    0x10(%ebx),%eax
80100f37:	89 04 24             	mov    %eax,(%esp)
80100f3a:	e8 41 07 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f3f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f43:	8b 43 14             	mov    0x14(%ebx),%eax
80100f46:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f4a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f4e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f51:	89 04 24             	mov    %eax,(%esp)
80100f54:	e8 d7 09 00 00       	call   80101930 <readi>
80100f59:	85 c0                	test   %eax,%eax
80100f5b:	89 c6                	mov    %eax,%esi
80100f5d:	7e 03                	jle    80100f62 <fileread+0x52>
      f->off += r;
80100f5f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f62:	8b 43 10             	mov    0x10(%ebx),%eax
80100f65:	89 04 24             	mov    %eax,(%esp)
80100f68:	e8 f3 07 00 00       	call   80101760 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f6f:	83 c4 1c             	add    $0x1c,%esp
80100f72:	5b                   	pop    %ebx
80100f73:	5e                   	pop    %esi
80100f74:	5f                   	pop    %edi
80100f75:	5d                   	pop    %ebp
80100f76:	c3                   	ret    
80100f77:	90                   	nop
    return piperead(f->pipe, addr, n);
80100f78:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f7b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f7e:	83 c4 1c             	add    $0x1c,%esp
80100f81:	5b                   	pop    %ebx
80100f82:	5e                   	pop    %esi
80100f83:	5f                   	pop    %edi
80100f84:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f85:	e9 26 24 00 00       	jmp    801033b0 <piperead>
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f95:	eb d8                	jmp    80100f6f <fileread+0x5f>
  panic("fileread");
80100f97:	c7 04 24 86 6d 10 80 	movl   $0x80106d86,(%esp)
80100f9e:	e8 bd f3 ff ff       	call   80100360 <panic>
80100fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fb0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	57                   	push   %edi
80100fb4:	56                   	push   %esi
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 2c             	sub    $0x2c,%esp
80100fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fc5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100fcc:	0f 84 ae 00 00 00    	je     80101080 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fd2:	8b 07                	mov    (%edi),%eax
80100fd4:	83 f8 01             	cmp    $0x1,%eax
80100fd7:	0f 84 c2 00 00 00    	je     8010109f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdd:	83 f8 02             	cmp    $0x2,%eax
80100fe0:	0f 85 d7 00 00 00    	jne    801010bd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe9:	31 db                	xor    %ebx,%ebx
80100feb:	85 c0                	test   %eax,%eax
80100fed:	7f 31                	jg     80101020 <filewrite+0x70>
80100fef:	e9 9c 00 00 00       	jmp    80101090 <filewrite+0xe0>
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100ff8:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
80100ffb:	01 47 14             	add    %eax,0x14(%edi)
80100ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101001:	89 0c 24             	mov    %ecx,(%esp)
80101004:	e8 57 07 00 00       	call   80101760 <iunlock>
      end_op();
80101009:	e8 42 1b 00 00       	call   80102b50 <end_op>
8010100e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101011:	39 f0                	cmp    %esi,%eax
80101013:	0f 85 98 00 00 00    	jne    801010b1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101019:	01 c3                	add    %eax,%ebx
    while(i < n){
8010101b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010101e:	7e 70                	jle    80101090 <filewrite+0xe0>
      int n1 = n - i;
80101020:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101023:	b8 00 06 00 00       	mov    $0x600,%eax
80101028:	29 de                	sub    %ebx,%esi
8010102a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101030:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101033:	e8 a8 1a 00 00       	call   80102ae0 <begin_op>
      ilock(f->ip);
80101038:	8b 47 10             	mov    0x10(%edi),%eax
8010103b:	89 04 24             	mov    %eax,(%esp)
8010103e:	e8 3d 06 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101043:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101047:	8b 47 14             	mov    0x14(%edi),%eax
8010104a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010104e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101051:	01 d8                	add    %ebx,%eax
80101053:	89 44 24 04          	mov    %eax,0x4(%esp)
80101057:	8b 47 10             	mov    0x10(%edi),%eax
8010105a:	89 04 24             	mov    %eax,(%esp)
8010105d:	e8 ce 09 00 00       	call   80101a30 <writei>
80101062:	85 c0                	test   %eax,%eax
80101064:	7f 92                	jg     80100ff8 <filewrite+0x48>
      iunlock(f->ip);
80101066:	8b 4f 10             	mov    0x10(%edi),%ecx
80101069:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010106c:	89 0c 24             	mov    %ecx,(%esp)
8010106f:	e8 ec 06 00 00       	call   80101760 <iunlock>
      end_op();
80101074:	e8 d7 1a 00 00       	call   80102b50 <end_op>
      if(r < 0)
80101079:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107c:	85 c0                	test   %eax,%eax
8010107e:	74 91                	je     80101011 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101080:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	5b                   	pop    %ebx
80101089:	5e                   	pop    %esi
8010108a:	5f                   	pop    %edi
8010108b:	5d                   	pop    %ebp
8010108c:	c3                   	ret    
8010108d:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
80101090:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101093:	89 d8                	mov    %ebx,%eax
80101095:	75 e9                	jne    80101080 <filewrite+0xd0>
}
80101097:	83 c4 2c             	add    $0x2c,%esp
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
8010109e:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010109f:	8b 47 0c             	mov    0xc(%edi),%eax
801010a2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a5:	83 c4 2c             	add    $0x2c,%esp
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ac:	e9 0f 22 00 00       	jmp    801032c0 <pipewrite>
        panic("short filewrite");
801010b1:	c7 04 24 8f 6d 10 80 	movl   $0x80106d8f,(%esp)
801010b8:	e8 a3 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010bd:	c7 04 24 95 6d 10 80 	movl   $0x80106d95,(%esp)
801010c4:	e8 97 f2 ff ff       	call   80100360 <panic>
801010c9:	66 90                	xchg   %ax,%ax
801010cb:	66 90                	xchg   %ax,%ax
801010cd:	66 90                	xchg   %ax,%ax
801010cf:	90                   	nop

801010d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	89 d7                	mov    %edx,%edi
801010d6:	56                   	push   %esi
801010d7:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801010d8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
801010dd:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
801010e0:	c1 ea 0c             	shr    $0xc,%edx
801010e3:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801010e9:	89 04 24             	mov    %eax,(%esp)
801010ec:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f0:	e8 db ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801010f5:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
801010f7:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801010fd:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
801010ff:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101102:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101105:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101107:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101109:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010110e:	0f b6 c8             	movzbl %al,%ecx
80101111:	85 d9                	test   %ebx,%ecx
80101113:	74 20                	je     80101135 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101115:	f7 d3                	not    %ebx
80101117:	21 c3                	and    %eax,%ebx
80101119:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010111d:	89 34 24             	mov    %esi,(%esp)
80101120:	e8 5b 1b 00 00       	call   80102c80 <log_write>
  brelse(bp);
80101125:	89 34 24             	mov    %esi,(%esp)
80101128:	e8 b3 f0 ff ff       	call   801001e0 <brelse>
}
8010112d:	83 c4 1c             	add    $0x1c,%esp
80101130:	5b                   	pop    %ebx
80101131:	5e                   	pop    %esi
80101132:	5f                   	pop    %edi
80101133:	5d                   	pop    %ebp
80101134:	c3                   	ret    
    panic("freeing free block");
80101135:	c7 04 24 9f 6d 10 80 	movl   $0x80106d9f,(%esp)
8010113c:	e8 1f f2 ff ff       	call   80100360 <panic>
80101141:	eb 0d                	jmp    80101150 <balloc>
80101143:	90                   	nop
80101144:	90                   	nop
80101145:	90                   	nop
80101146:	90                   	nop
80101147:	90                   	nop
80101148:	90                   	nop
80101149:	90                   	nop
8010114a:	90                   	nop
8010114b:	90                   	nop
8010114c:	90                   	nop
8010114d:	90                   	nop
8010114e:	90                   	nop
8010114f:	90                   	nop

80101150 <balloc>:
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 2c             	sub    $0x2c,%esp
80101159:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010115c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101161:	85 c0                	test   %eax,%eax
80101163:	0f 84 8c 00 00 00    	je     801011f5 <balloc+0xa5>
80101169:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101170:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101173:	89 f0                	mov    %esi,%eax
80101175:	c1 f8 0c             	sar    $0xc,%eax
80101178:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010117e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101182:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101185:	89 04 24             	mov    %eax,(%esp)
80101188:	e8 43 ef ff ff       	call   801000d0 <bread>
8010118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101190:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101195:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101198:	31 c0                	xor    %eax,%eax
8010119a:	eb 33                	jmp    801011cf <balloc+0x7f>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011a0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011a3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011a5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011a7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011aa:	83 e1 07             	and    $0x7,%ecx
801011ad:	bf 01 00 00 00       	mov    $0x1,%edi
801011b2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011b4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011b9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011bb:	0f b6 fb             	movzbl %bl,%edi
801011be:	85 cf                	test   %ecx,%edi
801011c0:	74 46                	je     80101208 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c2:	83 c0 01             	add    $0x1,%eax
801011c5:	83 c6 01             	add    $0x1,%esi
801011c8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011cd:	74 05                	je     801011d4 <balloc+0x84>
801011cf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011d2:	72 cc                	jb     801011a0 <balloc+0x50>
    brelse(bp);
801011d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011d7:	89 04 24             	mov    %eax,(%esp)
801011da:	e8 01 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011df:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011e9:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
801011ef:	0f 82 7b ff ff ff    	jb     80101170 <balloc+0x20>
  panic("balloc: out of blocks");
801011f5:	c7 04 24 b2 6d 10 80 	movl   $0x80106db2,(%esp)
801011fc:	e8 5f f1 ff ff       	call   80100360 <panic>
80101201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101208:	09 d9                	or     %ebx,%ecx
8010120a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010120d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101211:	89 1c 24             	mov    %ebx,(%esp)
80101214:	e8 67 1a 00 00       	call   80102c80 <log_write>
        brelse(bp);
80101219:	89 1c 24             	mov    %ebx,(%esp)
8010121c:	e8 bf ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101221:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101224:	89 74 24 04          	mov    %esi,0x4(%esp)
80101228:	89 04 24             	mov    %eax,(%esp)
8010122b:	e8 a0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101230:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101237:	00 
80101238:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010123f:	00 
  bp = bread(dev, bno);
80101240:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101242:	8d 40 5c             	lea    0x5c(%eax),%eax
80101245:	89 04 24             	mov    %eax,(%esp)
80101248:	e8 23 30 00 00       	call   80104270 <memset>
  log_write(bp);
8010124d:	89 1c 24             	mov    %ebx,(%esp)
80101250:	e8 2b 1a 00 00       	call   80102c80 <log_write>
  brelse(bp);
80101255:	89 1c 24             	mov    %ebx,(%esp)
80101258:	e8 83 ef ff ff       	call   801001e0 <brelse>
}
8010125d:	83 c4 2c             	add    $0x2c,%esp
80101260:	89 f0                	mov    %esi,%eax
80101262:	5b                   	pop    %ebx
80101263:	5e                   	pop    %esi
80101264:	5f                   	pop    %edi
80101265:	5d                   	pop    %ebp
80101266:	c3                   	ret    
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101270 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	57                   	push   %edi
80101274:	89 c7                	mov    %eax,%edi
80101276:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101277:	31 f6                	xor    %esi,%esi
{
80101279:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010127f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101282:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010128c:	e8 1f 2f 00 00       	call   801041b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101294:	eb 14                	jmp    801012aa <iget+0x3a>
80101296:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101298:	85 f6                	test   %esi,%esi
8010129a:	74 3c                	je     801012d8 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129c:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012a8:	74 46                	je     801012f0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012aa:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012ad:	85 c9                	test   %ecx,%ecx
801012af:	7e e7                	jle    80101298 <iget+0x28>
801012b1:	39 3b                	cmp    %edi,(%ebx)
801012b3:	75 e3                	jne    80101298 <iget+0x28>
801012b5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012b8:	75 de                	jne    80101298 <iget+0x28>
      ip->ref++;
801012ba:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012bd:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
801012c6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012c9:	e8 52 2f 00 00       	call   80104220 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ce:	83 c4 1c             	add    $0x1c,%esp
801012d1:	89 f0                	mov    %esi,%eax
801012d3:	5b                   	pop    %ebx
801012d4:	5e                   	pop    %esi
801012d5:	5f                   	pop    %edi
801012d6:	5d                   	pop    %ebp
801012d7:	c3                   	ret    
801012d8:	85 c9                	test   %ecx,%ecx
801012da:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012dd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e9:	75 bf                	jne    801012aa <iget+0x3a>
801012eb:	90                   	nop
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 29                	je     8010131d <iget+0xad>
  ip->dev = dev;
801012f4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012f9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101300:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101307:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010130e:	e8 0d 2f 00 00       	call   80104220 <release>
}
80101313:	83 c4 1c             	add    $0x1c,%esp
80101316:	89 f0                	mov    %esi,%eax
80101318:	5b                   	pop    %ebx
80101319:	5e                   	pop    %esi
8010131a:	5f                   	pop    %edi
8010131b:	5d                   	pop    %ebp
8010131c:	c3                   	ret    
    panic("iget: no inodes");
8010131d:	c7 04 24 c8 6d 10 80 	movl   $0x80106dc8,(%esp)
80101324:	e8 37 f0 ff ff       	call   80100360 <panic>
80101329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101330 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	89 c3                	mov    %eax,%ebx
80101338:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010133b:	83 fa 0b             	cmp    $0xb,%edx
8010133e:	77 18                	ja     80101358 <bmap+0x28>
80101340:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101343:	8b 46 5c             	mov    0x5c(%esi),%eax
80101346:	85 c0                	test   %eax,%eax
80101348:	74 66                	je     801013b0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	83 c4 1c             	add    $0x1c,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101358:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010135b:	83 fe 7f             	cmp    $0x7f,%esi
8010135e:	77 77                	ja     801013d7 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101360:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 5e                	je     801013c8 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010136a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010136e:	8b 03                	mov    (%ebx),%eax
80101370:	89 04 24             	mov    %eax,(%esp)
80101373:	e8 58 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101378:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010137c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010137e:	8b 32                	mov    (%edx),%esi
80101380:	85 f6                	test   %esi,%esi
80101382:	75 19                	jne    8010139d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101384:	8b 03                	mov    (%ebx),%eax
80101386:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101389:	e8 c2 fd ff ff       	call   80101150 <balloc>
8010138e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101391:	89 02                	mov    %eax,(%edx)
80101393:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101395:	89 3c 24             	mov    %edi,(%esp)
80101398:	e8 e3 18 00 00       	call   80102c80 <log_write>
    brelse(bp);
8010139d:	89 3c 24             	mov    %edi,(%esp)
801013a0:	e8 3b ee ff ff       	call   801001e0 <brelse>
}
801013a5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013a8:	89 f0                	mov    %esi,%eax
}
801013aa:	5b                   	pop    %ebx
801013ab:	5e                   	pop    %esi
801013ac:	5f                   	pop    %edi
801013ad:	5d                   	pop    %ebp
801013ae:	c3                   	ret    
801013af:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013b0:	8b 03                	mov    (%ebx),%eax
801013b2:	e8 99 fd ff ff       	call   80101150 <balloc>
801013b7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013ba:	83 c4 1c             	add    $0x1c,%esp
801013bd:	5b                   	pop    %ebx
801013be:	5e                   	pop    %esi
801013bf:	5f                   	pop    %edi
801013c0:	5d                   	pop    %ebp
801013c1:	c3                   	ret    
801013c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013c8:	8b 03                	mov    (%ebx),%eax
801013ca:	e8 81 fd ff ff       	call   80101150 <balloc>
801013cf:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013d5:	eb 93                	jmp    8010136a <bmap+0x3a>
  panic("bmap: out of range");
801013d7:	c7 04 24 d8 6d 10 80 	movl   $0x80106dd8,(%esp)
801013de:	e8 7d ef ff ff       	call   80100360 <panic>
801013e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <readsb>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013f8:	8b 45 08             	mov    0x8(%ebp),%eax
801013fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101402:	00 
{
80101403:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101406:	89 04 24             	mov    %eax,(%esp)
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010140e:	89 34 24             	mov    %esi,(%esp)
80101411:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101418:	00 
  bp = bread(dev, 1);
80101419:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010141b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010141e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101422:	e8 e9 2e 00 00       	call   80104310 <memmove>
  brelse(bp);
80101427:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	5b                   	pop    %ebx
8010142e:	5e                   	pop    %esi
8010142f:	5d                   	pop    %ebp
  brelse(bp);
80101430:	e9 ab ed ff ff       	jmp    801001e0 <brelse>
80101435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101440 <iinit>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	53                   	push   %ebx
80101444:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101449:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010144c:	c7 44 24 04 eb 6d 10 	movl   $0x80106deb,0x4(%esp)
80101453:	80 
80101454:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010145b:	e8 e0 2b 00 00       	call   80104040 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101460:	89 1c 24             	mov    %ebx,(%esp)
80101463:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101469:	c7 44 24 04 f2 6d 10 	movl   $0x80106df2,0x4(%esp)
80101470:	80 
80101471:	e8 9a 2a 00 00       	call   80103f10 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101476:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010147c:	75 e2                	jne    80101460 <iinit+0x20>
  readsb(dev, &sb);
8010147e:	8b 45 08             	mov    0x8(%ebp),%eax
80101481:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101488:	80 
80101489:	89 04 24             	mov    %eax,(%esp)
8010148c:	e8 5f ff ff ff       	call   801013f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101491:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101496:	c7 04 24 58 6e 10 80 	movl   $0x80106e58,(%esp)
8010149d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014a1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014a6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014aa:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014af:	89 44 24 14          	mov    %eax,0x14(%esp)
801014b3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014b8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014bc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014c5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801014ce:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014d7:	e8 74 f1 ff ff       	call   80100650 <cprintf>
}
801014dc:	83 c4 24             	add    $0x24,%esp
801014df:	5b                   	pop    %ebx
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret    
801014e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014f0 <ialloc>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 2c             	sub    $0x2c,%esp
801014f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801014fc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101503:	8b 7d 08             	mov    0x8(%ebp),%edi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 a2 00 00 00    	jbe    801015b1 <ialloc+0xc1>
8010150f:	be 01 00 00 00       	mov    $0x1,%esi
80101514:	bb 01 00 00 00       	mov    $0x1,%ebx
80101519:	eb 1a                	jmp    80101535 <ialloc+0x45>
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101520:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101526:	e8 b5 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010152b:	89 de                	mov    %ebx,%esi
8010152d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101533:	73 7c                	jae    801015b1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101535:	89 f0                	mov    %esi,%eax
80101537:	c1 e8 03             	shr    $0x3,%eax
8010153a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101540:	89 3c 24             	mov    %edi,(%esp)
80101543:	89 44 24 04          	mov    %eax,0x4(%esp)
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 f0                	mov    %esi,%eax
80101550:	83 e0 07             	and    $0x7,%eax
80101553:	c1 e0 06             	shl    $0x6,%eax
80101556:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010155e:	75 c0                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101560:	89 0c 24             	mov    %ecx,(%esp)
80101563:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010156a:	00 
8010156b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101572:	00 
80101573:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	e8 f2 2c 00 00       	call   80104270 <memset>
      dip->type = type;
8010157e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101582:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
80101585:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101588:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
8010158b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158e:	89 14 24             	mov    %edx,(%esp)
80101591:	e8 ea 16 00 00       	call   80102c80 <log_write>
      brelse(bp);
80101596:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101599:	89 14 24             	mov    %edx,(%esp)
8010159c:	e8 3f ec ff ff       	call   801001e0 <brelse>
}
801015a1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015a4:	89 f2                	mov    %esi,%edx
}
801015a6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015a7:	89 f8                	mov    %edi,%eax
}
801015a9:	5e                   	pop    %esi
801015aa:	5f                   	pop    %edi
801015ab:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ac:	e9 bf fc ff ff       	jmp    80101270 <iget>
  panic("ialloc: no inodes");
801015b1:	c7 04 24 f8 6d 10 80 	movl   $0x80106df8,(%esp)
801015b8:	e8 a3 ed ff ff       	call   80100360 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	83 ec 10             	sub    $0x10,%esp
801015c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015da:	89 44 24 04          	mov    %eax,0x4(%esp)
801015de:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801015e1:	89 04 24             	mov    %eax,(%esp)
801015e4:	e8 e7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e9:	8b 53 a8             	mov    -0x58(%ebx),%edx
801015ec:	83 e2 07             	and    $0x7,%edx
801015ef:	c1 e2 06             	shl    $0x6,%edx
801015f2:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f6:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
801015f8:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
801015ff:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101603:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101607:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010160b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010160f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101613:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101617:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010161b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010161e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101621:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101625:	89 14 24             	mov    %edx,(%esp)
80101628:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010162f:	00 
80101630:	e8 db 2c 00 00       	call   80104310 <memmove>
  log_write(bp);
80101635:	89 34 24             	mov    %esi,(%esp)
80101638:	e8 43 16 00 00       	call   80102c80 <log_write>
  brelse(bp);
8010163d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101640:	83 c4 10             	add    $0x10,%esp
80101643:	5b                   	pop    %ebx
80101644:	5e                   	pop    %esi
80101645:	5d                   	pop    %ebp
  brelse(bp);
80101646:	e9 95 eb ff ff       	jmp    801001e0 <brelse>
8010164b:	90                   	nop
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 14             	sub    $0x14,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101661:	e8 4a 2b 00 00       	call   801041b0 <acquire>
  ip->ref++;
80101666:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010166a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101671:	e8 aa 2b 00 00       	call   80104220 <release>
}
80101676:	83 c4 14             	add    $0x14,%esp
80101679:	89 d8                	mov    %ebx,%eax
8010167b:	5b                   	pop    %ebx
8010167c:	5d                   	pop    %ebp
8010167d:	c3                   	ret    
8010167e:	66 90                	xchg   %ax,%ax

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	83 ec 10             	sub    $0x10,%esp
80101688:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010168b:	85 db                	test   %ebx,%ebx
8010168d:	0f 84 b3 00 00 00    	je     80101746 <ilock+0xc6>
80101693:	8b 53 08             	mov    0x8(%ebx),%edx
80101696:	85 d2                	test   %edx,%edx
80101698:	0f 8e a8 00 00 00    	jle    80101746 <ilock+0xc6>
  acquiresleep(&ip->lock);
8010169e:	8d 43 0c             	lea    0xc(%ebx),%eax
801016a1:	89 04 24             	mov    %eax,(%esp)
801016a4:	e8 a7 28 00 00       	call   80103f50 <acquiresleep>
  if(ip->valid == 0){
801016a9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ac:	85 c0                	test   %eax,%eax
801016ae:	74 08                	je     801016b8 <ilock+0x38>
}
801016b0:	83 c4 10             	add    $0x10,%esp
801016b3:	5b                   	pop    %ebx
801016b4:	5e                   	pop    %esi
801016b5:	5d                   	pop    %ebp
801016b6:	c3                   	ret    
801016b7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b8:	8b 43 04             	mov    0x4(%ebx),%eax
801016bb:	c1 e8 03             	shr    $0x3,%eax
801016be:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c8:	8b 03                	mov    (%ebx),%eax
801016ca:	89 04 24             	mov    %eax,(%esp)
801016cd:	e8 fe e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d2:	8b 53 04             	mov    0x4(%ebx),%edx
801016d5:	83 e2 07             	and    $0x7,%edx
801016d8:	c1 e2 06             	shl    $0x6,%edx
801016db:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016df:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
801016e1:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016e4:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
801016e7:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
801016eb:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801016ef:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
801016f3:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
801016f7:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
801016fb:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
801016ff:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101703:	8b 42 fc             	mov    -0x4(%edx),%eax
80101706:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101709:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010170c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101710:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101717:	00 
80101718:	89 04 24             	mov    %eax,(%esp)
8010171b:	e8 f0 2b 00 00       	call   80104310 <memmove>
    brelse(bp);
80101720:	89 34 24             	mov    %esi,(%esp)
80101723:	e8 b8 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 76 ff ff ff    	jne    801016b0 <ilock+0x30>
      panic("ilock: no type");
8010173a:	c7 04 24 10 6e 10 80 	movl   $0x80106e10,(%esp)
80101741:	e8 1a ec ff ff       	call   80100360 <panic>
    panic("ilock");
80101746:	c7 04 24 0a 6e 10 80 	movl   $0x80106e0a,(%esp)
8010174d:	e8 0e ec ff ff       	call   80100360 <panic>
80101752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	83 ec 10             	sub    $0x10,%esp
80101768:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010176b:	85 db                	test   %ebx,%ebx
8010176d:	74 24                	je     80101793 <iunlock+0x33>
8010176f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101772:	89 34 24             	mov    %esi,(%esp)
80101775:	e8 76 28 00 00       	call   80103ff0 <holdingsleep>
8010177a:	85 c0                	test   %eax,%eax
8010177c:	74 15                	je     80101793 <iunlock+0x33>
8010177e:	8b 43 08             	mov    0x8(%ebx),%eax
80101781:	85 c0                	test   %eax,%eax
80101783:	7e 0e                	jle    80101793 <iunlock+0x33>
  releasesleep(&ip->lock);
80101785:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	5b                   	pop    %ebx
8010178c:	5e                   	pop    %esi
8010178d:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178e:	e9 1d 28 00 00       	jmp    80103fb0 <releasesleep>
    panic("iunlock");
80101793:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
8010179a:	e8 c1 eb ff ff       	call   80100360 <panic>
8010179f:	90                   	nop

801017a0 <iput>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 1c             	sub    $0x1c,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	89 3c 24             	mov    %edi,(%esp)
801017b2:	e8 99 27 00 00       	call   80103f50 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ba:	85 d2                	test   %edx,%edx
801017bc:	74 07                	je     801017c5 <iput+0x25>
801017be:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c3:	74 2b                	je     801017f0 <iput+0x50>
  releasesleep(&ip->lock);
801017c5:	89 3c 24             	mov    %edi,(%esp)
801017c8:	e8 e3 27 00 00       	call   80103fb0 <releasesleep>
  acquire(&icache.lock);
801017cd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017d4:	e8 d7 29 00 00       	call   801041b0 <acquire>
  ip->ref--;
801017d9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017dd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017e4:	83 c4 1c             	add    $0x1c,%esp
801017e7:	5b                   	pop    %ebx
801017e8:	5e                   	pop    %esi
801017e9:	5f                   	pop    %edi
801017ea:	5d                   	pop    %ebp
  release(&icache.lock);
801017eb:	e9 30 2a 00 00       	jmp    80104220 <release>
    acquire(&icache.lock);
801017f0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f7:	e8 b4 29 00 00       	call   801041b0 <acquire>
    int r = ip->ref;
801017fc:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101806:	e8 15 2a 00 00       	call   80104220 <release>
    if(r == 1){
8010180b:	83 fb 01             	cmp    $0x1,%ebx
8010180e:	75 b5                	jne    801017c5 <iput+0x25>
80101810:	8d 4e 30             	lea    0x30(%esi),%ecx
80101813:	89 f3                	mov    %esi,%ebx
80101815:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101818:	89 cf                	mov    %ecx,%edi
8010181a:	eb 0b                	jmp    80101827 <iput+0x87>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0xa0>
    if(ip->addrs[i]){
80101827:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010182a:	85 d2                	test   %edx,%edx
8010182c:	74 f2                	je     80101820 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010182e:	8b 06                	mov    (%esi),%eax
80101830:	e8 9b f8 ff ff       	call   801010d0 <bfree>
      ip->addrs[i] = 0;
80101835:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010183c:	eb e2                	jmp    80101820 <iput+0x80>
8010183e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	85 c0                	test   %eax,%eax
8010184b:	75 2b                	jne    80101878 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010184d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101854:	89 34 24             	mov    %esi,(%esp)
80101857:	e8 64 fd ff ff       	call   801015c0 <iupdate>
      ip->type = 0;
8010185c:	31 c0                	xor    %eax,%eax
8010185e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101862:	89 34 24             	mov    %esi,(%esp)
80101865:	e8 56 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010186a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101871:	e9 4f ff ff ff       	jmp    801017c5 <iput+0x25>
80101876:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101878:	89 44 24 04          	mov    %eax,0x4(%esp)
8010187c:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
8010187e:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 48 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101888:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
8010188b:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010188e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101891:	89 cf                	mov    %ecx,%edi
80101893:	31 c0                	xor    %eax,%eax
80101895:	eb 0e                	jmp    801018a5 <iput+0x105>
80101897:	90                   	nop
80101898:	83 c3 01             	add    $0x1,%ebx
8010189b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018a1:	89 d8                	mov    %ebx,%eax
801018a3:	74 10                	je     801018b5 <iput+0x115>
      if(a[j])
801018a5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018a8:	85 d2                	test   %edx,%edx
801018aa:	74 ec                	je     80101898 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ac:	8b 06                	mov    (%esi),%eax
801018ae:	e8 1d f8 ff ff       	call   801010d0 <bfree>
801018b3:	eb e3                	jmp    80101898 <iput+0xf8>
    brelse(bp);
801018b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018bb:	89 04 24             	mov    %eax,(%esp)
801018be:	e8 1d e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018c3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018c9:	8b 06                	mov    (%esi),%eax
801018cb:	e8 00 f8 ff ff       	call   801010d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018d7:	00 00 00 
801018da:	e9 6e ff ff ff       	jmp    8010184d <iput+0xad>
801018df:	90                   	nop

801018e0 <iunlockput>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	53                   	push   %ebx
801018e4:	83 ec 14             	sub    $0x14,%esp
801018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ea:	89 1c 24             	mov    %ebx,(%esp)
801018ed:	e8 6e fe ff ff       	call   80101760 <iunlock>
  iput(ip);
801018f2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801018f5:	83 c4 14             	add    $0x14,%esp
801018f8:	5b                   	pop    %ebx
801018f9:	5d                   	pop    %ebp
  iput(ip);
801018fa:	e9 a1 fe ff ff       	jmp    801017a0 <iput>
801018ff:	90                   	nop

80101900 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	8b 55 08             	mov    0x8(%ebp),%edx
80101906:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101909:	8b 0a                	mov    (%edx),%ecx
8010190b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010190e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101911:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101914:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101918:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010191b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010191f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101923:	8b 52 58             	mov    0x58(%edx),%edx
80101926:	89 50 10             	mov    %edx,0x10(%eax)
}
80101929:	5d                   	pop    %ebp
8010192a:	c3                   	ret    
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 2c             	sub    $0x2c,%esp
80101939:	8b 45 0c             	mov    0xc(%ebp),%eax
8010193c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010193f:	8b 75 10             	mov    0x10(%ebp),%esi
80101942:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101945:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101948:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010194d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101950:	0f 84 aa 00 00 00    	je     80101a00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101956:	8b 47 58             	mov    0x58(%edi),%eax
80101959:	39 f0                	cmp    %esi,%eax
8010195b:	0f 82 c7 00 00 00    	jb     80101a28 <readi+0xf8>
80101961:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101964:	89 da                	mov    %ebx,%edx
80101966:	01 f2                	add    %esi,%edx
80101968:	0f 82 ba 00 00 00    	jb     80101a28 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010196e:	89 c1                	mov    %eax,%ecx
80101970:	29 f1                	sub    %esi,%ecx
80101972:	39 d0                	cmp    %edx,%eax
80101974:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101977:	31 c0                	xor    %eax,%eax
80101979:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
8010197b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010197e:	74 70                	je     801019f0 <readi+0xc0>
80101980:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101983:	89 c7                	mov    %eax,%edi
80101985:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101988:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010198b:	89 f2                	mov    %esi,%edx
8010198d:	c1 ea 09             	shr    $0x9,%edx
80101990:	89 d8                	mov    %ebx,%eax
80101992:	e8 99 f9 ff ff       	call   80101330 <bmap>
80101997:	89 44 24 04          	mov    %eax,0x4(%esp)
8010199b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
8010199d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a2:	89 04 24             	mov    %eax,(%esp)
801019a5:	e8 26 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ad:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019af:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019b1:	89 f0                	mov    %esi,%eax
801019b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019b8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ba:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019be:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019c7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ce:	01 df                	add    %ebx,%edi
801019d0:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801019d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019d5:	89 04 24             	mov    %eax,(%esp)
801019d8:	e8 33 29 00 00       	call   80104310 <memmove>
    brelse(bp);
801019dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019e0:	89 14 24             	mov    %edx,(%esp)
801019e3:	e8 f8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019eb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019ee:	77 98                	ja     80101988 <readi+0x58>
  }
  return n;
801019f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019f3:	83 c4 2c             	add    $0x2c,%esp
801019f6:	5b                   	pop    %ebx
801019f7:	5e                   	pop    %esi
801019f8:	5f                   	pop    %edi
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a00:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a04:	66 83 f8 09          	cmp    $0x9,%ax
80101a08:	77 1e                	ja     80101a28 <readi+0xf8>
80101a0a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	74 13                	je     80101a28 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a15:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a18:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a1b:	83 c4 2c             	add    $0x2c,%esp
80101a1e:	5b                   	pop    %ebx
80101a1f:	5e                   	pop    %esi
80101a20:	5f                   	pop    %edi
80101a21:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a22:	ff e0                	jmp    *%eax
80101a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a2d:	eb c4                	jmp    801019f3 <readi+0xc3>
80101a2f:	90                   	nop

80101a30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 2c             	sub    $0x2c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a4a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a50:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a53:	0f 84 b7 00 00 00    	je     80101b10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a5f:	0f 82 e3 00 00 00    	jb     80101b48 <writei+0x118>
80101a65:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a68:	89 c8                	mov    %ecx,%eax
80101a6a:	01 f0                	add    %esi,%eax
80101a6c:	0f 82 d6 00 00 00    	jb     80101b48 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a72:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a77:	0f 87 cb 00 00 00    	ja     80101b48 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a7d:	85 c9                	test   %ecx,%ecx
80101a7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a86:	74 77                	je     80101aff <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a88:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a8b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a92:	c1 ea 09             	shr    $0x9,%edx
80101a95:	89 f8                	mov    %edi,%eax
80101a97:	e8 94 f8 ff ff       	call   80101330 <bmap>
80101a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101aa0:	8b 07                	mov    (%edi),%eax
80101aa2:	89 04 24             	mov    %eax,(%esp)
80101aa5:	e8 26 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aaa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aad:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ab0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	89 f0                	mov    %esi,%eax
80101ab7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101abc:	29 c3                	sub    %eax,%ebx
80101abe:	39 cb                	cmp    %ecx,%ebx
80101ac0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101acd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ad1:	89 04 24             	mov    %eax,(%esp)
80101ad4:	e8 37 28 00 00       	call   80104310 <memmove>
    log_write(bp);
80101ad9:	89 3c 24             	mov    %edi,(%esp)
80101adc:	e8 9f 11 00 00       	call   80102c80 <log_write>
    brelse(bp);
80101ae1:	89 3c 24             	mov    %edi,(%esp)
80101ae4:	e8 f7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aef:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101af2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101af5:	77 91                	ja     80101a88 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afa:	39 70 58             	cmp    %esi,0x58(%eax)
80101afd:	72 39                	jb     80101b38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b02:	83 c4 2c             	add    $0x2c,%esp
80101b05:	5b                   	pop    %ebx
80101b06:	5e                   	pop    %esi
80101b07:	5f                   	pop    %edi
80101b08:	5d                   	pop    %ebp
80101b09:	c3                   	ret    
80101b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 2e                	ja     80101b48 <writei+0x118>
80101b1a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 23                	je     80101b48 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b25:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b28:	83 c4 2c             	add    $0x2c,%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b2f:	ff e0                	jmp    *%eax
80101b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b38:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b3e:	89 04 24             	mov    %eax,(%esp)
80101b41:	e8 7a fa ff ff       	call   801015c0 <iupdate>
80101b46:	eb b7                	jmp    80101aff <writei+0xcf>
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b50:	5b                   	pop    %ebx
80101b51:	5e                   	pop    %esi
80101b52:	5f                   	pop    %edi
80101b53:	5d                   	pop    %ebp
80101b54:	c3                   	ret    
80101b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b66:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b69:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b70:	00 
80101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	89 04 24             	mov    %eax,(%esp)
80101b7b:	e8 10 28 00 00       	call   80104390 <strncmp>
}
80101b80:	c9                   	leave  
80101b81:	c3                   	ret    
80101b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 2c             	sub    $0x2c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 97 00 00 00    	jne    80101c3e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 73                	jmp    80101c28 <dirlookup+0x98>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 68                	jbe    80101c28 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bc7:	00 
80101bc8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bcc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bd0:	89 1c 24             	mov    %ebx,(%esp)
80101bd3:	e8 58 fd ff ff       	call   80101930 <readi>
80101bd8:	83 f8 10             	cmp    $0x10,%eax
80101bdb:	75 55                	jne    80101c32 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bdd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be2:	74 d4                	je     80101bb8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101be4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101beb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bee:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bf5:	00 
80101bf6:	89 04 24             	mov    %eax,(%esp)
80101bf9:	e8 92 27 00 00       	call   80104390 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101bfe:	85 c0                	test   %eax,%eax
80101c00:	75 b6                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c02:	8b 45 10             	mov    0x10(%ebp),%eax
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 05                	je     80101c0e <dirlookup+0x7e>
        *poff = off;
80101c09:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c0e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c12:	8b 03                	mov    (%ebx),%eax
80101c14:	e8 57 f6 ff ff       	call   80101270 <iget>
    }
  }

  return 0;
}
80101c19:	83 c4 2c             	add    $0x2c,%esp
80101c1c:	5b                   	pop    %ebx
80101c1d:	5e                   	pop    %esi
80101c1e:	5f                   	pop    %edi
80101c1f:	5d                   	pop    %ebp
80101c20:	c3                   	ret    
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c28:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c2b:	31 c0                	xor    %eax,%eax
}
80101c2d:	5b                   	pop    %ebx
80101c2e:	5e                   	pop    %esi
80101c2f:	5f                   	pop    %edi
80101c30:	5d                   	pop    %ebp
80101c31:	c3                   	ret    
      panic("dirlookup read");
80101c32:	c7 04 24 39 6e 10 80 	movl   $0x80106e39,(%esp)
80101c39:	e8 22 e7 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c3e:	c7 04 24 27 6e 10 80 	movl   $0x80106e27,(%esp)
80101c45:	e8 16 e7 ff ff       	call   80100360 <panic>
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	89 cf                	mov    %ecx,%edi
80101c56:	56                   	push   %esi
80101c57:	53                   	push   %ebx
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c63:	0f 84 51 01 00 00    	je     80101dba <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 02 1a 00 00       	call   80103670 <myproc>
80101c6e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c71:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c78:	e8 33 25 00 00       	call   801041b0 <acquire>
  ip->ref++;
80101c7d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c81:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c88:	e8 93 25 00 00       	call   80104220 <release>
80101c8d:	eb 04                	jmp    80101c93 <namex+0x43>
80101c8f:	90                   	nop
    path++;
80101c90:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101c93:	0f b6 03             	movzbl (%ebx),%eax
80101c96:	3c 2f                	cmp    $0x2f,%al
80101c98:	74 f6                	je     80101c90 <namex+0x40>
  if(*path == 0)
80101c9a:	84 c0                	test   %al,%al
80101c9c:	0f 84 ed 00 00 00    	je     80101d8f <namex+0x13f>
  while(*path != '/' && *path != 0)
80101ca2:	0f b6 03             	movzbl (%ebx),%eax
80101ca5:	89 da                	mov    %ebx,%edx
80101ca7:	84 c0                	test   %al,%al
80101ca9:	0f 84 b1 00 00 00    	je     80101d60 <namex+0x110>
80101caf:	3c 2f                	cmp    $0x2f,%al
80101cb1:	75 0f                	jne    80101cc2 <namex+0x72>
80101cb3:	e9 a8 00 00 00       	jmp    80101d60 <namex+0x110>
80101cb8:	3c 2f                	cmp    $0x2f,%al
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cc0:	74 0a                	je     80101ccc <namex+0x7c>
    path++;
80101cc2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cc5:	0f b6 02             	movzbl (%edx),%eax
80101cc8:	84 c0                	test   %al,%al
80101cca:	75 ec                	jne    80101cb8 <namex+0x68>
80101ccc:	89 d1                	mov    %edx,%ecx
80101cce:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cd0:	83 f9 0d             	cmp    $0xd,%ecx
80101cd3:	0f 8e 8f 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cd9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cdd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ce4:	00 
80101ce5:	89 3c 24             	mov    %edi,(%esp)
80101ce8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ceb:	e8 20 26 00 00       	call   80104310 <memmove>
    path++;
80101cf0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cf3:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101cf5:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf8:	75 0e                	jne    80101d08 <namex+0xb8>
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	89 34 24             	mov    %esi,(%esp)
80101d0b:	e8 70 f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d10:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d15:	0f 85 85 00 00 00    	jne    80101da0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d1e:	85 d2                	test   %edx,%edx
80101d20:	74 09                	je     80101d2b <namex+0xdb>
80101d22:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d25:	0f 84 a5 00 00 00    	je     80101dd0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d32:	00 
80101d33:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d37:	89 34 24             	mov    %esi,(%esp)
80101d3a:	e8 51 fe ff ff       	call   80101b90 <dirlookup>
80101d3f:	85 c0                	test   %eax,%eax
80101d41:	74 5d                	je     80101da0 <namex+0x150>
  iunlock(ip);
80101d43:	89 34 24             	mov    %esi,(%esp)
80101d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d49:	e8 12 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	89 c6                	mov    %eax,%esi
80101d5b:	e9 33 ff ff ff       	jmp    80101c93 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d60:	31 c9                	xor    %ecx,%ecx
80101d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d70:	89 3c 24             	mov    %edi,(%esp)
80101d73:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d76:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d79:	e8 92 25 00 00       	call   80104310 <memmove>
    name[len] = 0;
80101d7e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d84:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d88:	89 d3                	mov    %edx,%ebx
80101d8a:	e9 66 ff ff ff       	jmp    80101cf5 <namex+0xa5>
  }
  if(nameiparent){
80101d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d92:	85 c0                	test   %eax,%eax
80101d94:	75 4c                	jne    80101de2 <namex+0x192>
80101d96:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d98:	83 c4 2c             	add    $0x2c,%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
80101d9f:	c3                   	ret    
  iunlock(ip);
80101da0:	89 34 24             	mov    %esi,(%esp)
80101da3:	e8 b8 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101da8:	89 34 24             	mov    %esi,(%esp)
80101dab:	e8 f0 f9 ff ff       	call   801017a0 <iput>
}
80101db0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101db3:	31 c0                	xor    %eax,%eax
}
80101db5:	5b                   	pop    %ebx
80101db6:	5e                   	pop    %esi
80101db7:	5f                   	pop    %edi
80101db8:	5d                   	pop    %ebp
80101db9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dba:	ba 01 00 00 00       	mov    $0x1,%edx
80101dbf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc4:	e8 a7 f4 ff ff       	call   80101270 <iget>
80101dc9:	89 c6                	mov    %eax,%esi
80101dcb:	e9 c3 fe ff ff       	jmp    80101c93 <namex+0x43>
      iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 88 f9 ff ff       	call   80101760 <iunlock>
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101ddb:	89 f0                	mov    %esi,%eax
}
80101ddd:	5b                   	pop    %ebx
80101dde:	5e                   	pop    %esi
80101ddf:	5f                   	pop    %edi
80101de0:	5d                   	pop    %ebp
80101de1:	c3                   	ret    
    iput(ip);
80101de2:	89 34 24             	mov    %esi,(%esp)
80101de5:	e8 b6 f9 ff ff       	call   801017a0 <iput>
    return 0;
80101dea:	31 c0                	xor    %eax,%eax
80101dec:	eb aa                	jmp    80101d98 <namex+0x148>
80101dee:	66 90                	xchg   %ax,%ax

80101df0 <dirlink>:
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 2c             	sub    $0x2c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e06:	00 
80101e07:	89 1c 24             	mov    %ebx,(%esp)
80101e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e0e:	e8 7d fd ff ff       	call   80101b90 <dirlookup>
80101e13:	85 c0                	test   %eax,%eax
80101e15:	0f 85 8b 00 00 00    	jne    80101ea6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e1e:	31 ff                	xor    %edi,%edi
80101e20:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e23:	85 c0                	test   %eax,%eax
80101e25:	75 13                	jne    80101e3a <dirlink+0x4a>
80101e27:	eb 35                	jmp    80101e5e <dirlink+0x6e>
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e30:	8d 57 10             	lea    0x10(%edi),%edx
80101e33:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e36:	89 d7                	mov    %edx,%edi
80101e38:	76 24                	jbe    80101e5e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e3a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e41:	00 
80101e42:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e46:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e4a:	89 1c 24             	mov    %ebx,(%esp)
80101e4d:	e8 de fa ff ff       	call   80101930 <readi>
80101e52:	83 f8 10             	cmp    $0x10,%eax
80101e55:	75 5e                	jne    80101eb5 <dirlink+0xc5>
    if(de.inum == 0)
80101e57:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e5c:	75 d2                	jne    80101e30 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e61:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e68:	00 
80101e69:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e70:	89 04 24             	mov    %eax,(%esp)
80101e73:	e8 88 25 00 00       	call   80104400 <strncpy>
  de.inum = inum;
80101e78:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e82:	00 
80101e83:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e87:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8b:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101e8e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e92:	e8 99 fb ff ff       	call   80101a30 <writei>
80101e97:	83 f8 10             	cmp    $0x10,%eax
80101e9a:	75 25                	jne    80101ec1 <dirlink+0xd1>
  return 0;
80101e9c:	31 c0                	xor    %eax,%eax
}
80101e9e:	83 c4 2c             	add    $0x2c,%esp
80101ea1:	5b                   	pop    %ebx
80101ea2:	5e                   	pop    %esi
80101ea3:	5f                   	pop    %edi
80101ea4:	5d                   	pop    %ebp
80101ea5:	c3                   	ret    
    iput(ip);
80101ea6:	89 04 24             	mov    %eax,(%esp)
80101ea9:	e8 f2 f8 ff ff       	call   801017a0 <iput>
    return -1;
80101eae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb3:	eb e9                	jmp    80101e9e <dirlink+0xae>
      panic("dirlink read");
80101eb5:	c7 04 24 48 6e 10 80 	movl   $0x80106e48,(%esp)
80101ebc:	e8 9f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ec1:	c7 04 24 3e 74 10 80 	movl   $0x8010743e,(%esp)
80101ec8:	e8 93 e4 ff ff       	call   80100360 <panic>
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi

80101ed0 <namei>:

struct inode*
namei(char *path)
{
80101ed0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ed1:	31 d2                	xor    %edx,%edx
{
80101ed3:	89 e5                	mov    %esp,%ebp
80101ed5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80101edb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ede:	e8 6d fd ff ff       	call   80101c50 <namex>
}
80101ee3:	c9                   	leave  
80101ee4:	c3                   	ret    
80101ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ef0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ef1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ef6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101efb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101efe:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101eff:	e9 4c fd ff ff       	jmp    80101c50 <namex>
80101f04:	66 90                	xchg   %ax,%ax
80101f06:	66 90                	xchg   %ax,%ax
80101f08:	66 90                	xchg   %ax,%ax
80101f0a:	66 90                	xchg   %ax,%ax
80101f0c:	66 90                	xchg   %ax,%ax
80101f0e:	66 90                	xchg   %ax,%ax

80101f10 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	56                   	push   %esi
80101f14:	89 c6                	mov    %eax,%esi
80101f16:	53                   	push   %ebx
80101f17:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	0f 84 99 00 00 00    	je     80101fbb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f22:	8b 48 08             	mov    0x8(%eax),%ecx
80101f25:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f2b:	0f 87 7e 00 00 00    	ja     80101faf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f31:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f39:	83 e0 c0             	and    $0xffffffc0,%eax
80101f3c:	3c 40                	cmp    $0x40,%al
80101f3e:	75 f8                	jne    80101f38 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f40:	31 db                	xor    %ebx,%ebx
80101f42:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f47:	89 d8                	mov    %ebx,%eax
80101f49:	ee                   	out    %al,(%dx)
80101f4a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f4f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f54:	ee                   	out    %al,(%dx)
80101f55:	0f b6 c1             	movzbl %cl,%eax
80101f58:	b2 f3                	mov    $0xf3,%dl
80101f5a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f5b:	89 c8                	mov    %ecx,%eax
80101f5d:	b2 f4                	mov    $0xf4,%dl
80101f5f:	c1 f8 08             	sar    $0x8,%eax
80101f62:	ee                   	out    %al,(%dx)
80101f63:	b2 f5                	mov    $0xf5,%dl
80101f65:	89 d8                	mov    %ebx,%eax
80101f67:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f68:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f6c:	b2 f6                	mov    $0xf6,%dl
80101f6e:	83 e0 01             	and    $0x1,%eax
80101f71:	c1 e0 04             	shl    $0x4,%eax
80101f74:	83 c8 e0             	or     $0xffffffe0,%eax
80101f77:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f78:	f6 06 04             	testb  $0x4,(%esi)
80101f7b:	75 13                	jne    80101f90 <idestart+0x80>
80101f7d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f82:	b8 20 00 00 00       	mov    $0x20,%eax
80101f87:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	5b                   	pop    %ebx
80101f8c:	5e                   	pop    %esi
80101f8d:	5d                   	pop    %ebp
80101f8e:	c3                   	ret    
80101f8f:	90                   	nop
80101f90:	b2 f7                	mov    $0xf7,%dl
80101f92:	b8 30 00 00 00       	mov    $0x30,%eax
80101f97:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101f98:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101f9d:	83 c6 5c             	add    $0x5c,%esi
80101fa0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fa5:	fc                   	cld    
80101fa6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
    panic("incorrect blockno");
80101faf:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80101fb6:	e8 a5 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101fbb:	c7 04 24 ab 6e 10 80 	movl   $0x80106eab,(%esp)
80101fc2:	e8 99 e3 ff ff       	call   80100360 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80101fd6:	c7 44 24 04 c6 6e 10 	movl   $0x80106ec6,0x4(%esp)
80101fdd:	80 
80101fde:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101fe5:	e8 56 20 00 00       	call   80104040 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fea:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fef:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101ff6:	83 e8 01             	sub    $0x1,%eax
80101ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ffd:	e8 7e 02 00 00       	call   80102280 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102002:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102007:	90                   	nop
80102008:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102009:	83 e0 c0             	and    $0xffffffc0,%eax
8010200c:	3c 40                	cmp    $0x40,%al
8010200e:	75 f8                	jne    80102008 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102010:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102015:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010201a:	ee                   	out    %al,(%dx)
8010201b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102020:	b2 f7                	mov    $0xf7,%dl
80102022:	eb 09                	jmp    8010202d <ideinit+0x5d>
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102028:	83 e9 01             	sub    $0x1,%ecx
8010202b:	74 0f                	je     8010203c <ideinit+0x6c>
8010202d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010202e:	84 c0                	test   %al,%al
80102030:	74 f6                	je     80102028 <ideinit+0x58>
      havedisk1 = 1;
80102032:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102039:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010203c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102041:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102046:	ee                   	out    %al,(%dx)
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102060:	e8 4b 21 00 00       	call   801041b0 <acquire>

  if((b = idequeue) == 0){
80102065:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010206b:	85 db                	test   %ebx,%ebx
8010206d:	74 30                	je     8010209f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010206f:	8b 43 58             	mov    0x58(%ebx),%eax
80102072:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102077:	8b 33                	mov    (%ebx),%esi
80102079:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010207f:	74 37                	je     801020b8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102081:	83 e6 fb             	and    $0xfffffffb,%esi
80102084:	83 ce 02             	or     $0x2,%esi
80102087:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102089:	89 1c 24             	mov    %ebx,(%esp)
8010208c:	e8 cf 1c 00 00       	call   80103d60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102091:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102096:	85 c0                	test   %eax,%eax
80102098:	74 05                	je     8010209f <ideintr+0x4f>
    idestart(idequeue);
8010209a:	e8 71 fe ff ff       	call   80101f10 <idestart>
    release(&idelock);
8010209f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a6:	e8 75 21 00 00       	call   80104220 <release>

  release(&idelock);
}
801020ab:	83 c4 1c             	add    $0x1c,%esp
801020ae:	5b                   	pop    %ebx
801020af:	5e                   	pop    %esi
801020b0:	5f                   	pop    %edi
801020b1:	5d                   	pop    %ebp
801020b2:	c3                   	ret    
801020b3:	90                   	nop
801020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020bd:	8d 76 00             	lea    0x0(%esi),%esi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c1                	mov    %eax,%ecx
801020c3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020c6:	80 f9 40             	cmp    $0x40,%cl
801020c9:	75 f5                	jne    801020c0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cb:	a8 21                	test   $0x21,%al
801020cd:	75 b2                	jne    80102081 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020cf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020dc:	fc                   	cld    
801020dd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020df:	8b 33                	mov    (%ebx),%esi
801020e1:	eb 9e                	jmp    80102081 <ideintr+0x31>
801020e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 14             	sub    $0x14,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	89 04 24             	mov    %eax,(%esp)
80102100:	e8 eb 1e 00 00       	call   80103ff0 <holdingsleep>
80102105:	85 c0                	test   %eax,%eax
80102107:	0f 84 9e 00 00 00    	je     801021ab <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210d:	8b 03                	mov    (%ebx),%eax
8010210f:	83 e0 06             	and    $0x6,%eax
80102112:	83 f8 02             	cmp    $0x2,%eax
80102115:	0f 84 a8 00 00 00    	je     801021c3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211b:	8b 53 04             	mov    0x4(%ebx),%edx
8010211e:	85 d2                	test   %edx,%edx
80102120:	74 0d                	je     8010212f <iderw+0x3f>
80102122:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102127:	85 c0                	test   %eax,%eax
80102129:	0f 84 88 00 00 00    	je     801021b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010212f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102136:	e8 75 20 00 00       	call   801041b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102140:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102147:	85 c0                	test   %eax,%eax
80102149:	75 07                	jne    80102152 <iderw+0x62>
8010214b:	eb 4e                	jmp    8010219b <iderw+0xab>
8010214d:	8d 76 00             	lea    0x0(%esi),%esi
80102150:	89 d0                	mov    %edx,%eax
80102152:	8b 50 58             	mov    0x58(%eax),%edx
80102155:	85 d2                	test   %edx,%edx
80102157:	75 f7                	jne    80102150 <iderw+0x60>
80102159:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010215c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010215e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102164:	74 3c                	je     801021a2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102166:	8b 03                	mov    (%ebx),%eax
80102168:	83 e0 06             	and    $0x6,%eax
8010216b:	83 f8 02             	cmp    $0x2,%eax
8010216e:	74 1a                	je     8010218a <iderw+0x9a>
    sleep(b, &idelock);
80102170:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102177:	80 
80102178:	89 1c 24             	mov    %ebx,(%esp)
8010217b:	e8 50 1a 00 00       	call   80103bd0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102180:	8b 13                	mov    (%ebx),%edx
80102182:	83 e2 06             	and    $0x6,%edx
80102185:	83 fa 02             	cmp    $0x2,%edx
80102188:	75 e6                	jne    80102170 <iderw+0x80>
  }


  release(&idelock);
8010218a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102191:	83 c4 14             	add    $0x14,%esp
80102194:	5b                   	pop    %ebx
80102195:	5d                   	pop    %ebp
  release(&idelock);
80102196:	e9 85 20 00 00       	jmp    80104220 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021a0:	eb ba                	jmp    8010215c <iderw+0x6c>
    idestart(b);
801021a2:	89 d8                	mov    %ebx,%eax
801021a4:	e8 67 fd ff ff       	call   80101f10 <idestart>
801021a9:	eb bb                	jmp    80102166 <iderw+0x76>
    panic("iderw: buf not locked");
801021ab:	c7 04 24 ca 6e 10 80 	movl   $0x80106eca,(%esp)
801021b2:	e8 a9 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021b7:	c7 04 24 f5 6e 10 80 	movl   $0x80106ef5,(%esp)
801021be:	e8 9d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021c3:	c7 04 24 e0 6e 10 80 	movl   $0x80106ee0,(%esp)
801021ca:	e8 91 e1 ff ff       	call   80100360 <panic>
801021cf:	90                   	nop

801021d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx
801021d5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021d8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021df:	00 c0 fe 
  ioapic->reg = reg;
801021e2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021e9:	00 00 00 
  return ioapic->data;
801021ec:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021f2:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
801021f5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021fb:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102201:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102208:	c1 e8 10             	shr    $0x10,%eax
8010220b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010220e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102211:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102214:	39 c2                	cmp    %eax,%edx
80102216:	74 12                	je     8010222a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102218:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
8010221f:	e8 2c e4 ff ff       	call   80100650 <cprintf>
80102224:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010222a:	ba 10 00 00 00       	mov    $0x10,%edx
8010222f:	31 c0                	xor    %eax,%eax
80102231:	eb 07                	jmp    8010223a <ioapicinit+0x6a>
80102233:	90                   	nop
80102234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102238:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010223a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010223c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102242:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102245:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010224b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010224e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102251:	8d 4a 01             	lea    0x1(%edx),%ecx
80102254:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102257:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102259:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010225f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102261:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102268:	7d ce                	jge    80102238 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010226a:	83 c4 10             	add    $0x10,%esp
8010226d:	5b                   	pop    %ebx
8010226e:	5e                   	pop    %esi
8010226f:	5d                   	pop    %ebp
80102270:	c3                   	ret    
80102271:	eb 0d                	jmp    80102280 <ioapicenable>
80102273:	90                   	nop
80102274:	90                   	nop
80102275:	90                   	nop
80102276:	90                   	nop
80102277:	90                   	nop
80102278:	90                   	nop
80102279:	90                   	nop
8010227a:	90                   	nop
8010227b:	90                   	nop
8010227c:	90                   	nop
8010227d:	90                   	nop
8010227e:	90                   	nop
8010227f:	90                   	nop

80102280 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	8b 55 08             	mov    0x8(%ebp),%edx
80102286:	53                   	push   %ebx
80102287:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010228a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010228d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
80102291:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102297:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
8010229a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010229c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022a2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022a5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022a8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022aa:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022b0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022b3:	5b                   	pop    %ebx
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret    
801022b6:	66 90                	xchg   %ax,%ax
801022b8:	66 90                	xchg   %ax,%ax
801022ba:	66 90                	xchg   %ax,%ax
801022bc:	66 90                	xchg   %ax,%ax
801022be:	66 90                	xchg   %ax,%ax

801022c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 14             	sub    $0x14,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022d0:	75 7c                	jne    8010234e <kfree+0x8e>
801022d2:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
801022d8:	72 74                	jb     8010234e <kfree+0x8e>
801022da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022e5:	77 67                	ja     8010234e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801022ee:	00 
801022ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022f6:	00 
801022f7:	89 1c 24             	mov    %ebx,(%esp)
801022fa:	e8 71 1f 00 00       	call   80104270 <memset>

  if(kmem.use_lock)
801022ff:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102305:	85 d2                	test   %edx,%edx
80102307:	75 37                	jne    80102340 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102309:	a1 78 26 11 80       	mov    0x80112678,%eax
8010230e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102310:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102315:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010231b:	85 c0                	test   %eax,%eax
8010231d:	75 09                	jne    80102328 <kfree+0x68>
    release(&kmem.lock);
}
8010231f:	83 c4 14             	add    $0x14,%esp
80102322:	5b                   	pop    %ebx
80102323:	5d                   	pop    %ebp
80102324:	c3                   	ret    
80102325:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102328:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010232f:	83 c4 14             	add    $0x14,%esp
80102332:	5b                   	pop    %ebx
80102333:	5d                   	pop    %ebp
    release(&kmem.lock);
80102334:	e9 e7 1e 00 00       	jmp    80104220 <release>
80102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102340:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102347:	e8 64 1e 00 00       	call   801041b0 <acquire>
8010234c:	eb bb                	jmp    80102309 <kfree+0x49>
    panic("kfree");
8010234e:	c7 04 24 46 6f 10 80 	movl   $0x80106f46,(%esp)
80102355:	e8 06 e0 ff ff       	call   80100360 <panic>
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102360 <freerange>:
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
80102365:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102368:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010236b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010236e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102374:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010237a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102380:	39 de                	cmp    %ebx,%esi
80102382:	73 08                	jae    8010238c <freerange+0x2c>
80102384:	eb 18                	jmp    8010239e <freerange+0x3e>
80102386:	66 90                	xchg   %ax,%ax
80102388:	89 da                	mov    %ebx,%edx
8010238a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010238c:	89 14 24             	mov    %edx,(%esp)
8010238f:	e8 2c ff ff ff       	call   801022c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102394:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010239a:	39 f0                	cmp    %esi,%eax
8010239c:	76 ea                	jbe    80102388 <freerange+0x28>
}
8010239e:	83 c4 10             	add    $0x10,%esp
801023a1:	5b                   	pop    %ebx
801023a2:	5e                   	pop    %esi
801023a3:	5d                   	pop    %ebp
801023a4:	c3                   	ret    
801023a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023b0 <kinit1>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	83 ec 10             	sub    $0x10,%esp
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023bb:	c7 44 24 04 4c 6f 10 	movl   $0x80106f4c,0x4(%esp)
801023c2:	80 
801023c3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ca:	e8 71 1c 00 00       	call   80104040 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801023d2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023d9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801023dc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023e2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023ee:	39 de                	cmp    %ebx,%esi
801023f0:	73 0a                	jae    801023fc <kinit1+0x4c>
801023f2:	eb 1a                	jmp    8010240e <kinit1+0x5e>
801023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f8:	89 da                	mov    %ebx,%edx
801023fa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023fc:	89 14 24             	mov    %edx,(%esp)
801023ff:	e8 bc fe ff ff       	call   801022c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102404:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010240a:	39 c6                	cmp    %eax,%esi
8010240c:	73 ea                	jae    801023f8 <kinit1+0x48>
}
8010240e:	83 c4 10             	add    $0x10,%esp
80102411:	5b                   	pop    %ebx
80102412:	5e                   	pop    %esi
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
80102415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102428:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010242b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010242e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102434:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102440:	39 de                	cmp    %ebx,%esi
80102442:	73 08                	jae    8010244c <kinit2+0x2c>
80102444:	eb 18                	jmp    8010245e <kinit2+0x3e>
80102446:	66 90                	xchg   %ax,%ax
80102448:	89 da                	mov    %ebx,%edx
8010244a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010244c:	89 14 24             	mov    %edx,(%esp)
8010244f:	e8 6c fe ff ff       	call   801022c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102454:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010245a:	39 c6                	cmp    %eax,%esi
8010245c:	73 ea                	jae    80102448 <kinit2+0x28>
  kmem.use_lock = 1;
8010245e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102465:	00 00 00 
}
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	5b                   	pop    %ebx
8010246c:	5e                   	pop    %esi
8010246d:	5d                   	pop    %ebp
8010246e:	c3                   	ret    
8010246f:	90                   	nop

80102470 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
80102474:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102477:	a1 74 26 11 80       	mov    0x80112674,%eax
8010247c:	85 c0                	test   %eax,%eax
8010247e:	75 30                	jne    801024b0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102480:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102486:	85 db                	test   %ebx,%ebx
80102488:	74 08                	je     80102492 <kalloc+0x22>
    kmem.freelist = r->next;
8010248a:	8b 13                	mov    (%ebx),%edx
8010248c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102492:	85 c0                	test   %eax,%eax
80102494:	74 0c                	je     801024a2 <kalloc+0x32>
    release(&kmem.lock);
80102496:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010249d:	e8 7e 1d 00 00       	call   80104220 <release>
  return (char*)r;
}
801024a2:	83 c4 14             	add    $0x14,%esp
801024a5:	89 d8                	mov    %ebx,%eax
801024a7:	5b                   	pop    %ebx
801024a8:	5d                   	pop    %ebp
801024a9:	c3                   	ret    
801024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024b0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024b7:	e8 f4 1c 00 00       	call   801041b0 <acquire>
801024bc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024c1:	eb bd                	jmp    80102480 <kalloc+0x10>
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024d0:	ba 64 00 00 00       	mov    $0x64,%edx
801024d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024d6:	a8 01                	test   $0x1,%al
801024d8:	0f 84 ba 00 00 00    	je     80102598 <kbdgetc+0xc8>
801024de:	b2 60                	mov    $0x60,%dl
801024e0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024e1:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801024e4:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
801024ea:	0f 84 88 00 00 00    	je     80102578 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024f0:	84 c0                	test   %al,%al
801024f2:	79 2c                	jns    80102520 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024f4:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
801024fa:	f6 c2 40             	test   $0x40,%dl
801024fd:	75 05                	jne    80102504 <kbdgetc+0x34>
801024ff:	89 c1                	mov    %eax,%ecx
80102501:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102504:	0f b6 81 80 70 10 80 	movzbl -0x7fef8f80(%ecx),%eax
8010250b:	83 c8 40             	or     $0x40,%eax
8010250e:	0f b6 c0             	movzbl %al,%eax
80102511:	f7 d0                	not    %eax
80102513:	21 d0                	and    %edx,%eax
80102515:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010251a:	31 c0                	xor    %eax,%eax
8010251c:	c3                   	ret    
8010251d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010252a:	f6 c3 40             	test   $0x40,%bl
8010252d:	74 09                	je     80102538 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010252f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102532:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102535:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102538:	0f b6 91 80 70 10 80 	movzbl -0x7fef8f80(%ecx),%edx
  shift ^= togglecode[data];
8010253f:	0f b6 81 80 6f 10 80 	movzbl -0x7fef9080(%ecx),%eax
  shift |= shiftcode[data];
80102546:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102548:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010254a:	89 d0                	mov    %edx,%eax
8010254c:	83 e0 03             	and    $0x3,%eax
8010254f:	8b 04 85 60 6f 10 80 	mov    -0x7fef90a0(,%eax,4),%eax
  shift ^= togglecode[data];
80102556:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010255c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010255f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102563:	74 0b                	je     80102570 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102565:	8d 50 9f             	lea    -0x61(%eax),%edx
80102568:	83 fa 19             	cmp    $0x19,%edx
8010256b:	77 1b                	ja     80102588 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010256d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102570:	5b                   	pop    %ebx
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret    
80102573:	90                   	nop
80102574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102578:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010257f:	31 c0                	xor    %eax,%eax
80102581:	c3                   	ret    
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102588:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010258b:	8d 50 20             	lea    0x20(%eax),%edx
8010258e:	83 f9 19             	cmp    $0x19,%ecx
80102591:	0f 46 c2             	cmovbe %edx,%eax
  return c;
80102594:	eb da                	jmp    80102570 <kbdgetc+0xa0>
80102596:	66 90                	xchg   %ax,%ax
    return -1;
80102598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <kbdintr>:

void
kbdintr(void)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025a6:	c7 04 24 d0 24 10 80 	movl   $0x801024d0,(%esp)
801025ad:	e8 fe e1 ff ff       	call   801007b0 <consoleintr>
}
801025b2:	c9                   	leave  
801025b3:	c3                   	ret    
801025b4:	66 90                	xchg   %ax,%ax
801025b6:	66 90                	xchg   %ax,%ax
801025b8:	66 90                	xchg   %ax,%ax
801025ba:	66 90                	xchg   %ax,%ax
801025bc:	66 90                	xchg   %ax,%ax
801025be:	66 90                	xchg   %ax,%ax

801025c0 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801025c0:	55                   	push   %ebp
801025c1:	89 c1                	mov    %eax,%ecx
801025c3:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ca:	53                   	push   %ebx
801025cb:	31 c0                	xor    %eax,%eax
801025cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ce:	bb 71 00 00 00       	mov    $0x71,%ebx
801025d3:	89 da                	mov    %ebx,%edx
801025d5:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801025d6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d9:	b2 70                	mov    $0x70,%dl
801025db:	89 01                	mov    %eax,(%ecx)
801025dd:	b8 02 00 00 00       	mov    $0x2,%eax
801025e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e3:	89 da                	mov    %ebx,%edx
801025e5:	ec                   	in     (%dx),%al
801025e6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e9:	b2 70                	mov    $0x70,%dl
801025eb:	89 41 04             	mov    %eax,0x4(%ecx)
801025ee:	b8 04 00 00 00       	mov    $0x4,%eax
801025f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f4:	89 da                	mov    %ebx,%edx
801025f6:	ec                   	in     (%dx),%al
801025f7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025fa:	b2 70                	mov    $0x70,%dl
801025fc:	89 41 08             	mov    %eax,0x8(%ecx)
801025ff:	b8 07 00 00 00       	mov    $0x7,%eax
80102604:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102605:	89 da                	mov    %ebx,%edx
80102607:	ec                   	in     (%dx),%al
80102608:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010260b:	b2 70                	mov    $0x70,%dl
8010260d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102610:	b8 08 00 00 00       	mov    $0x8,%eax
80102615:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102616:	89 da                	mov    %ebx,%edx
80102618:	ec                   	in     (%dx),%al
80102619:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261c:	b2 70                	mov    $0x70,%dl
8010261e:	89 41 10             	mov    %eax,0x10(%ecx)
80102621:	b8 09 00 00 00       	mov    $0x9,%eax
80102626:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102627:	89 da                	mov    %ebx,%edx
80102629:	ec                   	in     (%dx),%al
8010262a:	0f b6 d8             	movzbl %al,%ebx
8010262d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102630:	5b                   	pop    %ebx
80102631:	5d                   	pop    %ebp
80102632:	c3                   	ret    
80102633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <lapicinit>:
  if(!lapic)
80102640:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c0 00 00 00    	je     80102710 <lapicinit+0xd0>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 6f                	ja     80102718 <lapicinit+0xd8>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
801026f8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026fe:	80 e6 10             	and    $0x10,%dh
80102701:	75 f5                	jne    801026f8 <lapicinit+0xb8>
  lapic[index] = value;
80102703:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102710:	5d                   	pop    %ebp
80102711:	c3                   	ret    
80102712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102718:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010271f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102722:	8b 50 20             	mov    0x20(%eax),%edx
80102725:	eb 82                	jmp    801026a9 <lapicinit+0x69>
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:
  if (!lapic)
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102738:	85 c0                	test   %eax,%eax
8010273a:	74 0c                	je     80102748 <lapicid+0x18>
  return lapic[ID] >> 24;
8010273c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010273f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102740:	c1 e8 18             	shr    $0x18,%eax
}
80102743:	c3                   	ret    
80102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102748:	31 c0                	xor    %eax,%eax
}
8010274a:	5d                   	pop    %ebp
8010274b:	c3                   	ret    
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <lapiceoi>:
  if(lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	ba 70 00 00 00       	mov    $0x70,%edx
80102786:	89 e5                	mov    %esp,%ebp
80102788:	b8 0f 00 00 00       	mov    $0xf,%eax
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	b2 71                	mov    $0x71,%dl
8010279c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010279d:	31 c0                	xor    %eax,%eax
8010279f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027a5:	89 d8                	mov    %ebx,%eax
801027a7:	c1 e8 04             	shr    $0x4,%eax
801027aa:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027b5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027bb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027cb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027d8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027de:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e7:	89 da                	mov    %ebx,%edx
801027e9:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
801027ec:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
801027fe:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 40 20             	mov    0x20(%eax),%eax
}
80102807:	5b                   	pop    %ebx
80102808:	5d                   	pop    %ebp
80102809:	c3                   	ret    
8010280a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102810 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	ba 70 00 00 00       	mov    $0x70,%edx
80102816:	89 e5                	mov    %esp,%ebp
80102818:	b8 0b 00 00 00       	mov    $0xb,%eax
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	b2 71                	mov    $0x71,%dl
80102826:	ec                   	in     (%dx),%al
80102827:	88 45 b7             	mov    %al,-0x49(%ebp)
8010282a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010282d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102831:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102838:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010283d:	89 d8                	mov    %ebx,%eax
8010283f:	e8 7c fd ff ff       	call   801025c0 <fill_rtcdate>
80102844:	b8 0a 00 00 00       	mov    $0xa,%eax
80102849:	89 f2                	mov    %esi,%edx
8010284b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284c:	ba 71 00 00 00       	mov    $0x71,%edx
80102851:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102852:	84 c0                	test   %al,%al
80102854:	78 e7                	js     8010283d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102856:	89 f8                	mov    %edi,%eax
80102858:	e8 63 fd ff ff       	call   801025c0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010285d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102864:	00 
80102865:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102869:	89 1c 24             	mov    %ebx,(%esp)
8010286c:	e8 4f 1a 00 00       	call   801042c0 <memcmp>
80102871:	85 c0                	test   %eax,%eax
80102873:	75 c3                	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102875:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102879:	75 78                	jne    801028f3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010287b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010287e:	89 c2                	mov    %eax,%edx
80102880:	83 e0 0f             	and    $0xf,%eax
80102883:	c1 ea 04             	shr    $0x4,%edx
80102886:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102889:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010288c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010288f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102892:	89 c2                	mov    %eax,%edx
80102894:	83 e0 0f             	and    $0xf,%eax
80102897:	c1 ea 04             	shr    $0x4,%edx
8010289a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010289d:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028a6:	89 c2                	mov    %eax,%edx
801028a8:	83 e0 0f             	and    $0xf,%eax
801028ab:	c1 ea 04             	shr    $0x4,%edx
801028ae:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ba:	89 c2                	mov    %eax,%edx
801028bc:	83 e0 0f             	and    $0xf,%eax
801028bf:	c1 ea 04             	shr    $0x4,%edx
801028c2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ce:	89 c2                	mov    %eax,%edx
801028d0:	83 e0 0f             	and    $0xf,%eax
801028d3:	c1 ea 04             	shr    $0x4,%edx
801028d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028df:	8b 45 cc             	mov    -0x34(%ebp),%eax
801028e2:	89 c2                	mov    %eax,%edx
801028e4:	83 e0 0f             	and    $0xf,%eax
801028e7:	c1 ea 04             	shr    $0x4,%edx
801028ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ed:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801028f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028f9:	89 01                	mov    %eax,(%ecx)
801028fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028fe:	89 41 04             	mov    %eax,0x4(%ecx)
80102901:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102904:	89 41 08             	mov    %eax,0x8(%ecx)
80102907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010290a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010290d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102910:	89 41 10             	mov    %eax,0x10(%ecx)
80102913:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102916:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102919:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102920:	83 c4 4c             	add    $0x4c,%esp
80102923:	5b                   	pop    %ebx
80102924:	5e                   	pop    %esi
80102925:	5f                   	pop    %edi
80102926:	5d                   	pop    %ebp
80102927:	c3                   	ret    
80102928:	66 90                	xchg   %ax,%ax
8010292a:	66 90                	xchg   %ax,%ax
8010292c:	66 90                	xchg   %ax,%ax
8010292e:	66 90                	xchg   %ax,%ax

80102930 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	57                   	push   %edi
80102934:	56                   	push   %esi
80102935:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102936:	31 db                	xor    %ebx,%ebx
{
80102938:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010293b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102940:	85 c0                	test   %eax,%eax
80102942:	7e 78                	jle    801029bc <install_trans+0x8c>
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102948:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010294d:	01 d8                	add    %ebx,%eax
8010294f:	83 c0 01             	add    $0x1,%eax
80102952:	89 44 24 04          	mov    %eax,0x4(%esp)
80102956:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010295b:	89 04 24             	mov    %eax,(%esp)
8010295e:	e8 6d d7 ff ff       	call   801000d0 <bread>
80102963:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102965:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
8010296c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010296f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102973:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102978:	89 04 24             	mov    %eax,(%esp)
8010297b:	e8 50 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102980:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102987:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102988:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010298a:	8d 47 5c             	lea    0x5c(%edi),%eax
8010298d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102991:	8d 46 5c             	lea    0x5c(%esi),%eax
80102994:	89 04 24             	mov    %eax,(%esp)
80102997:	e8 74 19 00 00       	call   80104310 <memmove>
    bwrite(dbuf);  // write dst to disk
8010299c:	89 34 24             	mov    %esi,(%esp)
8010299f:	e8 fc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029a4:	89 3c 24             	mov    %edi,(%esp)
801029a7:	e8 34 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ac:	89 34 24             	mov    %esi,(%esp)
801029af:	e8 2c d8 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029b4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029ba:	7f 8c                	jg     80102948 <install_trans+0x18>
  }
}
801029bc:	83 c4 1c             	add    $0x1c,%esp
801029bf:	5b                   	pop    %ebx
801029c0:	5e                   	pop    %esi
801029c1:	5f                   	pop    %edi
801029c2:	5d                   	pop    %ebp
801029c3:	c3                   	ret    
801029c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
801029d6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029d9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029de:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029e7:	89 04 24             	mov    %eax,(%esp)
801029ea:	e8 e1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801029ef:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801029f5:	31 d2                	xor    %edx,%edx
801029f7:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
801029f9:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
801029fb:	89 58 5c             	mov    %ebx,0x5c(%eax)
801029fe:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a01:	7e 17                	jle    80102a1a <write_head+0x4a>
80102a03:	90                   	nop
80102a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a08:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a0f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a13:	83 c2 01             	add    $0x1,%edx
80102a16:	39 da                	cmp    %ebx,%edx
80102a18:	75 ee                	jne    80102a08 <write_head+0x38>
  }
  bwrite(buf);
80102a1a:	89 3c 24             	mov    %edi,(%esp)
80102a1d:	e8 7e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a22:	89 3c 24             	mov    %edi,(%esp)
80102a25:	e8 b6 d7 ff ff       	call   801001e0 <brelse>
}
80102a2a:	83 c4 1c             	add    $0x1c,%esp
80102a2d:	5b                   	pop    %ebx
80102a2e:	5e                   	pop    %esi
80102a2f:	5f                   	pop    %edi
80102a30:	5d                   	pop    %ebp
80102a31:	c3                   	ret    
80102a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <initlog>:
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	56                   	push   %esi
80102a44:	53                   	push   %ebx
80102a45:	83 ec 30             	sub    $0x30,%esp
80102a48:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a4b:	c7 44 24 04 80 71 10 	movl   $0x80107180,0x4(%esp)
80102a52:	80 
80102a53:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a5a:	e8 e1 15 00 00       	call   80104040 <initlock>
  readsb(dev, &sb);
80102a5f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a62:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a66:	89 1c 24             	mov    %ebx,(%esp)
80102a69:	e8 82 e9 ff ff       	call   801013f0 <readsb>
  log.start = sb.logstart;
80102a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102a74:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102a77:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102a81:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102a87:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102a8c:	e8 3f d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102a91:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102a93:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102a96:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a99:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102a9b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102aa1:	7e 17                	jle    80102aba <initlog+0x7a>
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102aa8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aac:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ab3:	83 c2 01             	add    $0x1,%edx
80102ab6:	39 da                	cmp    %ebx,%edx
80102ab8:	75 ee                	jne    80102aa8 <initlog+0x68>
  brelse(buf);
80102aba:	89 04 24             	mov    %eax,(%esp)
80102abd:	e8 1e d7 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ac2:	e8 69 fe ff ff       	call   80102930 <install_trans>
  log.lh.n = 0;
80102ac7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ace:	00 00 00 
  write_head(); // clear the log
80102ad1:	e8 fa fe ff ff       	call   801029d0 <write_head>
}
80102ad6:	83 c4 30             	add    $0x30,%esp
80102ad9:	5b                   	pop    %ebx
80102ada:	5e                   	pop    %esi
80102adb:	5d                   	pop    %ebp
80102adc:	c3                   	ret    
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102ae6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aed:	e8 be 16 00 00       	call   801041b0 <acquire>
80102af2:	eb 18                	jmp    80102b0c <begin_op+0x2c>
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102af8:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102aff:	80 
80102b00:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b07:	e8 c4 10 00 00       	call   80103bd0 <sleep>
    if(log.committing){
80102b0c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b11:	85 c0                	test   %eax,%eax
80102b13:	75 e3                	jne    80102af8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b15:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b1a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b20:	83 c0 01             	add    $0x1,%eax
80102b23:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b26:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b29:	83 fa 1e             	cmp    $0x1e,%edx
80102b2c:	7f ca                	jg     80102af8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b2e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b35:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b3a:	e8 e1 16 00 00       	call   80104220 <release>
      break;
    }
  }
}
80102b3f:	c9                   	leave  
80102b40:	c3                   	ret    
80102b41:	eb 0d                	jmp    80102b50 <end_op>
80102b43:	90                   	nop
80102b44:	90                   	nop
80102b45:	90                   	nop
80102b46:	90                   	nop
80102b47:	90                   	nop
80102b48:	90                   	nop
80102b49:	90                   	nop
80102b4a:	90                   	nop
80102b4b:	90                   	nop
80102b4c:	90                   	nop
80102b4d:	90                   	nop
80102b4e:	90                   	nop
80102b4f:	90                   	nop

80102b50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	57                   	push   %edi
80102b54:	56                   	push   %esi
80102b55:	53                   	push   %ebx
80102b56:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b59:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b60:	e8 4b 16 00 00       	call   801041b0 <acquire>
  log.outstanding -= 1;
80102b65:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b6a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102b70:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b73:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b7a:	0f 85 f3 00 00 00    	jne    80102c73 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102b80:	85 c0                	test   %eax,%eax
80102b82:	0f 85 cb 00 00 00    	jne    80102c53 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b88:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b8f:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102b91:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102b98:	00 00 00 
  release(&log.lock);
80102b9b:	e8 80 16 00 00       	call   80104220 <release>
  if (log.lh.n > 0) {
80102ba0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	0f 8e 90 00 00 00    	jle    80102c3d <end_op+0xed>
80102bad:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bb0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bb5:	01 d8                	add    %ebx,%eax
80102bb7:	83 c0 01             	add    $0x1,%eax
80102bba:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bbe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bc3:	89 04 24             	mov    %eax,(%esp)
80102bc6:	e8 05 d5 ff ff       	call   801000d0 <bread>
80102bcb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bcd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd4:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bdb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102be0:	89 04 24             	mov    %eax,(%esp)
80102be3:	e8 e8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102be8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102bef:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bf0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102bf2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bf9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfc:	89 04 24             	mov    %eax,(%esp)
80102bff:	e8 0c 17 00 00       	call   80104310 <memmove>
    bwrite(to);  // write the log
80102c04:	89 34 24             	mov    %esi,(%esp)
80102c07:	e8 94 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c0c:	89 3c 24             	mov    %edi,(%esp)
80102c0f:	e8 cc d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c14:	89 34 24             	mov    %esi,(%esp)
80102c17:	e8 c4 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c22:	7c 8c                	jl     80102bb0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c24:	e8 a7 fd ff ff       	call   801029d0 <write_head>
    install_trans(); // Now install writes to home locations
80102c29:	e8 02 fd ff ff       	call   80102930 <install_trans>
    log.lh.n = 0;
80102c2e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c35:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c38:	e8 93 fd ff ff       	call   801029d0 <write_head>
    acquire(&log.lock);
80102c3d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c44:	e8 67 15 00 00       	call   801041b0 <acquire>
    log.committing = 0;
80102c49:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c50:	00 00 00 
    wakeup(&log);
80102c53:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c5a:	e8 01 11 00 00       	call   80103d60 <wakeup>
    release(&log.lock);
80102c5f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c66:	e8 b5 15 00 00       	call   80104220 <release>
}
80102c6b:	83 c4 1c             	add    $0x1c,%esp
80102c6e:	5b                   	pop    %ebx
80102c6f:	5e                   	pop    %esi
80102c70:	5f                   	pop    %edi
80102c71:	5d                   	pop    %ebp
80102c72:	c3                   	ret    
    panic("log.committing");
80102c73:	c7 04 24 84 71 10 80 	movl   $0x80107184,(%esp)
80102c7a:	e8 e1 d6 ff ff       	call   80100360 <panic>
80102c7f:	90                   	nop

80102c80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c87:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c8f:	83 f8 1d             	cmp    $0x1d,%eax
80102c92:	0f 8f 98 00 00 00    	jg     80102d30 <log_write+0xb0>
80102c98:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102c9e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ca1:	39 d0                	cmp    %edx,%eax
80102ca3:	0f 8d 87 00 00 00    	jge    80102d30 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ca9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cae:	85 c0                	test   %eax,%eax
80102cb0:	0f 8e 86 00 00 00    	jle    80102d3c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cb6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cbd:	e8 ee 14 00 00       	call   801041b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cc2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cc8:	83 fa 00             	cmp    $0x0,%edx
80102ccb:	7e 54                	jle    80102d21 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ccd:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cd0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cd2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cd8:	75 0f                	jne    80102ce9 <log_write+0x69>
80102cda:	eb 3c                	jmp    80102d18 <log_write+0x98>
80102cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ce0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ce7:	74 2f                	je     80102d18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c0 01             	add    $0x1,%eax
80102cec:	39 d0                	cmp    %edx,%eax
80102cee:	75 f0                	jne    80102ce0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102cf0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102cf7:	83 c2 01             	add    $0x1,%edx
80102cfa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d00:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d03:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d0a:	83 c4 14             	add    $0x14,%esp
80102d0d:	5b                   	pop    %ebx
80102d0e:	5d                   	pop    %ebp
  release(&log.lock);
80102d0f:	e9 0c 15 00 00       	jmp    80104220 <release>
80102d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d18:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d1f:	eb df                	jmp    80102d00 <log_write+0x80>
80102d21:	8b 43 08             	mov    0x8(%ebx),%eax
80102d24:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d29:	75 d5                	jne    80102d00 <log_write+0x80>
80102d2b:	eb ca                	jmp    80102cf7 <log_write+0x77>
80102d2d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d30:	c7 04 24 93 71 10 80 	movl   $0x80107193,(%esp)
80102d37:	e8 24 d6 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d3c:	c7 04 24 a9 71 10 80 	movl   $0x801071a9,(%esp)
80102d43:	e8 18 d6 ff ff       	call   80100360 <panic>
80102d48:	66 90                	xchg   %ax,%ax
80102d4a:	66 90                	xchg   %ax,%ax
80102d4c:	66 90                	xchg   %ax,%ax
80102d4e:	66 90                	xchg   %ax,%ax

80102d50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d57:	e8 f4 08 00 00       	call   80103650 <cpuid>
80102d5c:	89 c3                	mov    %eax,%ebx
80102d5e:	e8 ed 08 00 00       	call   80103650 <cpuid>
80102d63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d67:	c7 04 24 c4 71 10 80 	movl   $0x801071c4,(%esp)
80102d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d72:	e8 d9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d77:	e8 c4 26 00 00       	call   80105440 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d7c:	e8 4f 08 00 00       	call   801035d0 <mycpu>
80102d81:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102d83:	b8 01 00 00 00       	mov    $0x1,%eax
80102d88:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d8f:	e8 9c 0b 00 00       	call   80103930 <scheduler>
80102d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102da0 <mpenter>:
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102da6:	e8 d5 37 00 00       	call   80106580 <switchkvm>
  seginit();
80102dab:	e8 10 37 00 00       	call   801064c0 <seginit>
  lapicinit();
80102db0:	e8 8b f8 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102db5:	e8 96 ff ff ff       	call   80102d50 <mpmain>
80102dba:	66 90                	xchg   %ax,%ax
80102dbc:	66 90                	xchg   %ax,%ax
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <main>:
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102dc4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102dc9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dcc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102dcf:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102dd6:	80 
80102dd7:	c7 04 24 a8 55 11 80 	movl   $0x801155a8,(%esp)
80102dde:	e8 cd f5 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102de3:	e8 28 3c 00 00       	call   80106a10 <kvmalloc>
  mpinit();        // detect other processors
80102de8:	e8 73 01 00 00       	call   80102f60 <mpinit>
80102ded:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102df0:	e8 4b f8 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102df5:	e8 c6 36 00 00       	call   801064c0 <seginit>
  picinit();       // disable pic
80102dfa:	e8 21 03 00 00       	call   80103120 <picinit>
80102dff:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e00:	e8 cb f3 ff ff       	call   801021d0 <ioapicinit>
  consoleinit();   // console hardware
80102e05:	e8 46 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e0a:	e8 d1 29 00 00       	call   801057e0 <uartinit>
80102e0f:	90                   	nop
  pinit();         // process table
80102e10:	e8 9b 07 00 00       	call   801035b0 <pinit>
  tvinit();        // trap vectors
80102e15:	e8 86 25 00 00       	call   801053a0 <tvinit>
  binit();         // buffer cache
80102e1a:	e8 21 d2 ff ff       	call   80100040 <binit>
80102e1f:	90                   	nop
  fileinit();      // file table
80102e20:	e8 fb de ff ff       	call   80100d20 <fileinit>
  ideinit();       // disk 
80102e25:	e8 a6 f1 ff ff       	call   80101fd0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e2a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e31:	00 
80102e32:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e39:	80 
80102e3a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e41:	e8 ca 14 00 00       	call   80104310 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e46:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e4d:	00 00 00 
80102e50:	05 80 27 11 80       	add    $0x80112780,%eax
80102e55:	39 d8                	cmp    %ebx,%eax
80102e57:	76 6a                	jbe    80102ec3 <main+0x103>
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e60:	e8 6b 07 00 00       	call   801035d0 <mycpu>
80102e65:	39 d8                	cmp    %ebx,%eax
80102e67:	74 41                	je     80102eaa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e69:	e8 02 f6 ff ff       	call   80102470 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102e6e:	c7 05 f8 6f 00 80 a0 	movl   $0x80102da0,0x80006ff8
80102e75:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e78:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e7f:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e82:	05 00 10 00 00       	add    $0x1000,%eax
80102e87:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102e8c:	0f b6 03             	movzbl (%ebx),%eax
80102e8f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102e96:	00 
80102e97:	89 04 24             	mov    %eax,(%esp)
80102e9a:	e8 e1 f8 ff ff       	call   80102780 <lapicstartap>
80102e9f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ea0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	74 f6                	je     80102ea0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eaa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102eb1:	00 00 00 
80102eb4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eba:	05 80 27 11 80       	add    $0x80112780,%eax
80102ebf:	39 c3                	cmp    %eax,%ebx
80102ec1:	72 9d                	jb     80102e60 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ec3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eca:	8e 
80102ecb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ed2:	e8 49 f5 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80102ed7:	e8 c4 07 00 00       	call   801036a0 <userinit>
  mpmain();        // finish this processor's setup
80102edc:	e8 6f fe ff ff       	call   80102d50 <mpmain>
80102ee1:	66 90                	xchg   %ax,%ax
80102ee3:	66 90                	xchg   %ax,%ax
80102ee5:	66 90                	xchg   %ax,%ax
80102ee7:	66 90                	xchg   %ax,%ax
80102ee9:	66 90                	xchg   %ax,%ax
80102eeb:	66 90                	xchg   %ax,%ax
80102eed:	66 90                	xchg   %ax,%ax
80102eef:	90                   	nop

80102ef0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ef4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102efa:	53                   	push   %ebx
  e = addr+len;
80102efb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102efe:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f01:	39 de                	cmp    %ebx,%esi
80102f03:	73 3c                	jae    80102f41 <mpsearch1+0x51>
80102f05:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f08:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f0f:	00 
80102f10:	c7 44 24 04 d8 71 10 	movl   $0x801071d8,0x4(%esp)
80102f17:	80 
80102f18:	89 34 24             	mov    %esi,(%esp)
80102f1b:	e8 a0 13 00 00       	call   801042c0 <memcmp>
80102f20:	85 c0                	test   %eax,%eax
80102f22:	75 16                	jne    80102f3a <mpsearch1+0x4a>
80102f24:	31 c9                	xor    %ecx,%ecx
80102f26:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f28:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f2c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f2f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f31:	83 fa 10             	cmp    $0x10,%edx
80102f34:	75 f2                	jne    80102f28 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f36:	84 c9                	test   %cl,%cl
80102f38:	74 10                	je     80102f4a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f3a:	83 c6 10             	add    $0x10,%esi
80102f3d:	39 f3                	cmp    %esi,%ebx
80102f3f:	77 c7                	ja     80102f08 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f41:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f44:	31 c0                	xor    %eax,%eax
}
80102f46:	5b                   	pop    %ebx
80102f47:	5e                   	pop    %esi
80102f48:	5d                   	pop    %ebp
80102f49:	c3                   	ret    
80102f4a:	83 c4 10             	add    $0x10,%esp
80102f4d:	89 f0                	mov    %esi,%eax
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5d                   	pop    %ebp
80102f52:	c3                   	ret    
80102f53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f60 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	57                   	push   %edi
80102f64:	56                   	push   %esi
80102f65:	53                   	push   %ebx
80102f66:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f69:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f70:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f77:	c1 e0 08             	shl    $0x8,%eax
80102f7a:	09 d0                	or     %edx,%eax
80102f7c:	c1 e0 04             	shl    $0x4,%eax
80102f7f:	85 c0                	test   %eax,%eax
80102f81:	75 1b                	jne    80102f9e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102f83:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f8a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f91:	c1 e0 08             	shl    $0x8,%eax
80102f94:	09 d0                	or     %edx,%eax
80102f96:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102f99:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102f9e:	ba 00 04 00 00       	mov    $0x400,%edx
80102fa3:	e8 48 ff ff ff       	call   80102ef0 <mpsearch1>
80102fa8:	85 c0                	test   %eax,%eax
80102faa:	89 c7                	mov    %eax,%edi
80102fac:	0f 84 22 01 00 00    	je     801030d4 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fb2:	8b 77 04             	mov    0x4(%edi),%esi
80102fb5:	85 f6                	test   %esi,%esi
80102fb7:	0f 84 30 01 00 00    	je     801030ed <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fbd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fc3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fca:	00 
80102fcb:	c7 44 24 04 dd 71 10 	movl   $0x801071dd,0x4(%esp)
80102fd2:	80 
80102fd3:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102fd9:	e8 e2 12 00 00       	call   801042c0 <memcmp>
80102fde:	85 c0                	test   %eax,%eax
80102fe0:	0f 85 07 01 00 00    	jne    801030ed <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80102fe6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102fed:	3c 04                	cmp    $0x4,%al
80102fef:	0f 85 0b 01 00 00    	jne    80103100 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80102ff5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	74 21                	je     80103021 <mpinit+0xc1>
  sum = 0;
80103000:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103002:	31 d2                	xor    %edx,%edx
80103004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103008:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010300f:	80 
  for(i=0; i<len; i++)
80103010:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103013:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103015:	39 d0                	cmp    %edx,%eax
80103017:	7f ef                	jg     80103008 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103019:	84 c9                	test   %cl,%cl
8010301b:	0f 85 cc 00 00 00    	jne    801030ed <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103024:	85 c0                	test   %eax,%eax
80103026:	0f 84 c1 00 00 00    	je     801030ed <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010302c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103032:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103037:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010303c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103043:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103049:	03 55 e4             	add    -0x1c(%ebp),%edx
8010304c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103050:	39 c2                	cmp    %eax,%edx
80103052:	76 1b                	jbe    8010306f <mpinit+0x10f>
80103054:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103057:	80 f9 04             	cmp    $0x4,%cl
8010305a:	77 74                	ja     801030d0 <mpinit+0x170>
8010305c:	ff 24 8d 1c 72 10 80 	jmp    *-0x7fef8de4(,%ecx,4)
80103063:	90                   	nop
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103068:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010306b:	39 c2                	cmp    %eax,%edx
8010306d:	77 e5                	ja     80103054 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010306f:	85 db                	test   %ebx,%ebx
80103071:	0f 84 93 00 00 00    	je     8010310a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103077:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010307b:	74 12                	je     8010308f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307d:	ba 22 00 00 00       	mov    $0x22,%edx
80103082:	b8 70 00 00 00       	mov    $0x70,%eax
80103087:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103088:	b2 23                	mov    $0x23,%dl
8010308a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010308b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308e:	ee                   	out    %al,(%dx)
  }
}
8010308f:	83 c4 1c             	add    $0x1c,%esp
80103092:	5b                   	pop    %ebx
80103093:	5e                   	pop    %esi
80103094:	5f                   	pop    %edi
80103095:	5d                   	pop    %ebp
80103096:	c3                   	ret    
80103097:	90                   	nop
      if(ncpu < NCPU) {
80103098:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010309e:	83 fe 07             	cmp    $0x7,%esi
801030a1:	7f 17                	jg     801030ba <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030a3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030a7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ad:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030b4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030ba:	83 c0 14             	add    $0x14,%eax
      continue;
801030bd:	eb 91                	jmp    80103050 <mpinit+0xf0>
801030bf:	90                   	nop
      ioapicid = ioapic->apicno;
801030c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801030c7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801030cd:	eb 81                	jmp    80103050 <mpinit+0xf0>
801030cf:	90                   	nop
      ismp = 0;
801030d0:	31 db                	xor    %ebx,%ebx
801030d2:	eb 83                	jmp    80103057 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
801030d4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030d9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030de:	e8 0d fe ff ff       	call   80102ef0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030e3:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801030e5:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030e7:	0f 85 c5 fe ff ff    	jne    80102fb2 <mpinit+0x52>
    panic("Expect to run on an SMP");
801030ed:	c7 04 24 e2 71 10 80 	movl   $0x801071e2,(%esp)
801030f4:	e8 67 d2 ff ff       	call   80100360 <panic>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103100:	3c 01                	cmp    $0x1,%al
80103102:	0f 84 ed fe ff ff    	je     80102ff5 <mpinit+0x95>
80103108:	eb e3                	jmp    801030ed <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010310a:	c7 04 24 fc 71 10 80 	movl   $0x801071fc,(%esp)
80103111:	e8 4a d2 ff ff       	call   80100360 <panic>
80103116:	66 90                	xchg   %ax,%ax
80103118:	66 90                	xchg   %ax,%ax
8010311a:	66 90                	xchg   %ax,%ax
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103120:	55                   	push   %ebp
80103121:	ba 21 00 00 00       	mov    $0x21,%edx
80103126:	89 e5                	mov    %esp,%ebp
80103128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010312d:	ee                   	out    %al,(%dx)
8010312e:	b2 a1                	mov    $0xa1,%dl
80103130:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103131:	5d                   	pop    %ebp
80103132:	c3                   	ret    
80103133:	66 90                	xchg   %ax,%ax
80103135:	66 90                	xchg   %ax,%ax
80103137:	66 90                	xchg   %ax,%ax
80103139:	66 90                	xchg   %ax,%ax
8010313b:	66 90                	xchg   %ax,%ax
8010313d:	66 90                	xchg   %ax,%ax
8010313f:	90                   	nop

80103140 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	57                   	push   %edi
80103144:	56                   	push   %esi
80103145:	53                   	push   %ebx
80103146:	83 ec 1c             	sub    $0x1c,%esp
80103149:	8b 75 08             	mov    0x8(%ebp),%esi
8010314c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010314f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103155:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010315b:	e8 e0 db ff ff       	call   80100d40 <filealloc>
80103160:	85 c0                	test   %eax,%eax
80103162:	89 06                	mov    %eax,(%esi)
80103164:	0f 84 a4 00 00 00    	je     8010320e <pipealloc+0xce>
8010316a:	e8 d1 db ff ff       	call   80100d40 <filealloc>
8010316f:	85 c0                	test   %eax,%eax
80103171:	89 03                	mov    %eax,(%ebx)
80103173:	0f 84 87 00 00 00    	je     80103200 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103179:	e8 f2 f2 ff ff       	call   80102470 <kalloc>
8010317e:	85 c0                	test   %eax,%eax
80103180:	89 c7                	mov    %eax,%edi
80103182:	74 7c                	je     80103200 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103184:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010318b:	00 00 00 
  p->writeopen = 1;
8010318e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103195:	00 00 00 
  p->nwrite = 0;
80103198:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010319f:	00 00 00 
  p->nread = 0;
801031a2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031a9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ac:	89 04 24             	mov    %eax,(%esp)
801031af:	c7 44 24 04 30 72 10 	movl   $0x80107230,0x4(%esp)
801031b6:	80 
801031b7:	e8 84 0e 00 00       	call   80104040 <initlock>
  (*f0)->type = FD_PIPE;
801031bc:	8b 06                	mov    (%esi),%eax
801031be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031c4:	8b 06                	mov    (%esi),%eax
801031c6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031ca:	8b 06                	mov    (%esi),%eax
801031cc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031d0:	8b 06                	mov    (%esi),%eax
801031d2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031d5:	8b 03                	mov    (%ebx),%eax
801031d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031dd:	8b 03                	mov    (%ebx),%eax
801031df:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801031e3:	8b 03                	mov    (%ebx),%eax
801031e5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801031e9:	8b 03                	mov    (%ebx),%eax
  return 0;
801031eb:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
801031ed:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801031f0:	83 c4 1c             	add    $0x1c,%esp
801031f3:	89 d8                	mov    %ebx,%eax
801031f5:	5b                   	pop    %ebx
801031f6:	5e                   	pop    %esi
801031f7:	5f                   	pop    %edi
801031f8:	5d                   	pop    %ebp
801031f9:	c3                   	ret    
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103200:	8b 06                	mov    (%esi),%eax
80103202:	85 c0                	test   %eax,%eax
80103204:	74 08                	je     8010320e <pipealloc+0xce>
    fileclose(*f0);
80103206:	89 04 24             	mov    %eax,(%esp)
80103209:	e8 f2 db ff ff       	call   80100e00 <fileclose>
  if(*f1)
8010320e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103210:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103215:	85 c0                	test   %eax,%eax
80103217:	74 d7                	je     801031f0 <pipealloc+0xb0>
    fileclose(*f1);
80103219:	89 04 24             	mov    %eax,(%esp)
8010321c:	e8 df db ff ff       	call   80100e00 <fileclose>
}
80103221:	83 c4 1c             	add    $0x1c,%esp
80103224:	89 d8                	mov    %ebx,%eax
80103226:	5b                   	pop    %ebx
80103227:	5e                   	pop    %esi
80103228:	5f                   	pop    %edi
80103229:	5d                   	pop    %ebp
8010322a:	c3                   	ret    
8010322b:	90                   	nop
8010322c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103230 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	56                   	push   %esi
80103234:	53                   	push   %ebx
80103235:	83 ec 10             	sub    $0x10,%esp
80103238:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010323b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010323e:	89 1c 24             	mov    %ebx,(%esp)
80103241:	e8 6a 0f 00 00       	call   801041b0 <acquire>
  if(writable){
80103246:	85 f6                	test   %esi,%esi
80103248:	74 3e                	je     80103288 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010324a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103250:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103257:	00 00 00 
    wakeup(&p->nread);
8010325a:	89 04 24             	mov    %eax,(%esp)
8010325d:	e8 fe 0a 00 00       	call   80103d60 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103262:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103268:	85 d2                	test   %edx,%edx
8010326a:	75 0a                	jne    80103276 <pipeclose+0x46>
8010326c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103272:	85 c0                	test   %eax,%eax
80103274:	74 32                	je     801032a8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103276:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	5b                   	pop    %ebx
8010327d:	5e                   	pop    %esi
8010327e:	5d                   	pop    %ebp
    release(&p->lock);
8010327f:	e9 9c 0f 00 00       	jmp    80104220 <release>
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103288:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
8010328e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103295:	00 00 00 
    wakeup(&p->nwrite);
80103298:	89 04 24             	mov    %eax,(%esp)
8010329b:	e8 c0 0a 00 00       	call   80103d60 <wakeup>
801032a0:	eb c0                	jmp    80103262 <pipeclose+0x32>
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032a8:	89 1c 24             	mov    %ebx,(%esp)
801032ab:	e8 70 0f 00 00       	call   80104220 <release>
    kfree((char*)p);
801032b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b3:	83 c4 10             	add    $0x10,%esp
801032b6:	5b                   	pop    %ebx
801032b7:	5e                   	pop    %esi
801032b8:	5d                   	pop    %ebp
    kfree((char*)p);
801032b9:	e9 02 f0 ff ff       	jmp    801022c0 <kfree>
801032be:	66 90                	xchg   %ax,%ax

801032c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 1c             	sub    $0x1c,%esp
801032c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032cc:	89 1c 24             	mov    %ebx,(%esp)
801032cf:	e8 dc 0e 00 00       	call   801041b0 <acquire>
  for(i = 0; i < n; i++){
801032d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032d7:	85 c9                	test   %ecx,%ecx
801032d9:	0f 8e b2 00 00 00    	jle    80103391 <pipewrite+0xd1>
801032df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801032e2:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801032e8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032ee:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801032f4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801032f7:	03 4d 10             	add    0x10(%ebp),%ecx
801032fa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032fd:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103303:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103309:	39 c8                	cmp    %ecx,%eax
8010330b:	74 38                	je     80103345 <pipewrite+0x85>
8010330d:	eb 55                	jmp    80103364 <pipewrite+0xa4>
8010330f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103310:	e8 5b 03 00 00       	call   80103670 <myproc>
80103315:	8b 40 24             	mov    0x24(%eax),%eax
80103318:	85 c0                	test   %eax,%eax
8010331a:	75 33                	jne    8010334f <pipewrite+0x8f>
      wakeup(&p->nread);
8010331c:	89 3c 24             	mov    %edi,(%esp)
8010331f:	e8 3c 0a 00 00       	call   80103d60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103324:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103328:	89 34 24             	mov    %esi,(%esp)
8010332b:	e8 a0 08 00 00       	call   80103bd0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103330:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103336:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010333c:	05 00 02 00 00       	add    $0x200,%eax
80103341:	39 c2                	cmp    %eax,%edx
80103343:	75 23                	jne    80103368 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103345:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010334b:	85 d2                	test   %edx,%edx
8010334d:	75 c1                	jne    80103310 <pipewrite+0x50>
        release(&p->lock);
8010334f:	89 1c 24             	mov    %ebx,(%esp)
80103352:	e8 c9 0e 00 00       	call   80104220 <release>
        return -1;
80103357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010335c:	83 c4 1c             	add    $0x1c,%esp
8010335f:	5b                   	pop    %ebx
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103364:	89 c2                	mov    %eax,%edx
80103366:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103368:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010336b:	8d 42 01             	lea    0x1(%edx),%eax
8010336e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103374:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010337a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010337e:	0f b6 09             	movzbl (%ecx),%ecx
80103381:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103385:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103388:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010338b:	0f 85 6c ff ff ff    	jne    801032fd <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103391:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103397:	89 04 24             	mov    %eax,(%esp)
8010339a:	e8 c1 09 00 00       	call   80103d60 <wakeup>
  release(&p->lock);
8010339f:	89 1c 24             	mov    %ebx,(%esp)
801033a2:	e8 79 0e 00 00       	call   80104220 <release>
  return n;
801033a7:	8b 45 10             	mov    0x10(%ebp),%eax
801033aa:	eb b0                	jmp    8010335c <pipewrite+0x9c>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
801033b5:	53                   	push   %ebx
801033b6:	83 ec 1c             	sub    $0x1c,%esp
801033b9:	8b 75 08             	mov    0x8(%ebp),%esi
801033bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033bf:	89 34 24             	mov    %esi,(%esp)
801033c2:	e8 e9 0d 00 00       	call   801041b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033c7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033cd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033d3:	75 5b                	jne    80103430 <piperead+0x80>
801033d5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033db:	85 db                	test   %ebx,%ebx
801033dd:	74 51                	je     80103430 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033df:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801033e5:	eb 25                	jmp    8010340c <piperead+0x5c>
801033e7:	90                   	nop
801033e8:	89 74 24 04          	mov    %esi,0x4(%esp)
801033ec:	89 1c 24             	mov    %ebx,(%esp)
801033ef:	e8 dc 07 00 00       	call   80103bd0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033f4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fa:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103400:	75 2e                	jne    80103430 <piperead+0x80>
80103402:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103408:	85 d2                	test   %edx,%edx
8010340a:	74 24                	je     80103430 <piperead+0x80>
    if(myproc()->killed){
8010340c:	e8 5f 02 00 00       	call   80103670 <myproc>
80103411:	8b 48 24             	mov    0x24(%eax),%ecx
80103414:	85 c9                	test   %ecx,%ecx
80103416:	74 d0                	je     801033e8 <piperead+0x38>
      release(&p->lock);
80103418:	89 34 24             	mov    %esi,(%esp)
8010341b:	e8 00 0e 00 00       	call   80104220 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103420:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103428:	5b                   	pop    %ebx
80103429:	5e                   	pop    %esi
8010342a:	5f                   	pop    %edi
8010342b:	5d                   	pop    %ebp
8010342c:	c3                   	ret    
8010342d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103430:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103433:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103435:	85 d2                	test   %edx,%edx
80103437:	7f 2b                	jg     80103464 <piperead+0xb4>
80103439:	eb 31                	jmp    8010346c <piperead+0xbc>
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103440:	8d 48 01             	lea    0x1(%eax),%ecx
80103443:	25 ff 01 00 00       	and    $0x1ff,%eax
80103448:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010344e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103453:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103456:	83 c3 01             	add    $0x1,%ebx
80103459:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010345c:	74 0e                	je     8010346c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010345e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103464:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010346a:	75 d4                	jne    80103440 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010346c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103472:	89 04 24             	mov    %eax,(%esp)
80103475:	e8 e6 08 00 00       	call   80103d60 <wakeup>
  release(&p->lock);
8010347a:	89 34 24             	mov    %esi,(%esp)
8010347d:	e8 9e 0d 00 00       	call   80104220 <release>
}
80103482:	83 c4 1c             	add    $0x1c,%esp
  return i;
80103485:	89 d8                	mov    %ebx,%eax
}
80103487:	5b                   	pop    %ebx
80103488:	5e                   	pop    %esi
80103489:	5f                   	pop    %edi
8010348a:	5d                   	pop    %ebp
8010348b:	c3                   	ret    
8010348c:	66 90                	xchg   %ax,%ax
8010348e:	66 90                	xchg   %ax,%ax

80103490 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103494:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103499:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010349c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034a3:	e8 08 0d 00 00       	call   801041b0 <acquire>
801034a8:	eb 11                	jmp    801034bb <allocproc+0x2b>
801034aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b0:	83 eb 80             	sub    $0xffffff80,%ebx
801034b3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034b9:	74 7d                	je     80103538 <allocproc+0xa8>
    if(p->state == UNUSED)
801034bb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	75 ee                	jne    801034b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034c7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801034ce:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801034d5:	8d 50 01             	lea    0x1(%eax),%edx
801034d8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801034de:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801034e1:	e8 3a 0d 00 00       	call   80104220 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801034e6:	e8 85 ef ff ff       	call   80102470 <kalloc>
801034eb:	85 c0                	test   %eax,%eax
801034ed:	89 43 08             	mov    %eax,0x8(%ebx)
801034f0:	74 5a                	je     8010354c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801034f2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801034f8:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801034fd:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103500:	c7 40 14 95 53 10 80 	movl   $0x80105395,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103507:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010350e:	00 
8010350f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103516:	00 
80103517:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010351a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010351d:	e8 4e 0d 00 00       	call   80104270 <memset>
  p->context->eip = (uint)forkret;
80103522:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103525:	c7 40 10 60 35 10 80 	movl   $0x80103560,0x10(%eax)

  return p;
8010352c:	89 d8                	mov    %ebx,%eax
}
8010352e:	83 c4 14             	add    $0x14,%esp
80103531:	5b                   	pop    %ebx
80103532:	5d                   	pop    %ebp
80103533:	c3                   	ret    
80103534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103538:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010353f:	e8 dc 0c 00 00       	call   80104220 <release>
}
80103544:	83 c4 14             	add    $0x14,%esp
  return 0;
80103547:	31 c0                	xor    %eax,%eax
}
80103549:	5b                   	pop    %ebx
8010354a:	5d                   	pop    %ebp
8010354b:	c3                   	ret    
    p->state = UNUSED;
8010354c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103553:	eb d9                	jmp    8010352e <allocproc+0x9e>
80103555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103560 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103566:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010356d:	e8 ae 0c 00 00       	call   80104220 <release>

  if (first) {
80103572:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	75 05                	jne    80103580 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010357b:	c9                   	leave  
8010357c:	c3                   	ret    
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
80103580:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103587:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010358e:	00 00 00 
    iinit(ROOTDEV);
80103591:	e8 aa de ff ff       	call   80101440 <iinit>
    initlog(ROOTDEV);
80103596:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010359d:	e8 9e f4 ff ff       	call   80102a40 <initlog>
}
801035a2:	c9                   	leave  
801035a3:	c3                   	ret    
801035a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035b0 <pinit>:
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035b6:	c7 44 24 04 35 72 10 	movl   $0x80107235,0x4(%esp)
801035bd:	80 
801035be:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035c5:	e8 76 0a 00 00       	call   80104040 <initlock>
}
801035ca:	c9                   	leave  
801035cb:	c3                   	ret    
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035d0 <mycpu>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	56                   	push   %esi
801035d4:	53                   	push   %ebx
801035d5:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035d8:	9c                   	pushf  
801035d9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035da:	f6 c4 02             	test   $0x2,%ah
801035dd:	75 57                	jne    80103636 <mycpu+0x66>
  apicid = lapicid();
801035df:	e8 4c f1 ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801035e4:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801035ea:	85 f6                	test   %esi,%esi
801035ec:	7e 3c                	jle    8010362a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801035ee:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801035f5:	39 c2                	cmp    %eax,%edx
801035f7:	74 2d                	je     80103626 <mycpu+0x56>
801035f9:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801035fe:	31 d2                	xor    %edx,%edx
80103600:	83 c2 01             	add    $0x1,%edx
80103603:	39 f2                	cmp    %esi,%edx
80103605:	74 23                	je     8010362a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103607:	0f b6 19             	movzbl (%ecx),%ebx
8010360a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103610:	39 c3                	cmp    %eax,%ebx
80103612:	75 ec                	jne    80103600 <mycpu+0x30>
      return &cpus[i];
80103614:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010361a:	83 c4 10             	add    $0x10,%esp
8010361d:	5b                   	pop    %ebx
8010361e:	5e                   	pop    %esi
8010361f:	5d                   	pop    %ebp
      return &cpus[i];
80103620:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103625:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103626:	31 d2                	xor    %edx,%edx
80103628:	eb ea                	jmp    80103614 <mycpu+0x44>
  panic("unknown apicid\n");
8010362a:	c7 04 24 3c 72 10 80 	movl   $0x8010723c,(%esp)
80103631:	e8 2a cd ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103636:	c7 04 24 18 73 10 80 	movl   $0x80107318,(%esp)
8010363d:	e8 1e cd ff ff       	call   80100360 <panic>
80103642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103650 <cpuid>:
cpuid() {
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103656:	e8 75 ff ff ff       	call   801035d0 <mycpu>
}
8010365b:	c9                   	leave  
  return mycpu()-cpus;
8010365c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103661:	c1 f8 04             	sar    $0x4,%eax
80103664:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010366a:	c3                   	ret    
8010366b:	90                   	nop
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103670 <myproc>:
myproc(void) {
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
80103674:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103677:	e8 44 0a 00 00       	call   801040c0 <pushcli>
  c = mycpu();
8010367c:	e8 4f ff ff ff       	call   801035d0 <mycpu>
  p = c->proc;
80103681:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103687:	e8 74 0a 00 00       	call   80104100 <popcli>
}
8010368c:	83 c4 04             	add    $0x4,%esp
8010368f:	89 d8                	mov    %ebx,%eax
80103691:	5b                   	pop    %ebx
80103692:	5d                   	pop    %ebp
80103693:	c3                   	ret    
80103694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010369a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036a0 <userinit>:
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
801036a4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036a7:	e8 e4 fd ff ff       	call   80103490 <allocproc>
801036ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036ae:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036b3:	e8 c8 32 00 00       	call   80106980 <setupkvm>
801036b8:	85 c0                	test   %eax,%eax
801036ba:	89 43 04             	mov    %eax,0x4(%ebx)
801036bd:	0f 84 d4 00 00 00    	je     80103797 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036c3:	89 04 24             	mov    %eax,(%esp)
801036c6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036cd:	00 
801036ce:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036d5:	80 
801036d6:	e8 d5 2f 00 00       	call   801066b0 <inituvm>
  p->sz = PGSIZE;
801036db:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801036e1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801036e8:	00 
801036e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036f0:	00 
801036f1:	8b 43 18             	mov    0x18(%ebx),%eax
801036f4:	89 04 24             	mov    %eax,(%esp)
801036f7:	e8 74 0b 00 00       	call   80104270 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801036fc:	8b 43 18             	mov    0x18(%ebx),%eax
801036ff:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103704:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103709:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010370d:	8b 43 18             	mov    0x18(%ebx),%eax
80103710:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103714:	8b 43 18             	mov    0x18(%ebx),%eax
80103717:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010371b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010371f:	8b 43 18             	mov    0x18(%ebx),%eax
80103722:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103726:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010372a:	8b 43 18             	mov    0x18(%ebx),%eax
8010372d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103734:	8b 43 18             	mov    0x18(%ebx),%eax
80103737:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010373e:	8b 43 18             	mov    0x18(%ebx),%eax
80103741:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103748:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010374b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103752:	00 
80103753:	c7 44 24 04 65 72 10 	movl   $0x80107265,0x4(%esp)
8010375a:	80 
8010375b:	89 04 24             	mov    %eax,(%esp)
8010375e:	e8 ed 0c 00 00       	call   80104450 <safestrcpy>
  p->cwd = namei("/");
80103763:	c7 04 24 6e 72 10 80 	movl   $0x8010726e,(%esp)
8010376a:	e8 61 e7 ff ff       	call   80101ed0 <namei>
8010376f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103772:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103779:	e8 32 0a 00 00       	call   801041b0 <acquire>
  p->state = RUNNABLE;
8010377e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103785:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010378c:	e8 8f 0a 00 00       	call   80104220 <release>
}
80103791:	83 c4 14             	add    $0x14,%esp
80103794:	5b                   	pop    %ebx
80103795:	5d                   	pop    %ebp
80103796:	c3                   	ret    
    panic("userinit: out of memory?");
80103797:	c7 04 24 4c 72 10 80 	movl   $0x8010724c,(%esp)
8010379e:	e8 bd cb ff ff       	call   80100360 <panic>
801037a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <growproc>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	83 ec 10             	sub    $0x10,%esp
801037b8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037bb:	e8 b0 fe ff ff       	call   80103670 <myproc>
  if(n > 0){
801037c0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801037c3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801037c5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037c7:	7e 2f                	jle    801037f8 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037c9:	01 c6                	add    %eax,%esi
801037cb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801037d3:	8b 43 04             	mov    0x4(%ebx),%eax
801037d6:	89 04 24             	mov    %eax,(%esp)
801037d9:	e8 12 30 00 00       	call   801067f0 <allocuvm>
801037de:	85 c0                	test   %eax,%eax
801037e0:	74 36                	je     80103818 <growproc+0x68>
  curproc->sz = sz;
801037e2:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801037e4:	89 1c 24             	mov    %ebx,(%esp)
801037e7:	e8 b4 2d 00 00       	call   801065a0 <switchuvm>
  return 0;
801037ec:	31 c0                	xor    %eax,%eax
}
801037ee:	83 c4 10             	add    $0x10,%esp
801037f1:	5b                   	pop    %ebx
801037f2:	5e                   	pop    %esi
801037f3:	5d                   	pop    %ebp
801037f4:	c3                   	ret    
801037f5:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
801037f8:	74 e8                	je     801037e2 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037fa:	01 c6                	add    %eax,%esi
801037fc:	89 74 24 08          	mov    %esi,0x8(%esp)
80103800:	89 44 24 04          	mov    %eax,0x4(%esp)
80103804:	8b 43 04             	mov    0x4(%ebx),%eax
80103807:	89 04 24             	mov    %eax,(%esp)
8010380a:	e8 d1 30 00 00       	call   801068e0 <deallocuvm>
8010380f:	85 c0                	test   %eax,%eax
80103811:	75 cf                	jne    801037e2 <growproc+0x32>
80103813:	90                   	nop
80103814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010381d:	eb cf                	jmp    801037ee <growproc+0x3e>
8010381f:	90                   	nop

80103820 <fork>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103829:	e8 42 fe ff ff       	call   80103670 <myproc>
8010382e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103830:	e8 5b fc ff ff       	call   80103490 <allocproc>
80103835:	85 c0                	test   %eax,%eax
80103837:	89 c7                	mov    %eax,%edi
80103839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010383c:	0f 84 bc 00 00 00    	je     801038fe <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103842:	8b 03                	mov    (%ebx),%eax
80103844:	89 44 24 04          	mov    %eax,0x4(%esp)
80103848:	8b 43 04             	mov    0x4(%ebx),%eax
8010384b:	89 04 24             	mov    %eax,(%esp)
8010384e:	e8 0d 32 00 00       	call   80106a60 <copyuvm>
80103853:	85 c0                	test   %eax,%eax
80103855:	89 47 04             	mov    %eax,0x4(%edi)
80103858:	0f 84 a7 00 00 00    	je     80103905 <fork+0xe5>
  np->sz = curproc->sz;
8010385e:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103860:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103868:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010386a:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
8010386d:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103870:	8b 73 18             	mov    0x18(%ebx),%esi
80103873:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103875:	31 f6                	xor    %esi,%esi
  np->stackPages = curproc->stackPages; //lab3
80103877:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010387a:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
8010387d:	8b 42 18             	mov    0x18(%edx),%eax
80103880:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103887:	90                   	nop
    if(curproc->ofile[i])
80103888:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010388c:	85 c0                	test   %eax,%eax
8010388e:	74 0f                	je     8010389f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103890:	89 04 24             	mov    %eax,(%esp)
80103893:	e8 18 d5 ff ff       	call   80100db0 <filedup>
80103898:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010389b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010389f:	83 c6 01             	add    $0x1,%esi
801038a2:	83 fe 10             	cmp    $0x10,%esi
801038a5:	75 e1                	jne    80103888 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038a7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038aa:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038ad:	89 04 24             	mov    %eax,(%esp)
801038b0:	e8 9b dd ff ff       	call   80101650 <idup>
801038b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038b8:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038bb:	8d 47 6c             	lea    0x6c(%edi),%eax
801038be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038c9:	00 
801038ca:	89 04 24             	mov    %eax,(%esp)
801038cd:	e8 7e 0b 00 00       	call   80104450 <safestrcpy>
  pid = np->pid;
801038d2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801038d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038dc:	e8 cf 08 00 00       	call   801041b0 <acquire>
  np->state = RUNNABLE;
801038e1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801038e8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038ef:	e8 2c 09 00 00       	call   80104220 <release>
  return pid;
801038f4:	89 d8                	mov    %ebx,%eax
}
801038f6:	83 c4 1c             	add    $0x1c,%esp
801038f9:	5b                   	pop    %ebx
801038fa:	5e                   	pop    %esi
801038fb:	5f                   	pop    %edi
801038fc:	5d                   	pop    %ebp
801038fd:	c3                   	ret    
    return -1;
801038fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103903:	eb f1                	jmp    801038f6 <fork+0xd6>
    kfree(np->kstack);
80103905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103908:	8b 47 08             	mov    0x8(%edi),%eax
8010390b:	89 04 24             	mov    %eax,(%esp)
8010390e:	e8 ad e9 ff ff       	call   801022c0 <kfree>
    return -1;
80103913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103918:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010391f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103926:	eb ce                	jmp    801038f6 <fork+0xd6>
80103928:	90                   	nop
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103930 <scheduler>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	57                   	push   %edi
80103934:	56                   	push   %esi
80103935:	53                   	push   %ebx
80103936:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103939:	e8 92 fc ff ff       	call   801035d0 <mycpu>
8010393e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103940:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103947:	00 00 00 
8010394a:	8d 78 04             	lea    0x4(%eax),%edi
8010394d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103950:	fb                   	sti    
    acquire(&ptable.lock);
80103951:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103958:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010395d:	e8 4e 08 00 00       	call   801041b0 <acquire>
80103962:	eb 0f                	jmp    80103973 <scheduler+0x43>
80103964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103968:	83 eb 80             	sub    $0xffffff80,%ebx
8010396b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103971:	74 45                	je     801039b8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103973:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103977:	75 ef                	jne    80103968 <scheduler+0x38>
      c->proc = p;
80103979:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010397f:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103982:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
80103985:	e8 16 2c 00 00       	call   801065a0 <switchuvm>
      swtch(&(c->scheduler), p->context);
8010398a:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
8010398d:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
80103994:	89 3c 24             	mov    %edi,(%esp)
80103997:	89 44 24 04          	mov    %eax,0x4(%esp)
8010399b:	e8 0b 0b 00 00       	call   801044ab <swtch>
      switchkvm();
801039a0:	e8 db 2b 00 00       	call   80106580 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
801039ab:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039b2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b5:	75 bc                	jne    80103973 <scheduler+0x43>
801039b7:	90                   	nop
    release(&ptable.lock);
801039b8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039bf:	e8 5c 08 00 00       	call   80104220 <release>
  }
801039c4:	eb 8a                	jmp    80103950 <scheduler+0x20>
801039c6:	8d 76 00             	lea    0x0(%esi),%esi
801039c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039d0 <sched>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
801039d5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
801039d8:	e8 93 fc ff ff       	call   80103670 <myproc>
  if(!holding(&ptable.lock))
801039dd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
801039e4:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801039e6:	e8 85 07 00 00       	call   80104170 <holding>
801039eb:	85 c0                	test   %eax,%eax
801039ed:	74 4f                	je     80103a3e <sched+0x6e>
  if(mycpu()->ncli != 1)
801039ef:	e8 dc fb ff ff       	call   801035d0 <mycpu>
801039f4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801039fb:	75 65                	jne    80103a62 <sched+0x92>
  if(p->state == RUNNING)
801039fd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a01:	74 53                	je     80103a56 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a03:	9c                   	pushf  
80103a04:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a05:	f6 c4 02             	test   $0x2,%ah
80103a08:	75 40                	jne    80103a4a <sched+0x7a>
  intena = mycpu()->intena;
80103a0a:	e8 c1 fb ff ff       	call   801035d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a0f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a12:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a18:	e8 b3 fb ff ff       	call   801035d0 <mycpu>
80103a1d:	8b 40 04             	mov    0x4(%eax),%eax
80103a20:	89 1c 24             	mov    %ebx,(%esp)
80103a23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a27:	e8 7f 0a 00 00       	call   801044ab <swtch>
  mycpu()->intena = intena;
80103a2c:	e8 9f fb ff ff       	call   801035d0 <mycpu>
80103a31:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a37:	83 c4 10             	add    $0x10,%esp
80103a3a:	5b                   	pop    %ebx
80103a3b:	5e                   	pop    %esi
80103a3c:	5d                   	pop    %ebp
80103a3d:	c3                   	ret    
    panic("sched ptable.lock");
80103a3e:	c7 04 24 70 72 10 80 	movl   $0x80107270,(%esp)
80103a45:	e8 16 c9 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a4a:	c7 04 24 9c 72 10 80 	movl   $0x8010729c,(%esp)
80103a51:	e8 0a c9 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a56:	c7 04 24 8e 72 10 80 	movl   $0x8010728e,(%esp)
80103a5d:	e8 fe c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103a62:	c7 04 24 82 72 10 80 	movl   $0x80107282,(%esp)
80103a69:	e8 f2 c8 ff ff       	call   80100360 <panic>
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <exit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
  if(curproc == initproc)
80103a74:	31 f6                	xor    %esi,%esi
{
80103a76:	53                   	push   %ebx
80103a77:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103a7a:	e8 f1 fb ff ff       	call   80103670 <myproc>
  if(curproc == initproc)
80103a7f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103a85:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103a87:	0f 84 ea 00 00 00    	je     80103b77 <exit+0x107>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103a90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a94:	85 c0                	test   %eax,%eax
80103a96:	74 10                	je     80103aa8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103a98:	89 04 24             	mov    %eax,(%esp)
80103a9b:	e8 60 d3 ff ff       	call   80100e00 <fileclose>
      curproc->ofile[fd] = 0;
80103aa0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103aa7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103aa8:	83 c6 01             	add    $0x1,%esi
80103aab:	83 fe 10             	cmp    $0x10,%esi
80103aae:	75 e0                	jne    80103a90 <exit+0x20>
  begin_op();
80103ab0:	e8 2b f0 ff ff       	call   80102ae0 <begin_op>
  iput(curproc->cwd);
80103ab5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ab8:	89 04 24             	mov    %eax,(%esp)
80103abb:	e8 e0 dc ff ff       	call   801017a0 <iput>
  end_op();
80103ac0:	e8 8b f0 ff ff       	call   80102b50 <end_op>
  curproc->cwd = 0;
80103ac5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103acc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad3:	e8 d8 06 00 00       	call   801041b0 <acquire>
  wakeup1(curproc->parent);
80103ad8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103adb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ae0:	eb 11                	jmp    80103af3 <exit+0x83>
80103ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ae8:	83 ea 80             	sub    $0xffffff80,%edx
80103aeb:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103af1:	74 1d                	je     80103b10 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103af3:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103af7:	75 ef                	jne    80103ae8 <exit+0x78>
80103af9:	3b 42 20             	cmp    0x20(%edx),%eax
80103afc:	75 ea                	jne    80103ae8 <exit+0x78>
      p->state = RUNNABLE;
80103afe:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b05:	83 ea 80             	sub    $0xffffff80,%edx
80103b08:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b0e:	75 e3                	jne    80103af3 <exit+0x83>
      p->parent = initproc;
80103b10:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b15:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b1a:	eb 0f                	jmp    80103b2b <exit+0xbb>
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b20:	83 e9 80             	sub    $0xffffff80,%ecx
80103b23:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b29:	74 34                	je     80103b5f <exit+0xef>
    if(p->parent == curproc){
80103b2b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b2e:	75 f0                	jne    80103b20 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b30:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b34:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b37:	75 e7                	jne    80103b20 <exit+0xb0>
80103b39:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b3e:	eb 0b                	jmp    80103b4b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b40:	83 ea 80             	sub    $0xffffff80,%edx
80103b43:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b49:	74 d5                	je     80103b20 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b4b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b4f:	75 ef                	jne    80103b40 <exit+0xd0>
80103b51:	3b 42 20             	cmp    0x20(%edx),%eax
80103b54:	75 ea                	jne    80103b40 <exit+0xd0>
      p->state = RUNNABLE;
80103b56:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b5d:	eb e1                	jmp    80103b40 <exit+0xd0>
  curproc->state = ZOMBIE;
80103b5f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b66:	e8 65 fe ff ff       	call   801039d0 <sched>
  panic("zombie exit");
80103b6b:	c7 04 24 bd 72 10 80 	movl   $0x801072bd,(%esp)
80103b72:	e8 e9 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103b77:	c7 04 24 b0 72 10 80 	movl   $0x801072b0,(%esp)
80103b7e:	e8 dd c7 ff ff       	call   80100360 <panic>
80103b83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b90 <yield>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b96:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b9d:	e8 0e 06 00 00       	call   801041b0 <acquire>
  myproc()->state = RUNNABLE;
80103ba2:	e8 c9 fa ff ff       	call   80103670 <myproc>
80103ba7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bae:	e8 1d fe ff ff       	call   801039d0 <sched>
  release(&ptable.lock);
80103bb3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bba:	e8 61 06 00 00       	call   80104220 <release>
}
80103bbf:	c9                   	leave  
80103bc0:	c3                   	ret    
80103bc1:	eb 0d                	jmp    80103bd0 <sleep>
80103bc3:	90                   	nop
80103bc4:	90                   	nop
80103bc5:	90                   	nop
80103bc6:	90                   	nop
80103bc7:	90                   	nop
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	90                   	nop
80103bcd:	90                   	nop
80103bce:	90                   	nop
80103bcf:	90                   	nop

80103bd0 <sleep>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
80103bd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103bdf:	e8 8c fa ff ff       	call   80103670 <myproc>
  if(p == 0)
80103be4:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103be6:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103be8:	0f 84 7c 00 00 00    	je     80103c6a <sleep+0x9a>
  if(lk == 0)
80103bee:	85 f6                	test   %esi,%esi
80103bf0:	74 6c                	je     80103c5e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103bf2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103bf8:	74 46                	je     80103c40 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103bfa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c01:	e8 aa 05 00 00       	call   801041b0 <acquire>
    release(lk);
80103c06:	89 34 24             	mov    %esi,(%esp)
80103c09:	e8 12 06 00 00       	call   80104220 <release>
  p->chan = chan;
80103c0e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c11:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c18:	e8 b3 fd ff ff       	call   801039d0 <sched>
  p->chan = 0;
80103c1d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c24:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2b:	e8 f0 05 00 00       	call   80104220 <release>
    acquire(lk);
80103c30:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c33:	83 c4 1c             	add    $0x1c,%esp
80103c36:	5b                   	pop    %ebx
80103c37:	5e                   	pop    %esi
80103c38:	5f                   	pop    %edi
80103c39:	5d                   	pop    %ebp
    acquire(lk);
80103c3a:	e9 71 05 00 00       	jmp    801041b0 <acquire>
80103c3f:	90                   	nop
  p->chan = chan;
80103c40:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c43:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103c4a:	e8 81 fd ff ff       	call   801039d0 <sched>
  p->chan = 0;
80103c4f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c56:	83 c4 1c             	add    $0x1c,%esp
80103c59:	5b                   	pop    %ebx
80103c5a:	5e                   	pop    %esi
80103c5b:	5f                   	pop    %edi
80103c5c:	5d                   	pop    %ebp
80103c5d:	c3                   	ret    
    panic("sleep without lk");
80103c5e:	c7 04 24 cf 72 10 80 	movl   $0x801072cf,(%esp)
80103c65:	e8 f6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103c6a:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
80103c71:	e8 ea c6 ff ff       	call   80100360 <panic>
80103c76:	8d 76 00             	lea    0x0(%esi),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <wait>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
80103c85:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103c88:	e8 e3 f9 ff ff       	call   80103670 <myproc>
  acquire(&ptable.lock);
80103c8d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103c94:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103c96:	e8 15 05 00 00       	call   801041b0 <acquire>
    havekids = 0;
80103c9b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c9d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ca2:	eb 0f                	jmp    80103cb3 <wait+0x33>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	83 eb 80             	sub    $0xffffff80,%ebx
80103cab:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cb1:	74 1d                	je     80103cd0 <wait+0x50>
      if(p->parent != curproc)
80103cb3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103cb6:	75 f0                	jne    80103ca8 <wait+0x28>
      if(p->state == ZOMBIE){
80103cb8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cbc:	74 2f                	je     80103ced <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cbe:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103cc1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc6:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103ccc:	75 e5                	jne    80103cb3 <wait+0x33>
80103cce:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	74 6e                	je     80103d42 <wait+0xc2>
80103cd4:	8b 46 24             	mov    0x24(%esi),%eax
80103cd7:	85 c0                	test   %eax,%eax
80103cd9:	75 67                	jne    80103d42 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103cdb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103ce2:	80 
80103ce3:	89 34 24             	mov    %esi,(%esp)
80103ce6:	e8 e5 fe ff ff       	call   80103bd0 <sleep>
  }
80103ceb:	eb ae                	jmp    80103c9b <wait+0x1b>
        kfree(p->kstack);
80103ced:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103cf0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103cf3:	89 04 24             	mov    %eax,(%esp)
80103cf6:	e8 c5 e5 ff ff       	call   801022c0 <kfree>
        freevm(p->pgdir);
80103cfb:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103cfe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d05:	89 04 24             	mov    %eax,(%esp)
80103d08:	e8 f3 2b 00 00       	call   80106900 <freevm>
        release(&ptable.lock);
80103d0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d14:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d1b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d22:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d26:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d2d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d34:	e8 e7 04 00 00       	call   80104220 <release>
}
80103d39:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d3c:	89 f0                	mov    %esi,%eax
}
80103d3e:	5b                   	pop    %ebx
80103d3f:	5e                   	pop    %esi
80103d40:	5d                   	pop    %ebp
80103d41:	c3                   	ret    
      release(&ptable.lock);
80103d42:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d49:	e8 d2 04 00 00       	call   80104220 <release>
}
80103d4e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d56:	5b                   	pop    %ebx
80103d57:	5e                   	pop    %esi
80103d58:	5d                   	pop    %ebp
80103d59:	c3                   	ret    
80103d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d60 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 14             	sub    $0x14,%esp
80103d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103d6a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d71:	e8 3a 04 00 00       	call   801041b0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d76:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d7b:	eb 0d                	jmp    80103d8a <wakeup+0x2a>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
80103d80:	83 e8 80             	sub    $0xffffff80,%eax
80103d83:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d88:	74 1e                	je     80103da8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103d8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d8e:	75 f0                	jne    80103d80 <wakeup+0x20>
80103d90:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d93:	75 eb                	jne    80103d80 <wakeup+0x20>
      p->state = RUNNABLE;
80103d95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d9c:	83 e8 80             	sub    $0xffffff80,%eax
80103d9f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103da4:	75 e4                	jne    80103d8a <wakeup+0x2a>
80103da6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103da8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103daf:	83 c4 14             	add    $0x14,%esp
80103db2:	5b                   	pop    %ebx
80103db3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103db4:	e9 67 04 00 00       	jmp    80104220 <release>
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	53                   	push   %ebx
80103dc4:	83 ec 14             	sub    $0x14,%esp
80103dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103dca:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dd1:	e8 da 03 00 00       	call   801041b0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ddb:	eb 0d                	jmp    80103dea <kill+0x2a>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
80103de0:	83 e8 80             	sub    $0xffffff80,%eax
80103de3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103de8:	74 36                	je     80103e20 <kill+0x60>
    if(p->pid == pid){
80103dea:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ded:	75 f1                	jne    80103de0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103def:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103df3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103dfa:	74 14                	je     80103e10 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103dfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e03:	e8 18 04 00 00       	call   80104220 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e08:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e0b:	31 c0                	xor    %eax,%eax
}
80103e0d:	5b                   	pop    %ebx
80103e0e:	5d                   	pop    %ebp
80103e0f:	c3                   	ret    
        p->state = RUNNABLE;
80103e10:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e17:	eb e3                	jmp    80103dfc <kill+0x3c>
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e20:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e27:	e8 f4 03 00 00       	call   80104220 <release>
}
80103e2c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e34:	5b                   	pop    %ebx
80103e35:	5d                   	pop    %ebp
80103e36:	c3                   	ret    
80103e37:	89 f6                	mov    %esi,%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e4b:	83 ec 4c             	sub    $0x4c,%esp
80103e4e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e51:	eb 20                	jmp    80103e73 <procdump+0x33>
80103e53:	90                   	nop
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103e58:	c7 04 24 9f 76 10 80 	movl   $0x8010769f,(%esp)
80103e5f:	e8 ec c7 ff ff       	call   80100650 <cprintf>
80103e64:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e67:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103e6d:	0f 84 8d 00 00 00    	je     80103f00 <procdump+0xc0>
    if(p->state == UNUSED)
80103e73:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103e76:	85 c0                	test   %eax,%eax
80103e78:	74 ea                	je     80103e64 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e7a:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103e7d:	ba e0 72 10 80       	mov    $0x801072e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103e82:	77 11                	ja     80103e95 <procdump+0x55>
80103e84:	8b 14 85 40 73 10 80 	mov    -0x7fef8cc0(,%eax,4),%edx
      state = "???";
80103e8b:	b8 e0 72 10 80       	mov    $0x801072e0,%eax
80103e90:	85 d2                	test   %edx,%edx
80103e92:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103e95:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103e98:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103e9c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ea0:	c7 04 24 e4 72 10 80 	movl   $0x801072e4,(%esp)
80103ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eab:	e8 a0 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103eb0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103eb4:	75 a2                	jne    80103e58 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103eb6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ebd:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ec0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ec3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ec6:	83 c0 08             	add    $0x8,%eax
80103ec9:	89 04 24             	mov    %eax,(%esp)
80103ecc:	e8 8f 01 00 00       	call   80104060 <getcallerpcs>
80103ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ed8:	8b 17                	mov    (%edi),%edx
80103eda:	85 d2                	test   %edx,%edx
80103edc:	0f 84 76 ff ff ff    	je     80103e58 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103ee2:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ee6:	83 c7 04             	add    $0x4,%edi
80103ee9:	c7 04 24 21 6d 10 80 	movl   $0x80106d21,(%esp)
80103ef0:	e8 5b c7 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103ef5:	39 f7                	cmp    %esi,%edi
80103ef7:	75 df                	jne    80103ed8 <procdump+0x98>
80103ef9:	e9 5a ff ff ff       	jmp    80103e58 <procdump+0x18>
80103efe:	66 90                	xchg   %ax,%ax
  }
}
80103f00:	83 c4 4c             	add    $0x4c,%esp
80103f03:	5b                   	pop    %ebx
80103f04:	5e                   	pop    %esi
80103f05:	5f                   	pop    %edi
80103f06:	5d                   	pop    %ebp
80103f07:	c3                   	ret    
80103f08:	66 90                	xchg   %ax,%ax
80103f0a:	66 90                	xchg   %ax,%ax
80103f0c:	66 90                	xchg   %ax,%ax
80103f0e:	66 90                	xchg   %ax,%ax

80103f10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f1a:	c7 44 24 04 58 73 10 	movl   $0x80107358,0x4(%esp)
80103f21:	80 
80103f22:	8d 43 04             	lea    0x4(%ebx),%eax
80103f25:	89 04 24             	mov    %eax,(%esp)
80103f28:	e8 13 01 00 00       	call   80104040 <initlock>
  lk->name = name;
80103f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f30:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f36:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f3d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f40:	83 c4 14             	add    $0x14,%esp
80103f43:	5b                   	pop    %ebx
80103f44:	5d                   	pop    %ebp
80103f45:	c3                   	ret    
80103f46:	8d 76 00             	lea    0x0(%esi),%esi
80103f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
80103f55:	83 ec 10             	sub    $0x10,%esp
80103f58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f5b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f5e:	89 34 24             	mov    %esi,(%esp)
80103f61:	e8 4a 02 00 00       	call   801041b0 <acquire>
  while (lk->locked) {
80103f66:	8b 13                	mov    (%ebx),%edx
80103f68:	85 d2                	test   %edx,%edx
80103f6a:	74 16                	je     80103f82 <acquiresleep+0x32>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103f70:	89 74 24 04          	mov    %esi,0x4(%esp)
80103f74:	89 1c 24             	mov    %ebx,(%esp)
80103f77:	e8 54 fc ff ff       	call   80103bd0 <sleep>
  while (lk->locked) {
80103f7c:	8b 03                	mov    (%ebx),%eax
80103f7e:	85 c0                	test   %eax,%eax
80103f80:	75 ee                	jne    80103f70 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103f82:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103f88:	e8 e3 f6 ff ff       	call   80103670 <myproc>
80103f8d:	8b 40 10             	mov    0x10(%eax),%eax
80103f90:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103f93:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103f96:	83 c4 10             	add    $0x10,%esp
80103f99:	5b                   	pop    %ebx
80103f9a:	5e                   	pop    %esi
80103f9b:	5d                   	pop    %ebp
  release(&lk->lk);
80103f9c:	e9 7f 02 00 00       	jmp    80104220 <release>
80103fa1:	eb 0d                	jmp    80103fb0 <releasesleep>
80103fa3:	90                   	nop
80103fa4:	90                   	nop
80103fa5:	90                   	nop
80103fa6:	90                   	nop
80103fa7:	90                   	nop
80103fa8:	90                   	nop
80103fa9:	90                   	nop
80103faa:	90                   	nop
80103fab:	90                   	nop
80103fac:	90                   	nop
80103fad:	90                   	nop
80103fae:	90                   	nop
80103faf:	90                   	nop

80103fb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
80103fb5:	83 ec 10             	sub    $0x10,%esp
80103fb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fbb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fbe:	89 34 24             	mov    %esi,(%esp)
80103fc1:	e8 ea 01 00 00       	call   801041b0 <acquire>
  lk->locked = 0;
80103fc6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fcc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103fd3:	89 1c 24             	mov    %ebx,(%esp)
80103fd6:	e8 85 fd ff ff       	call   80103d60 <wakeup>
  release(&lk->lk);
80103fdb:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fde:	83 c4 10             	add    $0x10,%esp
80103fe1:	5b                   	pop    %ebx
80103fe2:	5e                   	pop    %esi
80103fe3:	5d                   	pop    %ebp
  release(&lk->lk);
80103fe4:	e9 37 02 00 00       	jmp    80104220 <release>
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80103ff4:	31 ff                	xor    %edi,%edi
{
80103ff6:	56                   	push   %esi
80103ff7:	53                   	push   %ebx
80103ff8:	83 ec 1c             	sub    $0x1c,%esp
80103ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ffe:	8d 73 04             	lea    0x4(%ebx),%esi
80104001:	89 34 24             	mov    %esi,(%esp)
80104004:	e8 a7 01 00 00       	call   801041b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104009:	8b 03                	mov    (%ebx),%eax
8010400b:	85 c0                	test   %eax,%eax
8010400d:	74 13                	je     80104022 <holdingsleep+0x32>
8010400f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104012:	e8 59 f6 ff ff       	call   80103670 <myproc>
80104017:	3b 58 10             	cmp    0x10(%eax),%ebx
8010401a:	0f 94 c0             	sete   %al
8010401d:	0f b6 c0             	movzbl %al,%eax
80104020:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104022:	89 34 24             	mov    %esi,(%esp)
80104025:	e8 f6 01 00 00       	call   80104220 <release>
  return r;
}
8010402a:	83 c4 1c             	add    $0x1c,%esp
8010402d:	89 f8                	mov    %edi,%eax
8010402f:	5b                   	pop    %ebx
80104030:	5e                   	pop    %esi
80104031:	5f                   	pop    %edi
80104032:	5d                   	pop    %ebp
80104033:	c3                   	ret    
80104034:	66 90                	xchg   %ax,%ax
80104036:	66 90                	xchg   %ax,%ax
80104038:	66 90                	xchg   %ax,%ax
8010403a:	66 90                	xchg   %ax,%ax
8010403c:	66 90                	xchg   %ax,%ax
8010403e:	66 90                	xchg   %ax,%ax

80104040 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104046:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010404f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104059:	5d                   	pop    %ebp
8010405a:	c3                   	ret    
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104060 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104069:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010406a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010406d:	31 c0                	xor    %eax,%eax
8010406f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104070:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104076:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010407c:	77 1a                	ja     80104098 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010407e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104081:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104084:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104087:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104089:	83 f8 0a             	cmp    $0xa,%eax
8010408c:	75 e2                	jne    80104070 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010408e:	5b                   	pop    %ebx
8010408f:	5d                   	pop    %ebp
80104090:	c3                   	ret    
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104098:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010409f:	83 c0 01             	add    $0x1,%eax
801040a2:	83 f8 0a             	cmp    $0xa,%eax
801040a5:	74 e7                	je     8010408e <getcallerpcs+0x2e>
    pcs[i] = 0;
801040a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ae:	83 c0 01             	add    $0x1,%eax
801040b1:	83 f8 0a             	cmp    $0xa,%eax
801040b4:	75 e2                	jne    80104098 <getcallerpcs+0x38>
801040b6:	eb d6                	jmp    8010408e <getcallerpcs+0x2e>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 04             	sub    $0x4,%esp
801040c7:	9c                   	pushf  
801040c8:	5b                   	pop    %ebx
  asm volatile("cli");
801040c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801040ca:	e8 01 f5 ff ff       	call   801035d0 <mycpu>
801040cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801040d5:	85 c0                	test   %eax,%eax
801040d7:	75 11                	jne    801040ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801040d9:	e8 f2 f4 ff ff       	call   801035d0 <mycpu>
801040de:	81 e3 00 02 00 00    	and    $0x200,%ebx
801040e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801040ea:	e8 e1 f4 ff ff       	call   801035d0 <mycpu>
801040ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801040f6:	83 c4 04             	add    $0x4,%esp
801040f9:	5b                   	pop    %ebx
801040fa:	5d                   	pop    %ebp
801040fb:	c3                   	ret    
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104100 <popcli>:

void
popcli(void)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104106:	9c                   	pushf  
80104107:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104108:	f6 c4 02             	test   $0x2,%ah
8010410b:	75 49                	jne    80104156 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010410d:	e8 be f4 ff ff       	call   801035d0 <mycpu>
80104112:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104118:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010411b:	85 d2                	test   %edx,%edx
8010411d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104123:	78 25                	js     8010414a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104125:	e8 a6 f4 ff ff       	call   801035d0 <mycpu>
8010412a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104130:	85 d2                	test   %edx,%edx
80104132:	74 04                	je     80104138 <popcli+0x38>
    sti();
}
80104134:	c9                   	leave  
80104135:	c3                   	ret    
80104136:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104138:	e8 93 f4 ff ff       	call   801035d0 <mycpu>
8010413d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104143:	85 c0                	test   %eax,%eax
80104145:	74 ed                	je     80104134 <popcli+0x34>
  asm volatile("sti");
80104147:	fb                   	sti    
}
80104148:	c9                   	leave  
80104149:	c3                   	ret    
    panic("popcli");
8010414a:	c7 04 24 7a 73 10 80 	movl   $0x8010737a,(%esp)
80104151:	e8 0a c2 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104156:	c7 04 24 63 73 10 80 	movl   $0x80107363,(%esp)
8010415d:	e8 fe c1 ff ff       	call   80100360 <panic>
80104162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104170 <holding>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
80104174:	31 f6                	xor    %esi,%esi
{
80104176:	53                   	push   %ebx
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010417a:	e8 41 ff ff ff       	call   801040c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010417f:	8b 03                	mov    (%ebx),%eax
80104181:	85 c0                	test   %eax,%eax
80104183:	74 12                	je     80104197 <holding+0x27>
80104185:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104188:	e8 43 f4 ff ff       	call   801035d0 <mycpu>
8010418d:	39 c3                	cmp    %eax,%ebx
8010418f:	0f 94 c0             	sete   %al
80104192:	0f b6 c0             	movzbl %al,%eax
80104195:	89 c6                	mov    %eax,%esi
  popcli();
80104197:	e8 64 ff ff ff       	call   80104100 <popcli>
}
8010419c:	89 f0                	mov    %esi,%eax
8010419e:	5b                   	pop    %ebx
8010419f:	5e                   	pop    %esi
801041a0:	5d                   	pop    %ebp
801041a1:	c3                   	ret    
801041a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <acquire>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801041b7:	e8 04 ff ff ff       	call   801040c0 <pushcli>
  if(holding(lk))
801041bc:	8b 45 08             	mov    0x8(%ebp),%eax
801041bf:	89 04 24             	mov    %eax,(%esp)
801041c2:	e8 a9 ff ff ff       	call   80104170 <holding>
801041c7:	85 c0                	test   %eax,%eax
801041c9:	75 3a                	jne    80104205 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
801041cb:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801041d0:	8b 55 08             	mov    0x8(%ebp),%edx
801041d3:	89 c8                	mov    %ecx,%eax
801041d5:	f0 87 02             	lock xchg %eax,(%edx)
801041d8:	85 c0                	test   %eax,%eax
801041da:	75 f4                	jne    801041d0 <acquire+0x20>
  __sync_synchronize();
801041dc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801041df:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041e2:	e8 e9 f3 ff ff       	call   801035d0 <mycpu>
801041e7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041ea:	8b 45 08             	mov    0x8(%ebp),%eax
801041ed:	83 c0 0c             	add    $0xc,%eax
801041f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041f4:	8d 45 08             	lea    0x8(%ebp),%eax
801041f7:	89 04 24             	mov    %eax,(%esp)
801041fa:	e8 61 fe ff ff       	call   80104060 <getcallerpcs>
}
801041ff:	83 c4 14             	add    $0x14,%esp
80104202:	5b                   	pop    %ebx
80104203:	5d                   	pop    %ebp
80104204:	c3                   	ret    
    panic("acquire");
80104205:	c7 04 24 81 73 10 80 	movl   $0x80107381,(%esp)
8010420c:	e8 4f c1 ff ff       	call   80100360 <panic>
80104211:	eb 0d                	jmp    80104220 <release>
80104213:	90                   	nop
80104214:	90                   	nop
80104215:	90                   	nop
80104216:	90                   	nop
80104217:	90                   	nop
80104218:	90                   	nop
80104219:	90                   	nop
8010421a:	90                   	nop
8010421b:	90                   	nop
8010421c:	90                   	nop
8010421d:	90                   	nop
8010421e:	90                   	nop
8010421f:	90                   	nop

80104220 <release>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 14             	sub    $0x14,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010422a:	89 1c 24             	mov    %ebx,(%esp)
8010422d:	e8 3e ff ff ff       	call   80104170 <holding>
80104232:	85 c0                	test   %eax,%eax
80104234:	74 21                	je     80104257 <release+0x37>
  lk->pcs[0] = 0;
80104236:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010423d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104244:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104247:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010424d:	83 c4 14             	add    $0x14,%esp
80104250:	5b                   	pop    %ebx
80104251:	5d                   	pop    %ebp
  popcli();
80104252:	e9 a9 fe ff ff       	jmp    80104100 <popcli>
    panic("release");
80104257:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
8010425e:	e8 fd c0 ff ff       	call   80100360 <panic>
80104263:	66 90                	xchg   %ax,%ax
80104265:	66 90                	xchg   %ax,%ax
80104267:	66 90                	xchg   %ax,%ax
80104269:	66 90                	xchg   %ax,%ax
8010426b:	66 90                	xchg   %ax,%ax
8010426d:	66 90                	xchg   %ax,%ax
8010426f:	90                   	nop

80104270 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 55 08             	mov    0x8(%ebp),%edx
80104276:	57                   	push   %edi
80104277:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010427a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010427b:	f6 c2 03             	test   $0x3,%dl
8010427e:	75 05                	jne    80104285 <memset+0x15>
80104280:	f6 c1 03             	test   $0x3,%cl
80104283:	74 13                	je     80104298 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104285:	89 d7                	mov    %edx,%edi
80104287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428a:	fc                   	cld    
8010428b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010428d:	5b                   	pop    %ebx
8010428e:	89 d0                	mov    %edx,%eax
80104290:	5f                   	pop    %edi
80104291:	5d                   	pop    %ebp
80104292:	c3                   	ret    
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104298:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010429c:	c1 e9 02             	shr    $0x2,%ecx
8010429f:	89 f8                	mov    %edi,%eax
801042a1:	89 fb                	mov    %edi,%ebx
801042a3:	c1 e0 18             	shl    $0x18,%eax
801042a6:	c1 e3 10             	shl    $0x10,%ebx
801042a9:	09 d8                	or     %ebx,%eax
801042ab:	09 f8                	or     %edi,%eax
801042ad:	c1 e7 08             	shl    $0x8,%edi
801042b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042b2:	89 d7                	mov    %edx,%edi
801042b4:	fc                   	cld    
801042b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042b7:	5b                   	pop    %ebx
801042b8:	89 d0                	mov    %edx,%eax
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 45 10             	mov    0x10(%ebp),%eax
801042c6:	57                   	push   %edi
801042c7:	56                   	push   %esi
801042c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042cb:	53                   	push   %ebx
801042cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042cf:	85 c0                	test   %eax,%eax
801042d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042d4:	74 26                	je     801042fc <memcmp+0x3c>
    if(*s1 != *s2)
801042d6:	0f b6 03             	movzbl (%ebx),%eax
801042d9:	31 d2                	xor    %edx,%edx
801042db:	0f b6 0e             	movzbl (%esi),%ecx
801042de:	38 c8                	cmp    %cl,%al
801042e0:	74 16                	je     801042f8 <memcmp+0x38>
801042e2:	eb 24                	jmp    80104308 <memcmp+0x48>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042ed:	83 c2 01             	add    $0x1,%edx
801042f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801042f4:	38 c8                	cmp    %cl,%al
801042f6:	75 10                	jne    80104308 <memcmp+0x48>
  while(n-- > 0){
801042f8:	39 fa                	cmp    %edi,%edx
801042fa:	75 ec                	jne    801042e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801042fc:	5b                   	pop    %ebx
  return 0;
801042fd:	31 c0                	xor    %eax,%eax
}
801042ff:	5e                   	pop    %esi
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104308:	5b                   	pop    %ebx
      return *s1 - *s2;
80104309:	29 c8                	sub    %ecx,%eax
}
8010430b:	5e                   	pop    %esi
8010430c:	5f                   	pop    %edi
8010430d:	5d                   	pop    %ebp
8010430e:	c3                   	ret    
8010430f:	90                   	nop

80104310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	56                   	push   %esi
80104318:	8b 75 0c             	mov    0xc(%ebp),%esi
8010431b:	53                   	push   %ebx
8010431c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010431f:	39 c6                	cmp    %eax,%esi
80104321:	73 35                	jae    80104358 <memmove+0x48>
80104323:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104326:	39 c8                	cmp    %ecx,%eax
80104328:	73 2e                	jae    80104358 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010432a:	85 db                	test   %ebx,%ebx
    d += n;
8010432c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010432f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104332:	74 1b                	je     8010434f <memmove+0x3f>
80104334:	f7 db                	neg    %ebx
80104336:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104339:	01 fb                	add    %edi,%ebx
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104340:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104344:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104347:	83 ea 01             	sub    $0x1,%edx
8010434a:	83 fa ff             	cmp    $0xffffffff,%edx
8010434d:	75 f1                	jne    80104340 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5f                   	pop    %edi
80104352:	5d                   	pop    %ebp
80104353:	c3                   	ret    
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104358:	31 d2                	xor    %edx,%edx
8010435a:	85 db                	test   %ebx,%ebx
8010435c:	74 f1                	je     8010434f <memmove+0x3f>
8010435e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104367:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010436a:	39 da                	cmp    %ebx,%edx
8010436c:	75 f2                	jne    80104360 <memmove+0x50>
}
8010436e:	5b                   	pop    %ebx
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104383:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104384:	eb 8a                	jmp    80104310 <memmove>
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	8b 75 10             	mov    0x10(%ebp),%esi
80104397:	53                   	push   %ebx
80104398:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010439b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010439e:	85 f6                	test   %esi,%esi
801043a0:	74 30                	je     801043d2 <strncmp+0x42>
801043a2:	0f b6 01             	movzbl (%ecx),%eax
801043a5:	84 c0                	test   %al,%al
801043a7:	74 2f                	je     801043d8 <strncmp+0x48>
801043a9:	0f b6 13             	movzbl (%ebx),%edx
801043ac:	38 d0                	cmp    %dl,%al
801043ae:	75 46                	jne    801043f6 <strncmp+0x66>
801043b0:	8d 51 01             	lea    0x1(%ecx),%edx
801043b3:	01 ce                	add    %ecx,%esi
801043b5:	eb 14                	jmp    801043cb <strncmp+0x3b>
801043b7:	90                   	nop
801043b8:	0f b6 02             	movzbl (%edx),%eax
801043bb:	84 c0                	test   %al,%al
801043bd:	74 31                	je     801043f0 <strncmp+0x60>
801043bf:	0f b6 19             	movzbl (%ecx),%ebx
801043c2:	83 c2 01             	add    $0x1,%edx
801043c5:	38 d8                	cmp    %bl,%al
801043c7:	75 17                	jne    801043e0 <strncmp+0x50>
    n--, p++, q++;
801043c9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801043cb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801043d0:	75 e6                	jne    801043b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801043d2:	5b                   	pop    %ebx
    return 0;
801043d3:	31 c0                	xor    %eax,%eax
}
801043d5:	5e                   	pop    %esi
801043d6:	5d                   	pop    %ebp
801043d7:	c3                   	ret    
801043d8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801043db:	31 c0                	xor    %eax,%eax
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801043e0:	0f b6 d3             	movzbl %bl,%edx
801043e3:	29 d0                	sub    %edx,%eax
}
801043e5:	5b                   	pop    %ebx
801043e6:	5e                   	pop    %esi
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret    
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801043f4:	eb ea                	jmp    801043e0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801043f6:	89 d3                	mov    %edx,%ebx
801043f8:	eb e6                	jmp    801043e0 <strncmp+0x50>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
80104406:	56                   	push   %esi
80104407:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010440a:	53                   	push   %ebx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010440e:	89 c2                	mov    %eax,%edx
80104410:	eb 19                	jmp    8010442b <strncpy+0x2b>
80104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104418:	83 c3 01             	add    $0x1,%ebx
8010441b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010441f:	83 c2 01             	add    $0x1,%edx
80104422:	84 c9                	test   %cl,%cl
80104424:	88 4a ff             	mov    %cl,-0x1(%edx)
80104427:	74 09                	je     80104432 <strncpy+0x32>
80104429:	89 f1                	mov    %esi,%ecx
8010442b:	85 c9                	test   %ecx,%ecx
8010442d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104430:	7f e6                	jg     80104418 <strncpy+0x18>
    ;
  while(n-- > 0)
80104432:	31 c9                	xor    %ecx,%ecx
80104434:	85 f6                	test   %esi,%esi
80104436:	7e 0f                	jle    80104447 <strncpy+0x47>
    *s++ = 0;
80104438:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010443c:	89 f3                	mov    %esi,%ebx
8010443e:	83 c1 01             	add    $0x1,%ecx
80104441:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104443:	85 db                	test   %ebx,%ebx
80104445:	7f f1                	jg     80104438 <strncpy+0x38>
  return os;
}
80104447:	5b                   	pop    %ebx
80104448:	5e                   	pop    %esi
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104456:	56                   	push   %esi
80104457:	8b 45 08             	mov    0x8(%ebp),%eax
8010445a:	53                   	push   %ebx
8010445b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010445e:	85 c9                	test   %ecx,%ecx
80104460:	7e 26                	jle    80104488 <safestrcpy+0x38>
80104462:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104466:	89 c1                	mov    %eax,%ecx
80104468:	eb 17                	jmp    80104481 <safestrcpy+0x31>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104470:	83 c2 01             	add    $0x1,%edx
80104473:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104477:	83 c1 01             	add    $0x1,%ecx
8010447a:	84 db                	test   %bl,%bl
8010447c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010447f:	74 04                	je     80104485 <safestrcpy+0x35>
80104481:	39 f2                	cmp    %esi,%edx
80104483:	75 eb                	jne    80104470 <safestrcpy+0x20>
    ;
  *s = 0;
80104485:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104488:	5b                   	pop    %ebx
80104489:	5e                   	pop    %esi
8010448a:	5d                   	pop    %ebp
8010448b:	c3                   	ret    
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <strlen>:

int
strlen(const char *s)
{
80104490:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104491:	31 c0                	xor    %eax,%eax
{
80104493:	89 e5                	mov    %esp,%ebp
80104495:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104498:	80 3a 00             	cmpb   $0x0,(%edx)
8010449b:	74 0c                	je     801044a9 <strlen+0x19>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	83 c0 01             	add    $0x1,%eax
801044a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044a7:	75 f7                	jne    801044a0 <strlen+0x10>
    ;
  return n;
}
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    

801044ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801044b3:	55                   	push   %ebp
  pushl %ebx
801044b4:	53                   	push   %ebx
  pushl %esi
801044b5:	56                   	push   %esi
  pushl %edi
801044b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801044bb:	5f                   	pop    %edi
  popl %esi
801044bc:	5e                   	pop    %esi
  popl %ebx
801044bd:	5b                   	pop    %ebx
  popl %ebp
801044be:	5d                   	pop    %ebp
  ret
801044bf:	c3                   	ret    

801044c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= STACKTOP || addr+4 > STACKTOP) //Lab3 changes
801044c6:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801044cb:	77 0b                	ja     801044d8 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
801044cd:	8b 10                	mov    (%eax),%edx
801044cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d2:	89 10                	mov    %edx,(%eax)
  return 0;
801044d4:	31 c0                	xor    %eax,%eax
}
801044d6:	5d                   	pop    %ebp
801044d7:	c3                   	ret    
    return -1;
801044d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044dd:	5d                   	pop    %ebp
801044de:	c3                   	ret    
801044df:	90                   	nop

801044e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;

  if(addr >= STACKTOP) //Lab3 changes
801044e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801044ec:	77 21                	ja     8010450f <fetchstr+0x2f>
    return -1;
  *pp = (char*)addr;
801044ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801044f1:	89 d0                	mov    %edx,%eax
801044f3:	89 11                	mov    %edx,(%ecx)
  ep = (char*)STACKTOP; //Lab3 changes
  for(s = *pp; s < ep; s++){
    if(*s == 0)
801044f5:	80 3a 00             	cmpb   $0x0,(%edx)
801044f8:	75 0b                	jne    80104505 <fetchstr+0x25>
801044fa:	eb 1c                	jmp    80104518 <fetchstr+0x38>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104500:	80 38 00             	cmpb   $0x0,(%eax)
80104503:	74 13                	je     80104518 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104505:	83 c0 01             	add    $0x1,%eax
80104508:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
8010450d:	75 f1                	jne    80104500 <fetchstr+0x20>
    return -1;
8010450f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104518:	29 d0                	sub    %edx,%eax
}
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104526:	e8 45 f1 ff ff       	call   80103670 <myproc>
8010452b:	8b 55 08             	mov    0x8(%ebp),%edx
8010452e:	8b 40 18             	mov    0x18(%eax),%eax
80104531:	8b 40 44             	mov    0x44(%eax),%eax
80104534:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= STACKTOP || addr+4 > STACKTOP) //Lab3 changes
80104538:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010453d:	77 11                	ja     80104550 <argint+0x30>
  *ip = *(int*)(addr);
8010453f:	8b 10                	mov    (%eax),%edx
80104541:	8b 45 0c             	mov    0xc(%ebp),%eax
80104544:	89 10                	mov    %edx,(%eax)
  return 0;
80104546:	31 c0                	xor    %eax,%eax
}
80104548:	c9                   	leave  
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104555:	c9                   	leave  
80104556:	c3                   	ret    
80104557:	89 f6                	mov    %esi,%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 24             	sub    $0x24,%esp
80104567:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
 
  if(argint(n, &i) < 0)
8010456a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010456d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104571:	8b 45 08             	mov    0x8(%ebp),%eax
80104574:	89 04 24             	mov    %eax,(%esp)
80104577:	e8 a4 ff ff ff       	call   80104520 <argint>
8010457c:	85 c0                	test   %eax,%eax
8010457e:	78 20                	js     801045a0 <argptr+0x40>
    return -1;
  if(size < 0 || (uint)i >= STACKTOP || (uint)i+size > STACKTOP)
80104580:	85 db                	test   %ebx,%ebx
80104582:	78 1c                	js     801045a0 <argptr+0x40>
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010458c:	77 12                	ja     801045a0 <argptr+0x40>
8010458e:	01 c3                	add    %eax,%ebx
80104590:	78 0e                	js     801045a0 <argptr+0x40>
    return -1;
  *pp = (char*)i;
80104592:	8b 55 0c             	mov    0xc(%ebp),%edx
80104595:	89 02                	mov    %eax,(%edx)
  return 0;
80104597:	31 c0                	xor    %eax,%eax
}
80104599:	83 c4 24             	add    $0x24,%esp
8010459c:	5b                   	pop    %ebx
8010459d:	5d                   	pop    %ebp
8010459e:	c3                   	ret    
8010459f:	90                   	nop
    return -1;
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a5:	eb f2                	jmp    80104599 <argptr+0x39>
801045a7:	89 f6                	mov    %esi,%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801045b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801045bd:	8b 45 08             	mov    0x8(%ebp),%eax
801045c0:	89 04 24             	mov    %eax,(%esp)
801045c3:	e8 58 ff ff ff       	call   80104520 <argint>
801045c8:	85 c0                	test   %eax,%eax
801045ca:	78 2b                	js     801045f7 <argstr+0x47>
    return -1;
  return fetchstr(addr, pp);
801045cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(addr >= STACKTOP) //Lab3 changes
801045cf:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801045d5:	77 20                	ja     801045f7 <argstr+0x47>
  *pp = (char*)addr;
801045d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045da:	89 d0                	mov    %edx,%eax
801045dc:	89 11                	mov    %edx,(%ecx)
    if(*s == 0)
801045de:	80 3a 00             	cmpb   $0x0,(%edx)
801045e1:	75 0a                	jne    801045ed <argstr+0x3d>
801045e3:	eb 1b                	jmp    80104600 <argstr+0x50>
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
801045e8:	80 38 00             	cmpb   $0x0,(%eax)
801045eb:	74 13                	je     80104600 <argstr+0x50>
  for(s = *pp; s < ep; s++){
801045ed:	83 c0 01             	add    $0x1,%eax
801045f0:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801045f5:	76 f1                	jbe    801045e8 <argstr+0x38>
    return -1;
801045f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045fc:	c9                   	leave  
801045fd:	c3                   	ret    
801045fe:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104600:	29 d0                	sub    %edx,%eax
}
80104602:	c9                   	leave  
80104603:	c3                   	ret    
80104604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010460a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104610 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104618:	e8 53 f0 ff ff       	call   80103670 <myproc>

  num = curproc->tf->eax;
8010461d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104620:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104622:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104625:	8d 50 ff             	lea    -0x1(%eax),%edx
80104628:	83 fa 14             	cmp    $0x14,%edx
8010462b:	77 1b                	ja     80104648 <syscall+0x38>
8010462d:	8b 14 85 c0 73 10 80 	mov    -0x7fef8c40(,%eax,4),%edx
80104634:	85 d2                	test   %edx,%edx
80104636:	74 10                	je     80104648 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104638:	ff d2                	call   *%edx
8010463a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	5b                   	pop    %ebx
80104641:	5e                   	pop    %esi
80104642:	5d                   	pop    %ebp
80104643:	c3                   	ret    
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104648:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010464c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010464f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104653:	8b 43 10             	mov    0x10(%ebx),%eax
80104656:	c7 04 24 91 73 10 80 	movl   $0x80107391,(%esp)
8010465d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104661:	e8 ea bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104666:	8b 43 18             	mov    0x18(%ebx),%eax
80104669:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5d                   	pop    %ebp
80104676:	c3                   	ret    
80104677:	66 90                	xchg   %ax,%ax
80104679:	66 90                	xchg   %ax,%ax
8010467b:	66 90                	xchg   %ax,%ax
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	89 c3                	mov    %eax,%ebx
80104686:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104689:	e8 e2 ef ff ff       	call   80103670 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010468e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104690:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104694:	85 c9                	test   %ecx,%ecx
80104696:	74 18                	je     801046b0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104698:	83 c2 01             	add    $0x1,%edx
8010469b:	83 fa 10             	cmp    $0x10,%edx
8010469e:	75 f0                	jne    80104690 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046a0:	83 c4 04             	add    $0x4,%esp
  return -1;
801046a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046a8:	5b                   	pop    %ebx
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	90                   	nop
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801046b0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801046b4:	83 c4 04             	add    $0x4,%esp
      return fd;
801046b7:	89 d0                	mov    %edx,%eax
}
801046b9:	5b                   	pop    %ebx
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	56                   	push   %esi
801046c5:	53                   	push   %ebx
801046c6:	83 ec 3c             	sub    $0x3c,%esp
801046c9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801046cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046cf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046d6:	89 04 24             	mov    %eax,(%esp)
{
801046d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801046dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801046df:	e8 0c d8 ff ff       	call   80101ef0 <nameiparent>
801046e4:	85 c0                	test   %eax,%eax
801046e6:	89 c7                	mov    %eax,%edi
801046e8:	0f 84 da 00 00 00    	je     801047c8 <create+0x108>
    return 0;
  ilock(dp);
801046ee:	89 04 24             	mov    %eax,(%esp)
801046f1:	e8 8a cf ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801046f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801046fd:	00 
801046fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104702:	89 3c 24             	mov    %edi,(%esp)
80104705:	e8 86 d4 ff ff       	call   80101b90 <dirlookup>
8010470a:	85 c0                	test   %eax,%eax
8010470c:	89 c6                	mov    %eax,%esi
8010470e:	74 40                	je     80104750 <create+0x90>
    iunlockput(dp);
80104710:	89 3c 24             	mov    %edi,(%esp)
80104713:	e8 c8 d1 ff ff       	call   801018e0 <iunlockput>
    ilock(ip);
80104718:	89 34 24             	mov    %esi,(%esp)
8010471b:	e8 60 cf ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104720:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104725:	75 11                	jne    80104738 <create+0x78>
80104727:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010472c:	89 f0                	mov    %esi,%eax
8010472e:	75 08                	jne    80104738 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104730:	83 c4 3c             	add    $0x3c,%esp
80104733:	5b                   	pop    %ebx
80104734:	5e                   	pop    %esi
80104735:	5f                   	pop    %edi
80104736:	5d                   	pop    %ebp
80104737:	c3                   	ret    
    iunlockput(ip);
80104738:	89 34 24             	mov    %esi,(%esp)
8010473b:	e8 a0 d1 ff ff       	call   801018e0 <iunlockput>
}
80104740:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104743:	31 c0                	xor    %eax,%eax
}
80104745:	5b                   	pop    %ebx
80104746:	5e                   	pop    %esi
80104747:	5f                   	pop    %edi
80104748:	5d                   	pop    %ebp
80104749:	c3                   	ret    
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104750:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104754:	89 44 24 04          	mov    %eax,0x4(%esp)
80104758:	8b 07                	mov    (%edi),%eax
8010475a:	89 04 24             	mov    %eax,(%esp)
8010475d:	e8 8e cd ff ff       	call   801014f0 <ialloc>
80104762:	85 c0                	test   %eax,%eax
80104764:	89 c6                	mov    %eax,%esi
80104766:	0f 84 bf 00 00 00    	je     8010482b <create+0x16b>
  ilock(ip);
8010476c:	89 04 24             	mov    %eax,(%esp)
8010476f:	e8 0c cf ff ff       	call   80101680 <ilock>
  ip->major = major;
80104774:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104778:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010477c:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104780:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104784:	b8 01 00 00 00       	mov    $0x1,%eax
80104789:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010478d:	89 34 24             	mov    %esi,(%esp)
80104790:	e8 2b ce ff ff       	call   801015c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104795:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010479a:	74 34                	je     801047d0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010479c:	8b 46 04             	mov    0x4(%esi),%eax
8010479f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047a3:	89 3c 24             	mov    %edi,(%esp)
801047a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047aa:	e8 41 d6 ff ff       	call   80101df0 <dirlink>
801047af:	85 c0                	test   %eax,%eax
801047b1:	78 6c                	js     8010481f <create+0x15f>
  iunlockput(dp);
801047b3:	89 3c 24             	mov    %edi,(%esp)
801047b6:	e8 25 d1 ff ff       	call   801018e0 <iunlockput>
}
801047bb:	83 c4 3c             	add    $0x3c,%esp
  return ip;
801047be:	89 f0                	mov    %esi,%eax
}
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5f                   	pop    %edi
801047c3:	5d                   	pop    %ebp
801047c4:	c3                   	ret    
801047c5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801047c8:	31 c0                	xor    %eax,%eax
801047ca:	e9 61 ff ff ff       	jmp    80104730 <create+0x70>
801047cf:	90                   	nop
    dp->nlink++;  // for ".."
801047d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047d5:	89 3c 24             	mov    %edi,(%esp)
801047d8:	e8 e3 cd ff ff       	call   801015c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047dd:	8b 46 04             	mov    0x4(%esi),%eax
801047e0:	c7 44 24 04 34 74 10 	movl   $0x80107434,0x4(%esp)
801047e7:	80 
801047e8:	89 34 24             	mov    %esi,(%esp)
801047eb:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ef:	e8 fc d5 ff ff       	call   80101df0 <dirlink>
801047f4:	85 c0                	test   %eax,%eax
801047f6:	78 1b                	js     80104813 <create+0x153>
801047f8:	8b 47 04             	mov    0x4(%edi),%eax
801047fb:	c7 44 24 04 33 74 10 	movl   $0x80107433,0x4(%esp)
80104802:	80 
80104803:	89 34 24             	mov    %esi,(%esp)
80104806:	89 44 24 08          	mov    %eax,0x8(%esp)
8010480a:	e8 e1 d5 ff ff       	call   80101df0 <dirlink>
8010480f:	85 c0                	test   %eax,%eax
80104811:	79 89                	jns    8010479c <create+0xdc>
      panic("create dots");
80104813:	c7 04 24 27 74 10 80 	movl   $0x80107427,(%esp)
8010481a:	e8 41 bb ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010481f:	c7 04 24 36 74 10 80 	movl   $0x80107436,(%esp)
80104826:	e8 35 bb ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010482b:	c7 04 24 18 74 10 80 	movl   $0x80107418,(%esp)
80104832:	e8 29 bb ff ff       	call   80100360 <panic>
80104837:	89 f6                	mov    %esi,%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	89 c6                	mov    %eax,%esi
80104846:	53                   	push   %ebx
80104847:	89 d3                	mov    %edx,%ebx
80104849:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010484c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010484f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104853:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010485a:	e8 c1 fc ff ff       	call   80104520 <argint>
8010485f:	85 c0                	test   %eax,%eax
80104861:	78 2d                	js     80104890 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104863:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104867:	77 27                	ja     80104890 <argfd.constprop.0+0x50>
80104869:	e8 02 ee ff ff       	call   80103670 <myproc>
8010486e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104871:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	74 17                	je     80104890 <argfd.constprop.0+0x50>
  if(pfd)
80104879:	85 f6                	test   %esi,%esi
8010487b:	74 02                	je     8010487f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010487d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010487f:	85 db                	test   %ebx,%ebx
80104881:	74 1d                	je     801048a0 <argfd.constprop.0+0x60>
    *pf = f;
80104883:	89 03                	mov    %eax,(%ebx)
  return 0;
80104885:	31 c0                	xor    %eax,%eax
}
80104887:	83 c4 20             	add    $0x20,%esp
8010488a:	5b                   	pop    %ebx
8010488b:	5e                   	pop    %esi
8010488c:	5d                   	pop    %ebp
8010488d:	c3                   	ret    
8010488e:	66 90                	xchg   %ax,%ax
80104890:	83 c4 20             	add    $0x20,%esp
    return -1;
80104893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801048a0:	31 c0                	xor    %eax,%eax
801048a2:	eb e3                	jmp    80104887 <argfd.constprop.0+0x47>
801048a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048b0 <sys_dup>:
{
801048b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	53                   	push   %ebx
801048b6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801048b9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048bc:	e8 7f ff ff ff       	call   80104840 <argfd.constprop.0>
801048c1:	85 c0                	test   %eax,%eax
801048c3:	78 23                	js     801048e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801048c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c8:	e8 b3 fd ff ff       	call   80104680 <fdalloc>
801048cd:	85 c0                	test   %eax,%eax
801048cf:	89 c3                	mov    %eax,%ebx
801048d1:	78 15                	js     801048e8 <sys_dup+0x38>
  filedup(f);
801048d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d6:	89 04 24             	mov    %eax,(%esp)
801048d9:	e8 d2 c4 ff ff       	call   80100db0 <filedup>
  return fd;
801048de:	89 d8                	mov    %ebx,%eax
}
801048e0:	83 c4 24             	add    $0x24,%esp
801048e3:	5b                   	pop    %ebx
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	66 90                	xchg   %ax,%ax
    return -1;
801048e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ed:	eb f1                	jmp    801048e0 <sys_dup+0x30>
801048ef:	90                   	nop

801048f0 <sys_read>:
{
801048f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048f1:	31 c0                	xor    %eax,%eax
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801048fb:	e8 40 ff ff ff       	call   80104840 <argfd.constprop.0>
80104900:	85 c0                	test   %eax,%eax
80104902:	78 54                	js     80104958 <sys_read+0x68>
80104904:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104907:	89 44 24 04          	mov    %eax,0x4(%esp)
8010490b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104912:	e8 09 fc ff ff       	call   80104520 <argint>
80104917:	85 c0                	test   %eax,%eax
80104919:	78 3d                	js     80104958 <sys_read+0x68>
8010491b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104925:	89 44 24 08          	mov    %eax,0x8(%esp)
80104929:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010492c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104930:	e8 2b fc ff ff       	call   80104560 <argptr>
80104935:	85 c0                	test   %eax,%eax
80104937:	78 1f                	js     80104958 <sys_read+0x68>
  return fileread(f, p, n);
80104939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010493c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104943:	89 44 24 04          	mov    %eax,0x4(%esp)
80104947:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010494a:	89 04 24             	mov    %eax,(%esp)
8010494d:	e8 be c5 ff ff       	call   80100f10 <fileread>
}
80104952:	c9                   	leave  
80104953:	c3                   	ret    
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010495d:	c9                   	leave  
8010495e:	c3                   	ret    
8010495f:	90                   	nop

80104960 <sys_write>:
{
80104960:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104961:	31 c0                	xor    %eax,%eax
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104968:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010496b:	e8 d0 fe ff ff       	call   80104840 <argfd.constprop.0>
80104970:	85 c0                	test   %eax,%eax
80104972:	78 54                	js     801049c8 <sys_write+0x68>
80104974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104977:	89 44 24 04          	mov    %eax,0x4(%esp)
8010497b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104982:	e8 99 fb ff ff       	call   80104520 <argint>
80104987:	85 c0                	test   %eax,%eax
80104989:	78 3d                	js     801049c8 <sys_write+0x68>
8010498b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104995:	89 44 24 08          	mov    %eax,0x8(%esp)
80104999:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499c:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a0:	e8 bb fb ff ff       	call   80104560 <argptr>
801049a5:	85 c0                	test   %eax,%eax
801049a7:	78 1f                	js     801049c8 <sys_write+0x68>
  return filewrite(f, p, n);
801049a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801049b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ba:	89 04 24             	mov    %eax,(%esp)
801049bd:	e8 ee c5 ff ff       	call   80100fb0 <filewrite>
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049cd:	c9                   	leave  
801049ce:	c3                   	ret    
801049cf:	90                   	nop

801049d0 <sys_close>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801049d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049dc:	e8 5f fe ff ff       	call   80104840 <argfd.constprop.0>
801049e1:	85 c0                	test   %eax,%eax
801049e3:	78 23                	js     80104a08 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801049e5:	e8 86 ec ff ff       	call   80103670 <myproc>
801049ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049ed:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801049f4:	00 
  fileclose(f);
801049f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f8:	89 04 24             	mov    %eax,(%esp)
801049fb:	e8 00 c4 ff ff       	call   80100e00 <fileclose>
  return 0;
80104a00:	31 c0                	xor    %eax,%eax
}
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a0d:	c9                   	leave  
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop

80104a10 <sys_fstat>:
{
80104a10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a1b:	e8 20 fe ff ff       	call   80104840 <argfd.constprop.0>
80104a20:	85 c0                	test   %eax,%eax
80104a22:	78 34                	js     80104a58 <sys_fstat+0x48>
80104a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a2e:	00 
80104a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a3a:	e8 21 fb ff ff       	call   80104560 <argptr>
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	78 15                	js     80104a58 <sys_fstat+0x48>
  return filestat(f, st);
80104a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4d:	89 04 24             	mov    %eax,(%esp)
80104a50:	e8 6b c4 ff ff       	call   80100ec0 <filestat>
}
80104a55:	c9                   	leave  
80104a56:	c3                   	ret    
80104a57:	90                   	nop
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a5d:	c9                   	leave  
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <sys_link>:
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	53                   	push   %ebx
80104a66:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a77:	e8 34 fb ff ff       	call   801045b0 <argstr>
80104a7c:	85 c0                	test   %eax,%eax
80104a7e:	0f 88 e6 00 00 00    	js     80104b6a <sys_link+0x10a>
80104a84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a92:	e8 19 fb ff ff       	call   801045b0 <argstr>
80104a97:	85 c0                	test   %eax,%eax
80104a99:	0f 88 cb 00 00 00    	js     80104b6a <sys_link+0x10a>
  begin_op();
80104a9f:	e8 3c e0 ff ff       	call   80102ae0 <begin_op>
  if((ip = namei(old)) == 0){
80104aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104aa7:	89 04 24             	mov    %eax,(%esp)
80104aaa:	e8 21 d4 ff ff       	call   80101ed0 <namei>
80104aaf:	85 c0                	test   %eax,%eax
80104ab1:	89 c3                	mov    %eax,%ebx
80104ab3:	0f 84 ac 00 00 00    	je     80104b65 <sys_link+0x105>
  ilock(ip);
80104ab9:	89 04 24             	mov    %eax,(%esp)
80104abc:	e8 bf cb ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80104ac1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ac6:	0f 84 91 00 00 00    	je     80104b5d <sys_link+0xfd>
  ip->nlink++;
80104acc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ad1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ad4:	89 1c 24             	mov    %ebx,(%esp)
80104ad7:	e8 e4 ca ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104adc:	89 1c 24             	mov    %ebx,(%esp)
80104adf:	e8 7c cc ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ae4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104aeb:	89 04 24             	mov    %eax,(%esp)
80104aee:	e8 fd d3 ff ff       	call   80101ef0 <nameiparent>
80104af3:	85 c0                	test   %eax,%eax
80104af5:	89 c6                	mov    %eax,%esi
80104af7:	74 4f                	je     80104b48 <sys_link+0xe8>
  ilock(dp);
80104af9:	89 04 24             	mov    %eax,(%esp)
80104afc:	e8 7f cb ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b01:	8b 03                	mov    (%ebx),%eax
80104b03:	39 06                	cmp    %eax,(%esi)
80104b05:	75 39                	jne    80104b40 <sys_link+0xe0>
80104b07:	8b 43 04             	mov    0x4(%ebx),%eax
80104b0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b0e:	89 34 24             	mov    %esi,(%esp)
80104b11:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b15:	e8 d6 d2 ff ff       	call   80101df0 <dirlink>
80104b1a:	85 c0                	test   %eax,%eax
80104b1c:	78 22                	js     80104b40 <sys_link+0xe0>
  iunlockput(dp);
80104b1e:	89 34 24             	mov    %esi,(%esp)
80104b21:	e8 ba cd ff ff       	call   801018e0 <iunlockput>
  iput(ip);
80104b26:	89 1c 24             	mov    %ebx,(%esp)
80104b29:	e8 72 cc ff ff       	call   801017a0 <iput>
  end_op();
80104b2e:	e8 1d e0 ff ff       	call   80102b50 <end_op>
}
80104b33:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b36:	31 c0                	xor    %eax,%eax
}
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5f                   	pop    %edi
80104b3b:	5d                   	pop    %ebp
80104b3c:	c3                   	ret    
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b40:	89 34 24             	mov    %esi,(%esp)
80104b43:	e8 98 cd ff ff       	call   801018e0 <iunlockput>
  ilock(ip);
80104b48:	89 1c 24             	mov    %ebx,(%esp)
80104b4b:	e8 30 cb ff ff       	call   80101680 <ilock>
  ip->nlink--;
80104b50:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b55:	89 1c 24             	mov    %ebx,(%esp)
80104b58:	e8 63 ca ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104b5d:	89 1c 24             	mov    %ebx,(%esp)
80104b60:	e8 7b cd ff ff       	call   801018e0 <iunlockput>
  end_op();
80104b65:	e8 e6 df ff ff       	call   80102b50 <end_op>
}
80104b6a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b72:	5b                   	pop    %ebx
80104b73:	5e                   	pop    %esi
80104b74:	5f                   	pop    %edi
80104b75:	5d                   	pop    %ebp
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <sys_unlink>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
80104b86:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104b89:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b97:	e8 14 fa ff ff       	call   801045b0 <argstr>
80104b9c:	85 c0                	test   %eax,%eax
80104b9e:	0f 88 76 01 00 00    	js     80104d1a <sys_unlink+0x19a>
  begin_op();
80104ba4:	e8 37 df ff ff       	call   80102ae0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ba9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104baf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bb3:	89 04 24             	mov    %eax,(%esp)
80104bb6:	e8 35 d3 ff ff       	call   80101ef0 <nameiparent>
80104bbb:	85 c0                	test   %eax,%eax
80104bbd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bc0:	0f 84 4f 01 00 00    	je     80104d15 <sys_unlink+0x195>
  ilock(dp);
80104bc6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bc9:	89 34 24             	mov    %esi,(%esp)
80104bcc:	e8 af ca ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bd1:	c7 44 24 04 34 74 10 	movl   $0x80107434,0x4(%esp)
80104bd8:	80 
80104bd9:	89 1c 24             	mov    %ebx,(%esp)
80104bdc:	e8 7f cf ff ff       	call   80101b60 <namecmp>
80104be1:	85 c0                	test   %eax,%eax
80104be3:	0f 84 21 01 00 00    	je     80104d0a <sys_unlink+0x18a>
80104be9:	c7 44 24 04 33 74 10 	movl   $0x80107433,0x4(%esp)
80104bf0:	80 
80104bf1:	89 1c 24             	mov    %ebx,(%esp)
80104bf4:	e8 67 cf ff ff       	call   80101b60 <namecmp>
80104bf9:	85 c0                	test   %eax,%eax
80104bfb:	0f 84 09 01 00 00    	je     80104d0a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c04:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c0c:	89 34 24             	mov    %esi,(%esp)
80104c0f:	e8 7c cf ff ff       	call   80101b90 <dirlookup>
80104c14:	85 c0                	test   %eax,%eax
80104c16:	89 c3                	mov    %eax,%ebx
80104c18:	0f 84 ec 00 00 00    	je     80104d0a <sys_unlink+0x18a>
  ilock(ip);
80104c1e:	89 04 24             	mov    %eax,(%esp)
80104c21:	e8 5a ca ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80104c26:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c2b:	0f 8e 24 01 00 00    	jle    80104d55 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c39:	74 7d                	je     80104cb8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c3b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c42:	00 
80104c43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c4a:	00 
80104c4b:	89 34 24             	mov    %esi,(%esp)
80104c4e:	e8 1d f6 ff ff       	call   80104270 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c56:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c5d:	00 
80104c5e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c62:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c66:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 bf cd ff ff       	call   80101a30 <writei>
80104c71:	83 f8 10             	cmp    $0x10,%eax
80104c74:	0f 85 cf 00 00 00    	jne    80104d49 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104c7a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c7f:	0f 84 a3 00 00 00    	je     80104d28 <sys_unlink+0x1a8>
  iunlockput(dp);
80104c85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c88:	89 04 24             	mov    %eax,(%esp)
80104c8b:	e8 50 cc ff ff       	call   801018e0 <iunlockput>
  ip->nlink--;
80104c90:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c95:	89 1c 24             	mov    %ebx,(%esp)
80104c98:	e8 23 c9 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104c9d:	89 1c 24             	mov    %ebx,(%esp)
80104ca0:	e8 3b cc ff ff       	call   801018e0 <iunlockput>
  end_op();
80104ca5:	e8 a6 de ff ff       	call   80102b50 <end_op>
}
80104caa:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104cad:	31 c0                	xor    %eax,%eax
}
80104caf:	5b                   	pop    %ebx
80104cb0:	5e                   	pop    %esi
80104cb1:	5f                   	pop    %edi
80104cb2:	5d                   	pop    %ebp
80104cb3:	c3                   	ret    
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104cb8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104cbc:	0f 86 79 ff ff ff    	jbe    80104c3b <sys_unlink+0xbb>
80104cc2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cc7:	eb 15                	jmp    80104cde <sys_unlink+0x15e>
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd0:	8d 57 10             	lea    0x10(%edi),%edx
80104cd3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104cd6:	0f 83 5f ff ff ff    	jae    80104c3b <sys_unlink+0xbb>
80104cdc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cde:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ce5:	00 
80104ce6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cea:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cee:	89 1c 24             	mov    %ebx,(%esp)
80104cf1:	e8 3a cc ff ff       	call   80101930 <readi>
80104cf6:	83 f8 10             	cmp    $0x10,%eax
80104cf9:	75 42                	jne    80104d3d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104cfb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d00:	74 ce                	je     80104cd0 <sys_unlink+0x150>
    iunlockput(ip);
80104d02:	89 1c 24             	mov    %ebx,(%esp)
80104d05:	e8 d6 cb ff ff       	call   801018e0 <iunlockput>
  iunlockput(dp);
80104d0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d0d:	89 04 24             	mov    %eax,(%esp)
80104d10:	e8 cb cb ff ff       	call   801018e0 <iunlockput>
  end_op();
80104d15:	e8 36 de ff ff       	call   80102b50 <end_op>
}
80104d1a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d22:	5b                   	pop    %ebx
80104d23:	5e                   	pop    %esi
80104d24:	5f                   	pop    %edi
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret    
80104d27:	90                   	nop
    dp->nlink--;
80104d28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d2b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d30:	89 04 24             	mov    %eax,(%esp)
80104d33:	e8 88 c8 ff ff       	call   801015c0 <iupdate>
80104d38:	e9 48 ff ff ff       	jmp    80104c85 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d3d:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
80104d44:	e8 17 b6 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d49:	c7 04 24 6a 74 10 80 	movl   $0x8010746a,(%esp)
80104d50:	e8 0b b6 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104d55:	c7 04 24 46 74 10 80 	movl   $0x80107446,(%esp)
80104d5c:	e8 ff b5 ff ff       	call   80100360 <panic>
80104d61:	eb 0d                	jmp    80104d70 <sys_open>
80104d63:	90                   	nop
80104d64:	90                   	nop
80104d65:	90                   	nop
80104d66:	90                   	nop
80104d67:	90                   	nop
80104d68:	90                   	nop
80104d69:	90                   	nop
80104d6a:	90                   	nop
80104d6b:	90                   	nop
80104d6c:	90                   	nop
80104d6d:	90                   	nop
80104d6e:	90                   	nop
80104d6f:	90                   	nop

80104d70 <sys_open>:

int
sys_open(void)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
80104d76:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d79:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d87:	e8 24 f8 ff ff       	call   801045b0 <argstr>
80104d8c:	85 c0                	test   %eax,%eax
80104d8e:	0f 88 d1 00 00 00    	js     80104e65 <sys_open+0xf5>
80104d94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104da2:	e8 79 f7 ff ff       	call   80104520 <argint>
80104da7:	85 c0                	test   %eax,%eax
80104da9:	0f 88 b6 00 00 00    	js     80104e65 <sys_open+0xf5>
    return -1;

  begin_op();
80104daf:	e8 2c dd ff ff       	call   80102ae0 <begin_op>

  if(omode & O_CREATE){
80104db4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104db8:	0f 85 82 00 00 00    	jne    80104e40 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dc1:	89 04 24             	mov    %eax,(%esp)
80104dc4:	e8 07 d1 ff ff       	call   80101ed0 <namei>
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	89 c6                	mov    %eax,%esi
80104dcd:	0f 84 8d 00 00 00    	je     80104e60 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104dd3:	89 04 24             	mov    %eax,(%esp)
80104dd6:	e8 a5 c8 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ddb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104de0:	0f 84 92 00 00 00    	je     80104e78 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104de6:	e8 55 bf ff ff       	call   80100d40 <filealloc>
80104deb:	85 c0                	test   %eax,%eax
80104ded:	89 c3                	mov    %eax,%ebx
80104def:	0f 84 93 00 00 00    	je     80104e88 <sys_open+0x118>
80104df5:	e8 86 f8 ff ff       	call   80104680 <fdalloc>
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	89 c7                	mov    %eax,%edi
80104dfe:	0f 88 94 00 00 00    	js     80104e98 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e04:	89 34 24             	mov    %esi,(%esp)
80104e07:	e8 54 c9 ff ff       	call   80101760 <iunlock>
  end_op();
80104e0c:	e8 3f dd ff ff       	call   80102b50 <end_op>

  f->type = FD_INODE;
80104e11:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e1a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e1d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e24:	89 c2                	mov    %eax,%edx
80104e26:	83 e2 01             	and    $0x1,%edx
80104e29:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e2c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e2e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e31:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e33:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e37:	83 c4 2c             	add    $0x2c,%esp
80104e3a:	5b                   	pop    %ebx
80104e3b:	5e                   	pop    %esi
80104e3c:	5f                   	pop    %edi
80104e3d:	5d                   	pop    %ebp
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e43:	31 c9                	xor    %ecx,%ecx
80104e45:	ba 02 00 00 00       	mov    $0x2,%edx
80104e4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e51:	e8 6a f8 ff ff       	call   801046c0 <create>
    if(ip == 0){
80104e56:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104e58:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e5a:	75 8a                	jne    80104de6 <sys_open+0x76>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104e60:	e8 eb dc ff ff       	call   80102b50 <end_op>
}
80104e65:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e6d:	5b                   	pop    %ebx
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret    
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	0f 84 63 ff ff ff    	je     80104de6 <sys_open+0x76>
80104e83:	90                   	nop
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104e88:	89 34 24             	mov    %esi,(%esp)
80104e8b:	e8 50 ca ff ff       	call   801018e0 <iunlockput>
80104e90:	eb ce                	jmp    80104e60 <sys_open+0xf0>
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104e98:	89 1c 24             	mov    %ebx,(%esp)
80104e9b:	e8 60 bf ff ff       	call   80100e00 <fileclose>
80104ea0:	eb e6                	jmp    80104e88 <sys_open+0x118>
80104ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104eb6:	e8 25 dc ff ff       	call   80102ae0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ec9:	e8 e2 f6 ff ff       	call   801045b0 <argstr>
80104ece:	85 c0                	test   %eax,%eax
80104ed0:	78 2e                	js     80104f00 <sys_mkdir+0x50>
80104ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed5:	31 c9                	xor    %ecx,%ecx
80104ed7:	ba 01 00 00 00       	mov    $0x1,%edx
80104edc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ee3:	e8 d8 f7 ff ff       	call   801046c0 <create>
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	74 14                	je     80104f00 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104eec:	89 04 24             	mov    %eax,(%esp)
80104eef:	e8 ec c9 ff ff       	call   801018e0 <iunlockput>
  end_op();
80104ef4:	e8 57 dc ff ff       	call   80102b50 <end_op>
  return 0;
80104ef9:	31 c0                	xor    %eax,%eax
}
80104efb:	c9                   	leave  
80104efc:	c3                   	ret    
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f00:	e8 4b dc ff ff       	call   80102b50 <end_op>
    return -1;
80104f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0a:	c9                   	leave  
80104f0b:	c3                   	ret    
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <sys_mknod>:

int
sys_mknod(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f16:	e8 c5 db ff ff       	call   80102ae0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f29:	e8 82 f6 ff ff       	call   801045b0 <argstr>
80104f2e:	85 c0                	test   %eax,%eax
80104f30:	78 5e                	js     80104f90 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f35:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f40:	e8 db f5 ff ff       	call   80104520 <argint>
  if((argstr(0, &path)) < 0 ||
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 47                	js     80104f90 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f50:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f57:	e8 c4 f5 ff ff       	call   80104520 <argint>
     argint(1, &major) < 0 ||
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	78 30                	js     80104f90 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f60:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104f64:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f69:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f6d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f73:	e8 48 f7 ff ff       	call   801046c0 <create>
80104f78:	85 c0                	test   %eax,%eax
80104f7a:	74 14                	je     80104f90 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f7c:	89 04 24             	mov    %eax,(%esp)
80104f7f:	e8 5c c9 ff ff       	call   801018e0 <iunlockput>
  end_op();
80104f84:	e8 c7 db ff ff       	call   80102b50 <end_op>
  return 0;
80104f89:	31 c0                	xor    %eax,%eax
}
80104f8b:	c9                   	leave  
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f90:	e8 bb db ff ff       	call   80102b50 <end_op>
    return -1;
80104f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f9a:	c9                   	leave  
80104f9b:	c3                   	ret    
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <sys_chdir>:

int
sys_chdir(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104fa8:	e8 c3 e6 ff ff       	call   80103670 <myproc>
80104fad:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104faf:	e8 2c db ff ff       	call   80102ae0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc2:	e8 e9 f5 ff ff       	call   801045b0 <argstr>
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	78 4a                	js     80105015 <sys_chdir+0x75>
80104fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fce:	89 04 24             	mov    %eax,(%esp)
80104fd1:	e8 fa ce ff ff       	call   80101ed0 <namei>
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	89 c3                	mov    %eax,%ebx
80104fda:	74 39                	je     80105015 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fdc:	89 04 24             	mov    %eax,(%esp)
80104fdf:	e8 9c c6 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80104fe4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104fe9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104fec:	75 22                	jne    80105010 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104fee:	e8 6d c7 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80104ff3:	8b 46 68             	mov    0x68(%esi),%eax
80104ff6:	89 04 24             	mov    %eax,(%esp)
80104ff9:	e8 a2 c7 ff ff       	call   801017a0 <iput>
  end_op();
80104ffe:	e8 4d db ff ff       	call   80102b50 <end_op>
  curproc->cwd = ip;
  return 0;
80105003:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105005:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105008:	83 c4 20             	add    $0x20,%esp
8010500b:	5b                   	pop    %ebx
8010500c:	5e                   	pop    %esi
8010500d:	5d                   	pop    %ebp
8010500e:	c3                   	ret    
8010500f:	90                   	nop
    iunlockput(ip);
80105010:	e8 cb c8 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105015:	e8 36 db ff ff       	call   80102b50 <end_op>
}
8010501a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010501d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105022:	5b                   	pop    %ebx
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_exec>:

int
sys_exec(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	53                   	push   %ebx
80105036:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010503c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105042:	89 44 24 04          	mov    %eax,0x4(%esp)
80105046:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010504d:	e8 5e f5 ff ff       	call   801045b0 <argstr>
80105052:	85 c0                	test   %eax,%eax
80105054:	0f 88 84 00 00 00    	js     801050de <sys_exec+0xae>
8010505a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105060:	89 44 24 04          	mov    %eax,0x4(%esp)
80105064:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010506b:	e8 b0 f4 ff ff       	call   80104520 <argint>
80105070:	85 c0                	test   %eax,%eax
80105072:	78 6a                	js     801050de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105074:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010507a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010507c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105083:	00 
80105084:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010508a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105091:	00 
80105092:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105098:	89 04 24             	mov    %eax,(%esp)
8010509b:	e8 d0 f1 ff ff       	call   80104270 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801050a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050ad:	89 04 24             	mov    %eax,(%esp)
801050b0:	e8 0b f4 ff ff       	call   801044c0 <fetchint>
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 25                	js     801050de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801050b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050bf:	85 c0                	test   %eax,%eax
801050c1:	74 2d                	je     801050f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050c7:	89 04 24             	mov    %eax,(%esp)
801050ca:	e8 11 f4 ff ff       	call   801044e0 <fetchstr>
801050cf:	85 c0                	test   %eax,%eax
801050d1:	78 0b                	js     801050de <sys_exec+0xae>
  for(i=0;; i++){
801050d3:	83 c3 01             	add    $0x1,%ebx
801050d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050d9:	83 fb 20             	cmp    $0x20,%ebx
801050dc:	75 c2                	jne    801050a0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801050de:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801050e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5f                   	pop    %edi
801050ec:	5d                   	pop    %ebp
801050ed:	c3                   	ret    
801050ee:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801050f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105100:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105107:	00 00 00 00 
  return exec(path, argv);
8010510b:	89 04 24             	mov    %eax,(%esp)
8010510e:	e8 8d b8 ff ff       	call   801009a0 <exec>
}
80105113:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5f                   	pop    %edi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_pipe>:

int
sys_pipe(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	53                   	push   %ebx
80105124:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105127:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010512a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105131:	00 
80105132:	89 44 24 04          	mov    %eax,0x4(%esp)
80105136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010513d:	e8 1e f4 ff ff       	call   80104560 <argptr>
80105142:	85 c0                	test   %eax,%eax
80105144:	78 6d                	js     801051b3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105146:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105149:	89 44 24 04          	mov    %eax,0x4(%esp)
8010514d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105150:	89 04 24             	mov    %eax,(%esp)
80105153:	e8 e8 df ff ff       	call   80103140 <pipealloc>
80105158:	85 c0                	test   %eax,%eax
8010515a:	78 57                	js     801051b3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515f:	e8 1c f5 ff ff       	call   80104680 <fdalloc>
80105164:	85 c0                	test   %eax,%eax
80105166:	89 c3                	mov    %eax,%ebx
80105168:	78 33                	js     8010519d <sys_pipe+0x7d>
8010516a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516d:	e8 0e f5 ff ff       	call   80104680 <fdalloc>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 1a                	js     80105190 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105176:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105179:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010517b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010517e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105181:	83 c4 24             	add    $0x24,%esp
  return 0;
80105184:	31 c0                	xor    %eax,%eax
}
80105186:	5b                   	pop    %ebx
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105190:	e8 db e4 ff ff       	call   80103670 <myproc>
80105195:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010519c:	00 
    fileclose(rf);
8010519d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a0:	89 04 24             	mov    %eax,(%esp)
801051a3:	e8 58 bc ff ff       	call   80100e00 <fileclose>
    fileclose(wf);
801051a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ab:	89 04 24             	mov    %eax,(%esp)
801051ae:	e8 4d bc ff ff       	call   80100e00 <fileclose>
}
801051b3:	83 c4 24             	add    $0x24,%esp
    return -1;
801051b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051bb:	5b                   	pop    %ebx
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801051c3:	5d                   	pop    %ebp
  return fork();
801051c4:	e9 57 e6 ff ff       	jmp    80103820 <fork>
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_exit>:

int
sys_exit(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801051d6:	e8 95 e8 ff ff       	call   80103a70 <exit>
  return 0;  // not reached
}
801051db:	31 c0                	xor    %eax,%eax
801051dd:	c9                   	leave  
801051de:	c3                   	ret    
801051df:	90                   	nop

801051e0 <sys_wait>:

int
sys_wait(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801051e3:	5d                   	pop    %ebp
  return wait();
801051e4:	e9 97 ea ff ff       	jmp    80103c80 <wait>
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_kill>:

int
sys_kill(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801051f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105204:	e8 17 f3 ff ff       	call   80104520 <argint>
80105209:	85 c0                	test   %eax,%eax
8010520b:	78 13                	js     80105220 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010520d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105210:	89 04 24             	mov    %eax,(%esp)
80105213:	e8 a8 eb ff ff       	call   80103dc0 <kill>
}
80105218:	c9                   	leave  
80105219:	c3                   	ret    
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <sys_getpid>:

int
sys_getpid(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105236:	e8 35 e4 ff ff       	call   80103670 <myproc>
8010523b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    

80105240 <sys_sbrk>:

int
sys_sbrk(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105247:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105255:	e8 c6 f2 ff ff       	call   80104520 <argint>
8010525a:	85 c0                	test   %eax,%eax
8010525c:	78 32                	js     80105290 <sys_sbrk+0x50>
    return -1;
  addr = PGROUNDDOWN(STACKTOP - myproc()->stackPages*PGSIZE - n);
8010525e:	e8 0d e4 ff ff       	call   80103670 <myproc>
80105263:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105266:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
8010526b:	8b 40 7c             	mov    0x7c(%eax),%eax
//  addr = myproc()->sz;
  if(growproc(n) < 0)
8010526e:	89 14 24             	mov    %edx,(%esp)
  addr = PGROUNDDOWN(STACKTOP - myproc()->stackPages*PGSIZE - n);
80105271:	c1 e0 0c             	shl    $0xc,%eax
80105274:	01 d0                	add    %edx,%eax
80105276:	29 c3                	sub    %eax,%ebx
  if(growproc(n) < 0)
80105278:	e8 33 e5 ff ff       	call   801037b0 <growproc>
  addr = PGROUNDDOWN(STACKTOP - myproc()->stackPages*PGSIZE - n);
8010527d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  if(growproc(n) < 0)
80105283:	85 c0                	test   %eax,%eax
80105285:	78 09                	js     80105290 <sys_sbrk+0x50>
    return -1;
  return addr;
80105287:	89 d8                	mov    %ebx,%eax
}
80105289:	83 c4 24             	add    $0x24,%esp
8010528c:	5b                   	pop    %ebx
8010528d:	5d                   	pop    %ebp
8010528e:	c3                   	ret    
8010528f:	90                   	nop
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105295:	eb f2                	jmp    80105289 <sys_sbrk+0x49>
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <sys_sleep>:

int
sys_sleep(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801052a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b5:	e8 66 f2 ff ff       	call   80104520 <argint>
801052ba:	85 c0                	test   %eax,%eax
801052bc:	78 7e                	js     8010533c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801052be:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801052c5:	e8 e6 ee ff ff       	call   801041b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801052ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801052cd:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801052d3:	85 d2                	test   %edx,%edx
801052d5:	75 29                	jne    80105300 <sys_sleep+0x60>
801052d7:	eb 4f                	jmp    80105328 <sys_sleep+0x88>
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801052e0:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
801052e7:	80 
801052e8:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
801052ef:	e8 dc e8 ff ff       	call   80103bd0 <sleep>
  while(ticks - ticks0 < n){
801052f4:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801052f9:	29 d8                	sub    %ebx,%eax
801052fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801052fe:	73 28                	jae    80105328 <sys_sleep+0x88>
    if(myproc()->killed){
80105300:	e8 6b e3 ff ff       	call   80103670 <myproc>
80105305:	8b 40 24             	mov    0x24(%eax),%eax
80105308:	85 c0                	test   %eax,%eax
8010530a:	74 d4                	je     801052e0 <sys_sleep+0x40>
      release(&tickslock);
8010530c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105313:	e8 08 ef ff ff       	call   80104220 <release>
      return -1;
80105318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010531d:	83 c4 24             	add    $0x24,%esp
80105320:	5b                   	pop    %ebx
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	90                   	nop
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105328:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010532f:	e8 ec ee ff ff       	call   80104220 <release>
}
80105334:	83 c4 24             	add    $0x24,%esp
  return 0;
80105337:	31 c0                	xor    %eax,%eax
}
80105339:	5b                   	pop    %ebx
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    
    return -1;
8010533c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105341:	eb da                	jmp    8010531d <sys_sleep+0x7d>
80105343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	53                   	push   %ebx
80105354:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105357:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010535e:	e8 4d ee ff ff       	call   801041b0 <acquire>
  xticks = ticks;
80105363:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105369:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105370:	e8 ab ee ff ff       	call   80104220 <release>
  return xticks;
}
80105375:	83 c4 14             	add    $0x14,%esp
80105378:	89 d8                	mov    %ebx,%eax
8010537a:	5b                   	pop    %ebx
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    

8010537d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010537d:	1e                   	push   %ds
  pushl %es
8010537e:	06                   	push   %es
  pushl %fs
8010537f:	0f a0                	push   %fs
  pushl %gs
80105381:	0f a8                	push   %gs
  pushal
80105383:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105384:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105388:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010538a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010538c:	54                   	push   %esp
  call trap
8010538d:	e8 de 00 00 00       	call   80105470 <trap>
  addl $4, %esp
80105392:	83 c4 04             	add    $0x4,%esp

80105395 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105395:	61                   	popa   
  popl %gs
80105396:	0f a9                	pop    %gs
  popl %fs
80105398:	0f a1                	pop    %fs
  popl %es
8010539a:	07                   	pop    %es
  popl %ds
8010539b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010539c:	83 c4 08             	add    $0x8,%esp
  iret
8010539f:	cf                   	iret   

801053a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801053a0:	31 c0                	xor    %eax,%eax
801053a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801053a8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801053af:	b9 08 00 00 00       	mov    $0x8,%ecx
801053b4:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
801053bb:	80 
801053bc:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
801053c3:	00 
801053c4:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
801053cb:	8e 
801053cc:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801053d3:	80 
801053d4:	c1 ea 10             	shr    $0x10,%edx
801053d7:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801053de:	80 
  for(i = 0; i < 256; i++)
801053df:	83 c0 01             	add    $0x1,%eax
801053e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801053e7:	75 bf                	jne    801053a8 <tvinit+0x8>
{
801053e9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801053ea:	ba 08 00 00 00       	mov    $0x8,%edx
{
801053ef:	89 e5                	mov    %esp,%ebp
801053f1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801053f4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801053f9:	c7 44 24 04 79 74 10 	movl   $0x80107479,0x4(%esp)
80105400:	80 
80105401:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105408:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010540f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105415:	c1 e8 10             	shr    $0x10,%eax
80105418:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
8010541f:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105426:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010542c:	e8 0f ec ff ff       	call   80104040 <initlock>
}
80105431:	c9                   	leave  
80105432:	c3                   	ret    
80105433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <idtinit>:

void
idtinit(void)
{
80105440:	55                   	push   %ebp
  pd[0] = size-1;
80105441:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105446:	89 e5                	mov    %esp,%ebp
80105448:	83 ec 10             	sub    $0x10,%esp
8010544b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010544f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105454:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105458:	c1 e8 10             	shr    $0x10,%eax
8010545b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010545f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105462:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
80105476:	83 ec 3c             	sub    $0x3c,%esp
80105479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint sp;  //lab3
  uint rcr; //lab3

  if(tf->trapno == T_SYSCALL){
8010547c:	8b 43 30             	mov    0x30(%ebx),%eax
8010547f:	83 f8 40             	cmp    $0x40,%eax
80105482:	0f 84 f0 01 00 00    	je     80105678 <trap+0x208>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105488:	83 e8 0e             	sub    $0xe,%eax
8010548b:	83 f8 31             	cmp    $0x31,%eax
8010548e:	77 08                	ja     80105498 <trap+0x28>
80105490:	ff 24 85 20 75 10 80 	jmp    *-0x7fef8ae0(,%eax,4)
80105497:	90                   	nop
    //print out if the allocation was successful
   // cprintf("allocuvm successful, number of pages:", myproc()->stackPages);
 break;
 //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105498:	e8 d3 e1 ff ff       	call   80103670 <myproc>
8010549d:	85 c0                	test   %eax,%eax
8010549f:	90                   	nop
801054a0:	0f 84 78 02 00 00    	je     8010571e <trap+0x2ae>
801054a6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801054aa:	0f 84 6e 02 00 00    	je     8010571e <trap+0x2ae>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801054b0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054b3:	8b 53 38             	mov    0x38(%ebx),%edx
801054b6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801054b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
801054bc:	e8 8f e1 ff ff       	call   80103650 <cpuid>
801054c1:	8b 73 30             	mov    0x30(%ebx),%esi
801054c4:	89 c7                	mov    %eax,%edi
801054c6:	8b 43 34             	mov    0x34(%ebx),%eax
801054c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801054cc:	e8 9f e1 ff ff       	call   80103670 <myproc>
801054d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801054d4:	e8 97 e1 ff ff       	call   80103670 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801054dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801054e0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054e3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801054e6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801054ea:	89 54 24 18          	mov    %edx,0x18(%esp)
801054ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801054f1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054f4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801054f8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801054fc:	89 54 24 10          	mov    %edx,0x10(%esp)
80105500:	8b 40 10             	mov    0x10(%eax),%eax
80105503:	c7 04 24 dc 74 10 80 	movl   $0x801074dc,(%esp)
8010550a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550e:	e8 3d b1 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105513:	e8 58 e1 ff ff       	call   80103670 <myproc>
80105518:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010551f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105520:	e8 4b e1 ff ff       	call   80103670 <myproc>
80105525:	85 c0                	test   %eax,%eax
80105527:	74 0c                	je     80105535 <trap+0xc5>
80105529:	e8 42 e1 ff ff       	call   80103670 <myproc>
8010552e:	8b 50 24             	mov    0x24(%eax),%edx
80105531:	85 d2                	test   %edx,%edx
80105533:	75 4b                	jne    80105580 <trap+0x110>
    exit();

 // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105535:	e8 36 e1 ff ff       	call   80103670 <myproc>
8010553a:	85 c0                	test   %eax,%eax
8010553c:	74 0d                	je     8010554b <trap+0xdb>
8010553e:	66 90                	xchg   %ax,%ax
80105540:	e8 2b e1 ff ff       	call   80103670 <myproc>
80105545:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105549:	74 4d                	je     80105598 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010554b:	e8 20 e1 ff ff       	call   80103670 <myproc>
80105550:	85 c0                	test   %eax,%eax
80105552:	74 1d                	je     80105571 <trap+0x101>
80105554:	e8 17 e1 ff ff       	call   80103670 <myproc>
80105559:	8b 40 24             	mov    0x24(%eax),%eax
8010555c:	85 c0                	test   %eax,%eax
8010555e:	74 11                	je     80105571 <trap+0x101>
80105560:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105564:	83 e0 03             	and    $0x3,%eax
80105567:	66 83 f8 03          	cmp    $0x3,%ax
8010556b:	0f 84 38 01 00 00    	je     801056a9 <trap+0x239>
    exit();
}
80105571:	83 c4 3c             	add    $0x3c,%esp
80105574:	5b                   	pop    %ebx
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105580:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105584:	83 e0 03             	and    $0x3,%eax
80105587:	66 83 f8 03          	cmp    $0x3,%ax
8010558b:	75 a8                	jne    80105535 <trap+0xc5>
    exit();
8010558d:	e8 de e4 ff ff       	call   80103a70 <exit>
80105592:	eb a1                	jmp    80105535 <trap+0xc5>
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105598:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a0:	75 a9                	jne    8010554b <trap+0xdb>
    yield();
801055a2:	e8 e9 e5 ff ff       	call   80103b90 <yield>
801055a7:	eb a2                	jmp    8010554b <trap+0xdb>
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055b0:	0f 20 d6             	mov    %cr2,%esi
    if( (rcr = rcr2() ) == -1){
801055b3:	83 fe ff             	cmp    $0xffffffff,%esi
801055b6:	0f 84 34 01 00 00    	je     801056f0 <trap+0x280>
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sp = allocuvm( myproc()->pgdir, rcr -PGSIZE, rcr )) == 0 ) {
801055c0:	e8 ab e0 ff ff       	call   80103670 <myproc>
801055c5:	89 74 24 08          	mov    %esi,0x8(%esp)
801055c9:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801055cf:	89 74 24 04          	mov    %esi,0x4(%esp)
801055d3:	8b 40 04             	mov    0x4(%eax),%eax
801055d6:	89 04 24             	mov    %eax,(%esp)
801055d9:	e8 12 12 00 00       	call   801067f0 <allocuvm>
801055de:	85 c0                	test   %eax,%eax
801055e0:	0f 84 22 01 00 00    	je     80105708 <trap+0x298>
    myproc()->stackPages +=1;
801055e6:	e8 85 e0 ff ff       	call   80103670 <myproc>
801055eb:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
801055ef:	90                   	nop
 break;
801055f0:	e9 2b ff ff ff       	jmp    80105520 <trap+0xb0>
801055f5:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801055f8:	e8 53 e0 ff ff       	call   80103650 <cpuid>
801055fd:	85 c0                	test   %eax,%eax
801055ff:	90                   	nop
80105600:	0f 84 ba 00 00 00    	je     801056c0 <trap+0x250>
    lapiceoi();
80105606:	e8 45 d1 ff ff       	call   80102750 <lapiceoi>
8010560b:	90                   	nop
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    break;
80105610:	e9 0b ff ff ff       	jmp    80105520 <trap+0xb0>
80105615:	8d 76 00             	lea    0x0(%esi),%esi
80105618:	90                   	nop
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105620:	e8 7b cf ff ff       	call   801025a0 <kbdintr>
    lapiceoi();
80105625:	e8 26 d1 ff ff       	call   80102750 <lapiceoi>
    break;
8010562a:	e9 f1 fe ff ff       	jmp    80105520 <trap+0xb0>
8010562f:	90                   	nop
    uartintr();
80105630:	e8 4b 02 00 00       	call   80105880 <uartintr>
    lapiceoi();
80105635:	e8 16 d1 ff ff       	call   80102750 <lapiceoi>
    break;
8010563a:	e9 e1 fe ff ff       	jmp    80105520 <trap+0xb0>
8010563f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105640:	8b 7b 38             	mov    0x38(%ebx),%edi
80105643:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105647:	e8 04 e0 ff ff       	call   80103650 <cpuid>
8010564c:	c7 04 24 84 74 10 80 	movl   $0x80107484,(%esp)
80105653:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105657:	89 74 24 08          	mov    %esi,0x8(%esp)
8010565b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565f:	e8 ec af ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105664:	e8 e7 d0 ff ff       	call   80102750 <lapiceoi>
    break;
80105669:	e9 b2 fe ff ff       	jmp    80105520 <trap+0xb0>
8010566e:	66 90                	xchg   %ax,%ax
    ideintr();
80105670:	e8 db c9 ff ff       	call   80102050 <ideintr>
80105675:	eb 8f                	jmp    80105606 <trap+0x196>
80105677:	90                   	nop
80105678:	90                   	nop
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105680:	e8 eb df ff ff       	call   80103670 <myproc>
80105685:	8b 70 24             	mov    0x24(%eax),%esi
80105688:	85 f6                	test   %esi,%esi
8010568a:	75 2c                	jne    801056b8 <trap+0x248>
    myproc()->tf = tf;
8010568c:	e8 df df ff ff       	call   80103670 <myproc>
80105691:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105694:	e8 77 ef ff ff       	call   80104610 <syscall>
    if(myproc()->killed)
80105699:	e8 d2 df ff ff       	call   80103670 <myproc>
8010569e:	8b 48 24             	mov    0x24(%eax),%ecx
801056a1:	85 c9                	test   %ecx,%ecx
801056a3:	0f 84 c8 fe ff ff    	je     80105571 <trap+0x101>
}
801056a9:	83 c4 3c             	add    $0x3c,%esp
801056ac:	5b                   	pop    %ebx
801056ad:	5e                   	pop    %esi
801056ae:	5f                   	pop    %edi
801056af:	5d                   	pop    %ebp
      exit();
801056b0:	e9 bb e3 ff ff       	jmp    80103a70 <exit>
801056b5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801056b8:	e8 b3 e3 ff ff       	call   80103a70 <exit>
801056bd:	eb cd                	jmp    8010568c <trap+0x21c>
801056bf:	90                   	nop
      acquire(&tickslock);
801056c0:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801056c7:	e8 e4 ea ff ff       	call   801041b0 <acquire>
      wakeup(&ticks);
801056cc:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
801056d3:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
801056da:	e8 81 e6 ff ff       	call   80103d60 <wakeup>
      release(&tickslock);
801056df:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801056e6:	e8 35 eb ff ff       	call   80104220 <release>
801056eb:	e9 16 ff ff ff       	jmp    80105606 <trap+0x196>
      myproc()->killed = -1;
801056f0:	e8 7b df ff ff       	call   80103670 <myproc>
801056f5:	c7 40 24 ff ff ff ff 	movl   $0xffffffff,0x24(%eax)
      break;
801056fc:	e9 1f fe ff ff       	jmp    80105520 <trap+0xb0>
80105701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     myproc()->killed = 1;
80105708:	e8 63 df ff ff       	call   80103670 <myproc>
8010570d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
     exit();
80105714:	e8 57 e3 ff ff       	call   80103a70 <exit>
80105719:	e9 c8 fe ff ff       	jmp    801055e6 <trap+0x176>
8010571e:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105721:	8b 73 38             	mov    0x38(%ebx),%esi
80105724:	e8 27 df ff ff       	call   80103650 <cpuid>
80105729:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010572d:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105731:	89 44 24 08          	mov    %eax,0x8(%esp)
80105735:	8b 43 30             	mov    0x30(%ebx),%eax
80105738:	c7 04 24 a8 74 10 80 	movl   $0x801074a8,(%esp)
8010573f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105743:	e8 08 af ff ff       	call   80100650 <cprintf>
      panic("trap");
80105748:	c7 04 24 7e 74 10 80 	movl   $0x8010747e,(%esp)
8010574f:	e8 0c ac ff ff       	call   80100360 <panic>
80105754:	66 90                	xchg   %ax,%ax
80105756:	66 90                	xchg   %ax,%ax
80105758:	66 90                	xchg   %ax,%ax
8010575a:	66 90                	xchg   %ax,%ax
8010575c:	66 90                	xchg   %ax,%ax
8010575e:	66 90                	xchg   %ax,%ax

80105760 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105760:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105765:	55                   	push   %ebp
80105766:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105768:	85 c0                	test   %eax,%eax
8010576a:	74 14                	je     80105780 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010576c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105771:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105772:	a8 01                	test   $0x1,%al
80105774:	74 0a                	je     80105780 <uartgetc+0x20>
80105776:	b2 f8                	mov    $0xf8,%dl
80105778:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105779:	0f b6 c0             	movzbl %al,%eax
}
8010577c:	5d                   	pop    %ebp
8010577d:	c3                   	ret    
8010577e:	66 90                	xchg   %ax,%ax
    return -1;
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105785:	5d                   	pop    %ebp
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <uartputc>:
  if(!uart)
80105790:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105795:	85 c0                	test   %eax,%eax
80105797:	74 3f                	je     801057d8 <uartputc+0x48>
{
80105799:	55                   	push   %ebp
8010579a:	89 e5                	mov    %esp,%ebp
8010579c:	56                   	push   %esi
8010579d:	be fd 03 00 00       	mov    $0x3fd,%esi
801057a2:	53                   	push   %ebx
  if(!uart)
801057a3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801057a8:	83 ec 10             	sub    $0x10,%esp
801057ab:	eb 14                	jmp    801057c1 <uartputc+0x31>
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801057b0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801057b7:	e8 b4 cf ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801057bc:	83 eb 01             	sub    $0x1,%ebx
801057bf:	74 07                	je     801057c8 <uartputc+0x38>
801057c1:	89 f2                	mov    %esi,%edx
801057c3:	ec                   	in     (%dx),%al
801057c4:	a8 20                	test   $0x20,%al
801057c6:	74 e8                	je     801057b0 <uartputc+0x20>
  outb(COM1+0, c);
801057c8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801057cc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057d1:	ee                   	out    %al,(%dx)
}
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	5b                   	pop    %ebx
801057d6:	5e                   	pop    %esi
801057d7:	5d                   	pop    %ebp
801057d8:	f3 c3                	repz ret 
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057e0 <uartinit>:
{
801057e0:	55                   	push   %ebp
801057e1:	31 c9                	xor    %ecx,%ecx
801057e3:	89 e5                	mov    %esp,%ebp
801057e5:	89 c8                	mov    %ecx,%eax
801057e7:	57                   	push   %edi
801057e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801057ed:	56                   	push   %esi
801057ee:	89 fa                	mov    %edi,%edx
801057f0:	53                   	push   %ebx
801057f1:	83 ec 1c             	sub    $0x1c,%esp
801057f4:	ee                   	out    %al,(%dx)
801057f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801057fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801057ff:	89 f2                	mov    %esi,%edx
80105801:	ee                   	out    %al,(%dx)
80105802:	b8 0c 00 00 00       	mov    $0xc,%eax
80105807:	b2 f8                	mov    $0xf8,%dl
80105809:	ee                   	out    %al,(%dx)
8010580a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010580f:	89 c8                	mov    %ecx,%eax
80105811:	89 da                	mov    %ebx,%edx
80105813:	ee                   	out    %al,(%dx)
80105814:	b8 03 00 00 00       	mov    $0x3,%eax
80105819:	89 f2                	mov    %esi,%edx
8010581b:	ee                   	out    %al,(%dx)
8010581c:	b2 fc                	mov    $0xfc,%dl
8010581e:	89 c8                	mov    %ecx,%eax
80105820:	ee                   	out    %al,(%dx)
80105821:	b8 01 00 00 00       	mov    $0x1,%eax
80105826:	89 da                	mov    %ebx,%edx
80105828:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105829:	b2 fd                	mov    $0xfd,%dl
8010582b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010582c:	3c ff                	cmp    $0xff,%al
8010582e:	74 42                	je     80105872 <uartinit+0x92>
  uart = 1;
80105830:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105837:	00 00 00 
8010583a:	89 fa                	mov    %edi,%edx
8010583c:	ec                   	in     (%dx),%al
8010583d:	b2 f8                	mov    $0xf8,%dl
8010583f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105840:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105847:	00 
  for(p="xv6...\n"; *p; p++)
80105848:	bb e8 75 10 80       	mov    $0x801075e8,%ebx
  ioapicenable(IRQ_COM1, 0);
8010584d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105854:	e8 27 ca ff ff       	call   80102280 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105859:	b8 78 00 00 00       	mov    $0x78,%eax
8010585e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105860:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105863:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105866:	e8 25 ff ff ff       	call   80105790 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010586b:	0f be 03             	movsbl (%ebx),%eax
8010586e:	84 c0                	test   %al,%al
80105870:	75 ee                	jne    80105860 <uartinit+0x80>
}
80105872:	83 c4 1c             	add    $0x1c,%esp
80105875:	5b                   	pop    %ebx
80105876:	5e                   	pop    %esi
80105877:	5f                   	pop    %edi
80105878:	5d                   	pop    %ebp
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <uartintr>:

void
uartintr(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105886:	c7 04 24 60 57 10 80 	movl   $0x80105760,(%esp)
8010588d:	e8 1e af ff ff       	call   801007b0 <consoleintr>
}
80105892:	c9                   	leave  
80105893:	c3                   	ret    

80105894 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105894:	6a 00                	push   $0x0
  pushl $0
80105896:	6a 00                	push   $0x0
  jmp alltraps
80105898:	e9 e0 fa ff ff       	jmp    8010537d <alltraps>

8010589d <vector1>:
.globl vector1
vector1:
  pushl $0
8010589d:	6a 00                	push   $0x0
  pushl $1
8010589f:	6a 01                	push   $0x1
  jmp alltraps
801058a1:	e9 d7 fa ff ff       	jmp    8010537d <alltraps>

801058a6 <vector2>:
.globl vector2
vector2:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $2
801058a8:	6a 02                	push   $0x2
  jmp alltraps
801058aa:	e9 ce fa ff ff       	jmp    8010537d <alltraps>

801058af <vector3>:
.globl vector3
vector3:
  pushl $0
801058af:	6a 00                	push   $0x0
  pushl $3
801058b1:	6a 03                	push   $0x3
  jmp alltraps
801058b3:	e9 c5 fa ff ff       	jmp    8010537d <alltraps>

801058b8 <vector4>:
.globl vector4
vector4:
  pushl $0
801058b8:	6a 00                	push   $0x0
  pushl $4
801058ba:	6a 04                	push   $0x4
  jmp alltraps
801058bc:	e9 bc fa ff ff       	jmp    8010537d <alltraps>

801058c1 <vector5>:
.globl vector5
vector5:
  pushl $0
801058c1:	6a 00                	push   $0x0
  pushl $5
801058c3:	6a 05                	push   $0x5
  jmp alltraps
801058c5:	e9 b3 fa ff ff       	jmp    8010537d <alltraps>

801058ca <vector6>:
.globl vector6
vector6:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $6
801058cc:	6a 06                	push   $0x6
  jmp alltraps
801058ce:	e9 aa fa ff ff       	jmp    8010537d <alltraps>

801058d3 <vector7>:
.globl vector7
vector7:
  pushl $0
801058d3:	6a 00                	push   $0x0
  pushl $7
801058d5:	6a 07                	push   $0x7
  jmp alltraps
801058d7:	e9 a1 fa ff ff       	jmp    8010537d <alltraps>

801058dc <vector8>:
.globl vector8
vector8:
  pushl $8
801058dc:	6a 08                	push   $0x8
  jmp alltraps
801058de:	e9 9a fa ff ff       	jmp    8010537d <alltraps>

801058e3 <vector9>:
.globl vector9
vector9:
  pushl $0
801058e3:	6a 00                	push   $0x0
  pushl $9
801058e5:	6a 09                	push   $0x9
  jmp alltraps
801058e7:	e9 91 fa ff ff       	jmp    8010537d <alltraps>

801058ec <vector10>:
.globl vector10
vector10:
  pushl $10
801058ec:	6a 0a                	push   $0xa
  jmp alltraps
801058ee:	e9 8a fa ff ff       	jmp    8010537d <alltraps>

801058f3 <vector11>:
.globl vector11
vector11:
  pushl $11
801058f3:	6a 0b                	push   $0xb
  jmp alltraps
801058f5:	e9 83 fa ff ff       	jmp    8010537d <alltraps>

801058fa <vector12>:
.globl vector12
vector12:
  pushl $12
801058fa:	6a 0c                	push   $0xc
  jmp alltraps
801058fc:	e9 7c fa ff ff       	jmp    8010537d <alltraps>

80105901 <vector13>:
.globl vector13
vector13:
  pushl $13
80105901:	6a 0d                	push   $0xd
  jmp alltraps
80105903:	e9 75 fa ff ff       	jmp    8010537d <alltraps>

80105908 <vector14>:
.globl vector14
vector14:
  pushl $14
80105908:	6a 0e                	push   $0xe
  jmp alltraps
8010590a:	e9 6e fa ff ff       	jmp    8010537d <alltraps>

8010590f <vector15>:
.globl vector15
vector15:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $15
80105911:	6a 0f                	push   $0xf
  jmp alltraps
80105913:	e9 65 fa ff ff       	jmp    8010537d <alltraps>

80105918 <vector16>:
.globl vector16
vector16:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $16
8010591a:	6a 10                	push   $0x10
  jmp alltraps
8010591c:	e9 5c fa ff ff       	jmp    8010537d <alltraps>

80105921 <vector17>:
.globl vector17
vector17:
  pushl $17
80105921:	6a 11                	push   $0x11
  jmp alltraps
80105923:	e9 55 fa ff ff       	jmp    8010537d <alltraps>

80105928 <vector18>:
.globl vector18
vector18:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $18
8010592a:	6a 12                	push   $0x12
  jmp alltraps
8010592c:	e9 4c fa ff ff       	jmp    8010537d <alltraps>

80105931 <vector19>:
.globl vector19
vector19:
  pushl $0
80105931:	6a 00                	push   $0x0
  pushl $19
80105933:	6a 13                	push   $0x13
  jmp alltraps
80105935:	e9 43 fa ff ff       	jmp    8010537d <alltraps>

8010593a <vector20>:
.globl vector20
vector20:
  pushl $0
8010593a:	6a 00                	push   $0x0
  pushl $20
8010593c:	6a 14                	push   $0x14
  jmp alltraps
8010593e:	e9 3a fa ff ff       	jmp    8010537d <alltraps>

80105943 <vector21>:
.globl vector21
vector21:
  pushl $0
80105943:	6a 00                	push   $0x0
  pushl $21
80105945:	6a 15                	push   $0x15
  jmp alltraps
80105947:	e9 31 fa ff ff       	jmp    8010537d <alltraps>

8010594c <vector22>:
.globl vector22
vector22:
  pushl $0
8010594c:	6a 00                	push   $0x0
  pushl $22
8010594e:	6a 16                	push   $0x16
  jmp alltraps
80105950:	e9 28 fa ff ff       	jmp    8010537d <alltraps>

80105955 <vector23>:
.globl vector23
vector23:
  pushl $0
80105955:	6a 00                	push   $0x0
  pushl $23
80105957:	6a 17                	push   $0x17
  jmp alltraps
80105959:	e9 1f fa ff ff       	jmp    8010537d <alltraps>

8010595e <vector24>:
.globl vector24
vector24:
  pushl $0
8010595e:	6a 00                	push   $0x0
  pushl $24
80105960:	6a 18                	push   $0x18
  jmp alltraps
80105962:	e9 16 fa ff ff       	jmp    8010537d <alltraps>

80105967 <vector25>:
.globl vector25
vector25:
  pushl $0
80105967:	6a 00                	push   $0x0
  pushl $25
80105969:	6a 19                	push   $0x19
  jmp alltraps
8010596b:	e9 0d fa ff ff       	jmp    8010537d <alltraps>

80105970 <vector26>:
.globl vector26
vector26:
  pushl $0
80105970:	6a 00                	push   $0x0
  pushl $26
80105972:	6a 1a                	push   $0x1a
  jmp alltraps
80105974:	e9 04 fa ff ff       	jmp    8010537d <alltraps>

80105979 <vector27>:
.globl vector27
vector27:
  pushl $0
80105979:	6a 00                	push   $0x0
  pushl $27
8010597b:	6a 1b                	push   $0x1b
  jmp alltraps
8010597d:	e9 fb f9 ff ff       	jmp    8010537d <alltraps>

80105982 <vector28>:
.globl vector28
vector28:
  pushl $0
80105982:	6a 00                	push   $0x0
  pushl $28
80105984:	6a 1c                	push   $0x1c
  jmp alltraps
80105986:	e9 f2 f9 ff ff       	jmp    8010537d <alltraps>

8010598b <vector29>:
.globl vector29
vector29:
  pushl $0
8010598b:	6a 00                	push   $0x0
  pushl $29
8010598d:	6a 1d                	push   $0x1d
  jmp alltraps
8010598f:	e9 e9 f9 ff ff       	jmp    8010537d <alltraps>

80105994 <vector30>:
.globl vector30
vector30:
  pushl $0
80105994:	6a 00                	push   $0x0
  pushl $30
80105996:	6a 1e                	push   $0x1e
  jmp alltraps
80105998:	e9 e0 f9 ff ff       	jmp    8010537d <alltraps>

8010599d <vector31>:
.globl vector31
vector31:
  pushl $0
8010599d:	6a 00                	push   $0x0
  pushl $31
8010599f:	6a 1f                	push   $0x1f
  jmp alltraps
801059a1:	e9 d7 f9 ff ff       	jmp    8010537d <alltraps>

801059a6 <vector32>:
.globl vector32
vector32:
  pushl $0
801059a6:	6a 00                	push   $0x0
  pushl $32
801059a8:	6a 20                	push   $0x20
  jmp alltraps
801059aa:	e9 ce f9 ff ff       	jmp    8010537d <alltraps>

801059af <vector33>:
.globl vector33
vector33:
  pushl $0
801059af:	6a 00                	push   $0x0
  pushl $33
801059b1:	6a 21                	push   $0x21
  jmp alltraps
801059b3:	e9 c5 f9 ff ff       	jmp    8010537d <alltraps>

801059b8 <vector34>:
.globl vector34
vector34:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $34
801059ba:	6a 22                	push   $0x22
  jmp alltraps
801059bc:	e9 bc f9 ff ff       	jmp    8010537d <alltraps>

801059c1 <vector35>:
.globl vector35
vector35:
  pushl $0
801059c1:	6a 00                	push   $0x0
  pushl $35
801059c3:	6a 23                	push   $0x23
  jmp alltraps
801059c5:	e9 b3 f9 ff ff       	jmp    8010537d <alltraps>

801059ca <vector36>:
.globl vector36
vector36:
  pushl $0
801059ca:	6a 00                	push   $0x0
  pushl $36
801059cc:	6a 24                	push   $0x24
  jmp alltraps
801059ce:	e9 aa f9 ff ff       	jmp    8010537d <alltraps>

801059d3 <vector37>:
.globl vector37
vector37:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $37
801059d5:	6a 25                	push   $0x25
  jmp alltraps
801059d7:	e9 a1 f9 ff ff       	jmp    8010537d <alltraps>

801059dc <vector38>:
.globl vector38
vector38:
  pushl $0
801059dc:	6a 00                	push   $0x0
  pushl $38
801059de:	6a 26                	push   $0x26
  jmp alltraps
801059e0:	e9 98 f9 ff ff       	jmp    8010537d <alltraps>

801059e5 <vector39>:
.globl vector39
vector39:
  pushl $0
801059e5:	6a 00                	push   $0x0
  pushl $39
801059e7:	6a 27                	push   $0x27
  jmp alltraps
801059e9:	e9 8f f9 ff ff       	jmp    8010537d <alltraps>

801059ee <vector40>:
.globl vector40
vector40:
  pushl $0
801059ee:	6a 00                	push   $0x0
  pushl $40
801059f0:	6a 28                	push   $0x28
  jmp alltraps
801059f2:	e9 86 f9 ff ff       	jmp    8010537d <alltraps>

801059f7 <vector41>:
.globl vector41
vector41:
  pushl $0
801059f7:	6a 00                	push   $0x0
  pushl $41
801059f9:	6a 29                	push   $0x29
  jmp alltraps
801059fb:	e9 7d f9 ff ff       	jmp    8010537d <alltraps>

80105a00 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a00:	6a 00                	push   $0x0
  pushl $42
80105a02:	6a 2a                	push   $0x2a
  jmp alltraps
80105a04:	e9 74 f9 ff ff       	jmp    8010537d <alltraps>

80105a09 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a09:	6a 00                	push   $0x0
  pushl $43
80105a0b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a0d:	e9 6b f9 ff ff       	jmp    8010537d <alltraps>

80105a12 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a12:	6a 00                	push   $0x0
  pushl $44
80105a14:	6a 2c                	push   $0x2c
  jmp alltraps
80105a16:	e9 62 f9 ff ff       	jmp    8010537d <alltraps>

80105a1b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a1b:	6a 00                	push   $0x0
  pushl $45
80105a1d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a1f:	e9 59 f9 ff ff       	jmp    8010537d <alltraps>

80105a24 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a24:	6a 00                	push   $0x0
  pushl $46
80105a26:	6a 2e                	push   $0x2e
  jmp alltraps
80105a28:	e9 50 f9 ff ff       	jmp    8010537d <alltraps>

80105a2d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a2d:	6a 00                	push   $0x0
  pushl $47
80105a2f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a31:	e9 47 f9 ff ff       	jmp    8010537d <alltraps>

80105a36 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a36:	6a 00                	push   $0x0
  pushl $48
80105a38:	6a 30                	push   $0x30
  jmp alltraps
80105a3a:	e9 3e f9 ff ff       	jmp    8010537d <alltraps>

80105a3f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a3f:	6a 00                	push   $0x0
  pushl $49
80105a41:	6a 31                	push   $0x31
  jmp alltraps
80105a43:	e9 35 f9 ff ff       	jmp    8010537d <alltraps>

80105a48 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a48:	6a 00                	push   $0x0
  pushl $50
80105a4a:	6a 32                	push   $0x32
  jmp alltraps
80105a4c:	e9 2c f9 ff ff       	jmp    8010537d <alltraps>

80105a51 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a51:	6a 00                	push   $0x0
  pushl $51
80105a53:	6a 33                	push   $0x33
  jmp alltraps
80105a55:	e9 23 f9 ff ff       	jmp    8010537d <alltraps>

80105a5a <vector52>:
.globl vector52
vector52:
  pushl $0
80105a5a:	6a 00                	push   $0x0
  pushl $52
80105a5c:	6a 34                	push   $0x34
  jmp alltraps
80105a5e:	e9 1a f9 ff ff       	jmp    8010537d <alltraps>

80105a63 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a63:	6a 00                	push   $0x0
  pushl $53
80105a65:	6a 35                	push   $0x35
  jmp alltraps
80105a67:	e9 11 f9 ff ff       	jmp    8010537d <alltraps>

80105a6c <vector54>:
.globl vector54
vector54:
  pushl $0
80105a6c:	6a 00                	push   $0x0
  pushl $54
80105a6e:	6a 36                	push   $0x36
  jmp alltraps
80105a70:	e9 08 f9 ff ff       	jmp    8010537d <alltraps>

80105a75 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a75:	6a 00                	push   $0x0
  pushl $55
80105a77:	6a 37                	push   $0x37
  jmp alltraps
80105a79:	e9 ff f8 ff ff       	jmp    8010537d <alltraps>

80105a7e <vector56>:
.globl vector56
vector56:
  pushl $0
80105a7e:	6a 00                	push   $0x0
  pushl $56
80105a80:	6a 38                	push   $0x38
  jmp alltraps
80105a82:	e9 f6 f8 ff ff       	jmp    8010537d <alltraps>

80105a87 <vector57>:
.globl vector57
vector57:
  pushl $0
80105a87:	6a 00                	push   $0x0
  pushl $57
80105a89:	6a 39                	push   $0x39
  jmp alltraps
80105a8b:	e9 ed f8 ff ff       	jmp    8010537d <alltraps>

80105a90 <vector58>:
.globl vector58
vector58:
  pushl $0
80105a90:	6a 00                	push   $0x0
  pushl $58
80105a92:	6a 3a                	push   $0x3a
  jmp alltraps
80105a94:	e9 e4 f8 ff ff       	jmp    8010537d <alltraps>

80105a99 <vector59>:
.globl vector59
vector59:
  pushl $0
80105a99:	6a 00                	push   $0x0
  pushl $59
80105a9b:	6a 3b                	push   $0x3b
  jmp alltraps
80105a9d:	e9 db f8 ff ff       	jmp    8010537d <alltraps>

80105aa2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105aa2:	6a 00                	push   $0x0
  pushl $60
80105aa4:	6a 3c                	push   $0x3c
  jmp alltraps
80105aa6:	e9 d2 f8 ff ff       	jmp    8010537d <alltraps>

80105aab <vector61>:
.globl vector61
vector61:
  pushl $0
80105aab:	6a 00                	push   $0x0
  pushl $61
80105aad:	6a 3d                	push   $0x3d
  jmp alltraps
80105aaf:	e9 c9 f8 ff ff       	jmp    8010537d <alltraps>

80105ab4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ab4:	6a 00                	push   $0x0
  pushl $62
80105ab6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ab8:	e9 c0 f8 ff ff       	jmp    8010537d <alltraps>

80105abd <vector63>:
.globl vector63
vector63:
  pushl $0
80105abd:	6a 00                	push   $0x0
  pushl $63
80105abf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ac1:	e9 b7 f8 ff ff       	jmp    8010537d <alltraps>

80105ac6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ac6:	6a 00                	push   $0x0
  pushl $64
80105ac8:	6a 40                	push   $0x40
  jmp alltraps
80105aca:	e9 ae f8 ff ff       	jmp    8010537d <alltraps>

80105acf <vector65>:
.globl vector65
vector65:
  pushl $0
80105acf:	6a 00                	push   $0x0
  pushl $65
80105ad1:	6a 41                	push   $0x41
  jmp alltraps
80105ad3:	e9 a5 f8 ff ff       	jmp    8010537d <alltraps>

80105ad8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ad8:	6a 00                	push   $0x0
  pushl $66
80105ada:	6a 42                	push   $0x42
  jmp alltraps
80105adc:	e9 9c f8 ff ff       	jmp    8010537d <alltraps>

80105ae1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105ae1:	6a 00                	push   $0x0
  pushl $67
80105ae3:	6a 43                	push   $0x43
  jmp alltraps
80105ae5:	e9 93 f8 ff ff       	jmp    8010537d <alltraps>

80105aea <vector68>:
.globl vector68
vector68:
  pushl $0
80105aea:	6a 00                	push   $0x0
  pushl $68
80105aec:	6a 44                	push   $0x44
  jmp alltraps
80105aee:	e9 8a f8 ff ff       	jmp    8010537d <alltraps>

80105af3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105af3:	6a 00                	push   $0x0
  pushl $69
80105af5:	6a 45                	push   $0x45
  jmp alltraps
80105af7:	e9 81 f8 ff ff       	jmp    8010537d <alltraps>

80105afc <vector70>:
.globl vector70
vector70:
  pushl $0
80105afc:	6a 00                	push   $0x0
  pushl $70
80105afe:	6a 46                	push   $0x46
  jmp alltraps
80105b00:	e9 78 f8 ff ff       	jmp    8010537d <alltraps>

80105b05 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b05:	6a 00                	push   $0x0
  pushl $71
80105b07:	6a 47                	push   $0x47
  jmp alltraps
80105b09:	e9 6f f8 ff ff       	jmp    8010537d <alltraps>

80105b0e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b0e:	6a 00                	push   $0x0
  pushl $72
80105b10:	6a 48                	push   $0x48
  jmp alltraps
80105b12:	e9 66 f8 ff ff       	jmp    8010537d <alltraps>

80105b17 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b17:	6a 00                	push   $0x0
  pushl $73
80105b19:	6a 49                	push   $0x49
  jmp alltraps
80105b1b:	e9 5d f8 ff ff       	jmp    8010537d <alltraps>

80105b20 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b20:	6a 00                	push   $0x0
  pushl $74
80105b22:	6a 4a                	push   $0x4a
  jmp alltraps
80105b24:	e9 54 f8 ff ff       	jmp    8010537d <alltraps>

80105b29 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b29:	6a 00                	push   $0x0
  pushl $75
80105b2b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b2d:	e9 4b f8 ff ff       	jmp    8010537d <alltraps>

80105b32 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b32:	6a 00                	push   $0x0
  pushl $76
80105b34:	6a 4c                	push   $0x4c
  jmp alltraps
80105b36:	e9 42 f8 ff ff       	jmp    8010537d <alltraps>

80105b3b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b3b:	6a 00                	push   $0x0
  pushl $77
80105b3d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b3f:	e9 39 f8 ff ff       	jmp    8010537d <alltraps>

80105b44 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b44:	6a 00                	push   $0x0
  pushl $78
80105b46:	6a 4e                	push   $0x4e
  jmp alltraps
80105b48:	e9 30 f8 ff ff       	jmp    8010537d <alltraps>

80105b4d <vector79>:
.globl vector79
vector79:
  pushl $0
80105b4d:	6a 00                	push   $0x0
  pushl $79
80105b4f:	6a 4f                	push   $0x4f
  jmp alltraps
80105b51:	e9 27 f8 ff ff       	jmp    8010537d <alltraps>

80105b56 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b56:	6a 00                	push   $0x0
  pushl $80
80105b58:	6a 50                	push   $0x50
  jmp alltraps
80105b5a:	e9 1e f8 ff ff       	jmp    8010537d <alltraps>

80105b5f <vector81>:
.globl vector81
vector81:
  pushl $0
80105b5f:	6a 00                	push   $0x0
  pushl $81
80105b61:	6a 51                	push   $0x51
  jmp alltraps
80105b63:	e9 15 f8 ff ff       	jmp    8010537d <alltraps>

80105b68 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b68:	6a 00                	push   $0x0
  pushl $82
80105b6a:	6a 52                	push   $0x52
  jmp alltraps
80105b6c:	e9 0c f8 ff ff       	jmp    8010537d <alltraps>

80105b71 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b71:	6a 00                	push   $0x0
  pushl $83
80105b73:	6a 53                	push   $0x53
  jmp alltraps
80105b75:	e9 03 f8 ff ff       	jmp    8010537d <alltraps>

80105b7a <vector84>:
.globl vector84
vector84:
  pushl $0
80105b7a:	6a 00                	push   $0x0
  pushl $84
80105b7c:	6a 54                	push   $0x54
  jmp alltraps
80105b7e:	e9 fa f7 ff ff       	jmp    8010537d <alltraps>

80105b83 <vector85>:
.globl vector85
vector85:
  pushl $0
80105b83:	6a 00                	push   $0x0
  pushl $85
80105b85:	6a 55                	push   $0x55
  jmp alltraps
80105b87:	e9 f1 f7 ff ff       	jmp    8010537d <alltraps>

80105b8c <vector86>:
.globl vector86
vector86:
  pushl $0
80105b8c:	6a 00                	push   $0x0
  pushl $86
80105b8e:	6a 56                	push   $0x56
  jmp alltraps
80105b90:	e9 e8 f7 ff ff       	jmp    8010537d <alltraps>

80105b95 <vector87>:
.globl vector87
vector87:
  pushl $0
80105b95:	6a 00                	push   $0x0
  pushl $87
80105b97:	6a 57                	push   $0x57
  jmp alltraps
80105b99:	e9 df f7 ff ff       	jmp    8010537d <alltraps>

80105b9e <vector88>:
.globl vector88
vector88:
  pushl $0
80105b9e:	6a 00                	push   $0x0
  pushl $88
80105ba0:	6a 58                	push   $0x58
  jmp alltraps
80105ba2:	e9 d6 f7 ff ff       	jmp    8010537d <alltraps>

80105ba7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ba7:	6a 00                	push   $0x0
  pushl $89
80105ba9:	6a 59                	push   $0x59
  jmp alltraps
80105bab:	e9 cd f7 ff ff       	jmp    8010537d <alltraps>

80105bb0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105bb0:	6a 00                	push   $0x0
  pushl $90
80105bb2:	6a 5a                	push   $0x5a
  jmp alltraps
80105bb4:	e9 c4 f7 ff ff       	jmp    8010537d <alltraps>

80105bb9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105bb9:	6a 00                	push   $0x0
  pushl $91
80105bbb:	6a 5b                	push   $0x5b
  jmp alltraps
80105bbd:	e9 bb f7 ff ff       	jmp    8010537d <alltraps>

80105bc2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105bc2:	6a 00                	push   $0x0
  pushl $92
80105bc4:	6a 5c                	push   $0x5c
  jmp alltraps
80105bc6:	e9 b2 f7 ff ff       	jmp    8010537d <alltraps>

80105bcb <vector93>:
.globl vector93
vector93:
  pushl $0
80105bcb:	6a 00                	push   $0x0
  pushl $93
80105bcd:	6a 5d                	push   $0x5d
  jmp alltraps
80105bcf:	e9 a9 f7 ff ff       	jmp    8010537d <alltraps>

80105bd4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105bd4:	6a 00                	push   $0x0
  pushl $94
80105bd6:	6a 5e                	push   $0x5e
  jmp alltraps
80105bd8:	e9 a0 f7 ff ff       	jmp    8010537d <alltraps>

80105bdd <vector95>:
.globl vector95
vector95:
  pushl $0
80105bdd:	6a 00                	push   $0x0
  pushl $95
80105bdf:	6a 5f                	push   $0x5f
  jmp alltraps
80105be1:	e9 97 f7 ff ff       	jmp    8010537d <alltraps>

80105be6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105be6:	6a 00                	push   $0x0
  pushl $96
80105be8:	6a 60                	push   $0x60
  jmp alltraps
80105bea:	e9 8e f7 ff ff       	jmp    8010537d <alltraps>

80105bef <vector97>:
.globl vector97
vector97:
  pushl $0
80105bef:	6a 00                	push   $0x0
  pushl $97
80105bf1:	6a 61                	push   $0x61
  jmp alltraps
80105bf3:	e9 85 f7 ff ff       	jmp    8010537d <alltraps>

80105bf8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105bf8:	6a 00                	push   $0x0
  pushl $98
80105bfa:	6a 62                	push   $0x62
  jmp alltraps
80105bfc:	e9 7c f7 ff ff       	jmp    8010537d <alltraps>

80105c01 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c01:	6a 00                	push   $0x0
  pushl $99
80105c03:	6a 63                	push   $0x63
  jmp alltraps
80105c05:	e9 73 f7 ff ff       	jmp    8010537d <alltraps>

80105c0a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $100
80105c0c:	6a 64                	push   $0x64
  jmp alltraps
80105c0e:	e9 6a f7 ff ff       	jmp    8010537d <alltraps>

80105c13 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c13:	6a 00                	push   $0x0
  pushl $101
80105c15:	6a 65                	push   $0x65
  jmp alltraps
80105c17:	e9 61 f7 ff ff       	jmp    8010537d <alltraps>

80105c1c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $102
80105c1e:	6a 66                	push   $0x66
  jmp alltraps
80105c20:	e9 58 f7 ff ff       	jmp    8010537d <alltraps>

80105c25 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $103
80105c27:	6a 67                	push   $0x67
  jmp alltraps
80105c29:	e9 4f f7 ff ff       	jmp    8010537d <alltraps>

80105c2e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $104
80105c30:	6a 68                	push   $0x68
  jmp alltraps
80105c32:	e9 46 f7 ff ff       	jmp    8010537d <alltraps>

80105c37 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $105
80105c39:	6a 69                	push   $0x69
  jmp alltraps
80105c3b:	e9 3d f7 ff ff       	jmp    8010537d <alltraps>

80105c40 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $106
80105c42:	6a 6a                	push   $0x6a
  jmp alltraps
80105c44:	e9 34 f7 ff ff       	jmp    8010537d <alltraps>

80105c49 <vector107>:
.globl vector107
vector107:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $107
80105c4b:	6a 6b                	push   $0x6b
  jmp alltraps
80105c4d:	e9 2b f7 ff ff       	jmp    8010537d <alltraps>

80105c52 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $108
80105c54:	6a 6c                	push   $0x6c
  jmp alltraps
80105c56:	e9 22 f7 ff ff       	jmp    8010537d <alltraps>

80105c5b <vector109>:
.globl vector109
vector109:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $109
80105c5d:	6a 6d                	push   $0x6d
  jmp alltraps
80105c5f:	e9 19 f7 ff ff       	jmp    8010537d <alltraps>

80105c64 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $110
80105c66:	6a 6e                	push   $0x6e
  jmp alltraps
80105c68:	e9 10 f7 ff ff       	jmp    8010537d <alltraps>

80105c6d <vector111>:
.globl vector111
vector111:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $111
80105c6f:	6a 6f                	push   $0x6f
  jmp alltraps
80105c71:	e9 07 f7 ff ff       	jmp    8010537d <alltraps>

80105c76 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $112
80105c78:	6a 70                	push   $0x70
  jmp alltraps
80105c7a:	e9 fe f6 ff ff       	jmp    8010537d <alltraps>

80105c7f <vector113>:
.globl vector113
vector113:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $113
80105c81:	6a 71                	push   $0x71
  jmp alltraps
80105c83:	e9 f5 f6 ff ff       	jmp    8010537d <alltraps>

80105c88 <vector114>:
.globl vector114
vector114:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $114
80105c8a:	6a 72                	push   $0x72
  jmp alltraps
80105c8c:	e9 ec f6 ff ff       	jmp    8010537d <alltraps>

80105c91 <vector115>:
.globl vector115
vector115:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $115
80105c93:	6a 73                	push   $0x73
  jmp alltraps
80105c95:	e9 e3 f6 ff ff       	jmp    8010537d <alltraps>

80105c9a <vector116>:
.globl vector116
vector116:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $116
80105c9c:	6a 74                	push   $0x74
  jmp alltraps
80105c9e:	e9 da f6 ff ff       	jmp    8010537d <alltraps>

80105ca3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $117
80105ca5:	6a 75                	push   $0x75
  jmp alltraps
80105ca7:	e9 d1 f6 ff ff       	jmp    8010537d <alltraps>

80105cac <vector118>:
.globl vector118
vector118:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $118
80105cae:	6a 76                	push   $0x76
  jmp alltraps
80105cb0:	e9 c8 f6 ff ff       	jmp    8010537d <alltraps>

80105cb5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $119
80105cb7:	6a 77                	push   $0x77
  jmp alltraps
80105cb9:	e9 bf f6 ff ff       	jmp    8010537d <alltraps>

80105cbe <vector120>:
.globl vector120
vector120:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $120
80105cc0:	6a 78                	push   $0x78
  jmp alltraps
80105cc2:	e9 b6 f6 ff ff       	jmp    8010537d <alltraps>

80105cc7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $121
80105cc9:	6a 79                	push   $0x79
  jmp alltraps
80105ccb:	e9 ad f6 ff ff       	jmp    8010537d <alltraps>

80105cd0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $122
80105cd2:	6a 7a                	push   $0x7a
  jmp alltraps
80105cd4:	e9 a4 f6 ff ff       	jmp    8010537d <alltraps>

80105cd9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $123
80105cdb:	6a 7b                	push   $0x7b
  jmp alltraps
80105cdd:	e9 9b f6 ff ff       	jmp    8010537d <alltraps>

80105ce2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $124
80105ce4:	6a 7c                	push   $0x7c
  jmp alltraps
80105ce6:	e9 92 f6 ff ff       	jmp    8010537d <alltraps>

80105ceb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $125
80105ced:	6a 7d                	push   $0x7d
  jmp alltraps
80105cef:	e9 89 f6 ff ff       	jmp    8010537d <alltraps>

80105cf4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $126
80105cf6:	6a 7e                	push   $0x7e
  jmp alltraps
80105cf8:	e9 80 f6 ff ff       	jmp    8010537d <alltraps>

80105cfd <vector127>:
.globl vector127
vector127:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $127
80105cff:	6a 7f                	push   $0x7f
  jmp alltraps
80105d01:	e9 77 f6 ff ff       	jmp    8010537d <alltraps>

80105d06 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $128
80105d08:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d0d:	e9 6b f6 ff ff       	jmp    8010537d <alltraps>

80105d12 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $129
80105d14:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d19:	e9 5f f6 ff ff       	jmp    8010537d <alltraps>

80105d1e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $130
80105d20:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d25:	e9 53 f6 ff ff       	jmp    8010537d <alltraps>

80105d2a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $131
80105d2c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d31:	e9 47 f6 ff ff       	jmp    8010537d <alltraps>

80105d36 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $132
80105d38:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d3d:	e9 3b f6 ff ff       	jmp    8010537d <alltraps>

80105d42 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $133
80105d44:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d49:	e9 2f f6 ff ff       	jmp    8010537d <alltraps>

80105d4e <vector134>:
.globl vector134
vector134:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $134
80105d50:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d55:	e9 23 f6 ff ff       	jmp    8010537d <alltraps>

80105d5a <vector135>:
.globl vector135
vector135:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $135
80105d5c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d61:	e9 17 f6 ff ff       	jmp    8010537d <alltraps>

80105d66 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $136
80105d68:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d6d:	e9 0b f6 ff ff       	jmp    8010537d <alltraps>

80105d72 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $137
80105d74:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d79:	e9 ff f5 ff ff       	jmp    8010537d <alltraps>

80105d7e <vector138>:
.globl vector138
vector138:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $138
80105d80:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105d85:	e9 f3 f5 ff ff       	jmp    8010537d <alltraps>

80105d8a <vector139>:
.globl vector139
vector139:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $139
80105d8c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105d91:	e9 e7 f5 ff ff       	jmp    8010537d <alltraps>

80105d96 <vector140>:
.globl vector140
vector140:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $140
80105d98:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105d9d:	e9 db f5 ff ff       	jmp    8010537d <alltraps>

80105da2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $141
80105da4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105da9:	e9 cf f5 ff ff       	jmp    8010537d <alltraps>

80105dae <vector142>:
.globl vector142
vector142:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $142
80105db0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105db5:	e9 c3 f5 ff ff       	jmp    8010537d <alltraps>

80105dba <vector143>:
.globl vector143
vector143:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $143
80105dbc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105dc1:	e9 b7 f5 ff ff       	jmp    8010537d <alltraps>

80105dc6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $144
80105dc8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105dcd:	e9 ab f5 ff ff       	jmp    8010537d <alltraps>

80105dd2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $145
80105dd4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105dd9:	e9 9f f5 ff ff       	jmp    8010537d <alltraps>

80105dde <vector146>:
.globl vector146
vector146:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $146
80105de0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105de5:	e9 93 f5 ff ff       	jmp    8010537d <alltraps>

80105dea <vector147>:
.globl vector147
vector147:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $147
80105dec:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105df1:	e9 87 f5 ff ff       	jmp    8010537d <alltraps>

80105df6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $148
80105df8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105dfd:	e9 7b f5 ff ff       	jmp    8010537d <alltraps>

80105e02 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $149
80105e04:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e09:	e9 6f f5 ff ff       	jmp    8010537d <alltraps>

80105e0e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $150
80105e10:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e15:	e9 63 f5 ff ff       	jmp    8010537d <alltraps>

80105e1a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $151
80105e1c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e21:	e9 57 f5 ff ff       	jmp    8010537d <alltraps>

80105e26 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $152
80105e28:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e2d:	e9 4b f5 ff ff       	jmp    8010537d <alltraps>

80105e32 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $153
80105e34:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e39:	e9 3f f5 ff ff       	jmp    8010537d <alltraps>

80105e3e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $154
80105e40:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e45:	e9 33 f5 ff ff       	jmp    8010537d <alltraps>

80105e4a <vector155>:
.globl vector155
vector155:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $155
80105e4c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e51:	e9 27 f5 ff ff       	jmp    8010537d <alltraps>

80105e56 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $156
80105e58:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e5d:	e9 1b f5 ff ff       	jmp    8010537d <alltraps>

80105e62 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $157
80105e64:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e69:	e9 0f f5 ff ff       	jmp    8010537d <alltraps>

80105e6e <vector158>:
.globl vector158
vector158:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $158
80105e70:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e75:	e9 03 f5 ff ff       	jmp    8010537d <alltraps>

80105e7a <vector159>:
.globl vector159
vector159:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $159
80105e7c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105e81:	e9 f7 f4 ff ff       	jmp    8010537d <alltraps>

80105e86 <vector160>:
.globl vector160
vector160:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $160
80105e88:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105e8d:	e9 eb f4 ff ff       	jmp    8010537d <alltraps>

80105e92 <vector161>:
.globl vector161
vector161:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $161
80105e94:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105e99:	e9 df f4 ff ff       	jmp    8010537d <alltraps>

80105e9e <vector162>:
.globl vector162
vector162:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $162
80105ea0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105ea5:	e9 d3 f4 ff ff       	jmp    8010537d <alltraps>

80105eaa <vector163>:
.globl vector163
vector163:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $163
80105eac:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105eb1:	e9 c7 f4 ff ff       	jmp    8010537d <alltraps>

80105eb6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $164
80105eb8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105ebd:	e9 bb f4 ff ff       	jmp    8010537d <alltraps>

80105ec2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $165
80105ec4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ec9:	e9 af f4 ff ff       	jmp    8010537d <alltraps>

80105ece <vector166>:
.globl vector166
vector166:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $166
80105ed0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ed5:	e9 a3 f4 ff ff       	jmp    8010537d <alltraps>

80105eda <vector167>:
.globl vector167
vector167:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $167
80105edc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ee1:	e9 97 f4 ff ff       	jmp    8010537d <alltraps>

80105ee6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $168
80105ee8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105eed:	e9 8b f4 ff ff       	jmp    8010537d <alltraps>

80105ef2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $169
80105ef4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ef9:	e9 7f f4 ff ff       	jmp    8010537d <alltraps>

80105efe <vector170>:
.globl vector170
vector170:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $170
80105f00:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f05:	e9 73 f4 ff ff       	jmp    8010537d <alltraps>

80105f0a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $171
80105f0c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f11:	e9 67 f4 ff ff       	jmp    8010537d <alltraps>

80105f16 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $172
80105f18:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f1d:	e9 5b f4 ff ff       	jmp    8010537d <alltraps>

80105f22 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $173
80105f24:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f29:	e9 4f f4 ff ff       	jmp    8010537d <alltraps>

80105f2e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $174
80105f30:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f35:	e9 43 f4 ff ff       	jmp    8010537d <alltraps>

80105f3a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $175
80105f3c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f41:	e9 37 f4 ff ff       	jmp    8010537d <alltraps>

80105f46 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $176
80105f48:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f4d:	e9 2b f4 ff ff       	jmp    8010537d <alltraps>

80105f52 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $177
80105f54:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f59:	e9 1f f4 ff ff       	jmp    8010537d <alltraps>

80105f5e <vector178>:
.globl vector178
vector178:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $178
80105f60:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f65:	e9 13 f4 ff ff       	jmp    8010537d <alltraps>

80105f6a <vector179>:
.globl vector179
vector179:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $179
80105f6c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f71:	e9 07 f4 ff ff       	jmp    8010537d <alltraps>

80105f76 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $180
80105f78:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f7d:	e9 fb f3 ff ff       	jmp    8010537d <alltraps>

80105f82 <vector181>:
.globl vector181
vector181:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $181
80105f84:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105f89:	e9 ef f3 ff ff       	jmp    8010537d <alltraps>

80105f8e <vector182>:
.globl vector182
vector182:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $182
80105f90:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105f95:	e9 e3 f3 ff ff       	jmp    8010537d <alltraps>

80105f9a <vector183>:
.globl vector183
vector183:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $183
80105f9c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105fa1:	e9 d7 f3 ff ff       	jmp    8010537d <alltraps>

80105fa6 <vector184>:
.globl vector184
vector184:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $184
80105fa8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105fad:	e9 cb f3 ff ff       	jmp    8010537d <alltraps>

80105fb2 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $185
80105fb4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105fb9:	e9 bf f3 ff ff       	jmp    8010537d <alltraps>

80105fbe <vector186>:
.globl vector186
vector186:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $186
80105fc0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fc5:	e9 b3 f3 ff ff       	jmp    8010537d <alltraps>

80105fca <vector187>:
.globl vector187
vector187:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $187
80105fcc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105fd1:	e9 a7 f3 ff ff       	jmp    8010537d <alltraps>

80105fd6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $188
80105fd8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105fdd:	e9 9b f3 ff ff       	jmp    8010537d <alltraps>

80105fe2 <vector189>:
.globl vector189
vector189:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $189
80105fe4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105fe9:	e9 8f f3 ff ff       	jmp    8010537d <alltraps>

80105fee <vector190>:
.globl vector190
vector190:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $190
80105ff0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105ff5:	e9 83 f3 ff ff       	jmp    8010537d <alltraps>

80105ffa <vector191>:
.globl vector191
vector191:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $191
80105ffc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106001:	e9 77 f3 ff ff       	jmp    8010537d <alltraps>

80106006 <vector192>:
.globl vector192
vector192:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $192
80106008:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010600d:	e9 6b f3 ff ff       	jmp    8010537d <alltraps>

80106012 <vector193>:
.globl vector193
vector193:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $193
80106014:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106019:	e9 5f f3 ff ff       	jmp    8010537d <alltraps>

8010601e <vector194>:
.globl vector194
vector194:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $194
80106020:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106025:	e9 53 f3 ff ff       	jmp    8010537d <alltraps>

8010602a <vector195>:
.globl vector195
vector195:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $195
8010602c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106031:	e9 47 f3 ff ff       	jmp    8010537d <alltraps>

80106036 <vector196>:
.globl vector196
vector196:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $196
80106038:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010603d:	e9 3b f3 ff ff       	jmp    8010537d <alltraps>

80106042 <vector197>:
.globl vector197
vector197:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $197
80106044:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106049:	e9 2f f3 ff ff       	jmp    8010537d <alltraps>

8010604e <vector198>:
.globl vector198
vector198:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $198
80106050:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106055:	e9 23 f3 ff ff       	jmp    8010537d <alltraps>

8010605a <vector199>:
.globl vector199
vector199:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $199
8010605c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106061:	e9 17 f3 ff ff       	jmp    8010537d <alltraps>

80106066 <vector200>:
.globl vector200
vector200:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $200
80106068:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010606d:	e9 0b f3 ff ff       	jmp    8010537d <alltraps>

80106072 <vector201>:
.globl vector201
vector201:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $201
80106074:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106079:	e9 ff f2 ff ff       	jmp    8010537d <alltraps>

8010607e <vector202>:
.globl vector202
vector202:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $202
80106080:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106085:	e9 f3 f2 ff ff       	jmp    8010537d <alltraps>

8010608a <vector203>:
.globl vector203
vector203:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $203
8010608c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106091:	e9 e7 f2 ff ff       	jmp    8010537d <alltraps>

80106096 <vector204>:
.globl vector204
vector204:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $204
80106098:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010609d:	e9 db f2 ff ff       	jmp    8010537d <alltraps>

801060a2 <vector205>:
.globl vector205
vector205:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $205
801060a4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801060a9:	e9 cf f2 ff ff       	jmp    8010537d <alltraps>

801060ae <vector206>:
.globl vector206
vector206:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $206
801060b0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060b5:	e9 c3 f2 ff ff       	jmp    8010537d <alltraps>

801060ba <vector207>:
.globl vector207
vector207:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $207
801060bc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060c1:	e9 b7 f2 ff ff       	jmp    8010537d <alltraps>

801060c6 <vector208>:
.globl vector208
vector208:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $208
801060c8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060cd:	e9 ab f2 ff ff       	jmp    8010537d <alltraps>

801060d2 <vector209>:
.globl vector209
vector209:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $209
801060d4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060d9:	e9 9f f2 ff ff       	jmp    8010537d <alltraps>

801060de <vector210>:
.globl vector210
vector210:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $210
801060e0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801060e5:	e9 93 f2 ff ff       	jmp    8010537d <alltraps>

801060ea <vector211>:
.globl vector211
vector211:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $211
801060ec:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801060f1:	e9 87 f2 ff ff       	jmp    8010537d <alltraps>

801060f6 <vector212>:
.globl vector212
vector212:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $212
801060f8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801060fd:	e9 7b f2 ff ff       	jmp    8010537d <alltraps>

80106102 <vector213>:
.globl vector213
vector213:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $213
80106104:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106109:	e9 6f f2 ff ff       	jmp    8010537d <alltraps>

8010610e <vector214>:
.globl vector214
vector214:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $214
80106110:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106115:	e9 63 f2 ff ff       	jmp    8010537d <alltraps>

8010611a <vector215>:
.globl vector215
vector215:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $215
8010611c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106121:	e9 57 f2 ff ff       	jmp    8010537d <alltraps>

80106126 <vector216>:
.globl vector216
vector216:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $216
80106128:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010612d:	e9 4b f2 ff ff       	jmp    8010537d <alltraps>

80106132 <vector217>:
.globl vector217
vector217:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $217
80106134:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106139:	e9 3f f2 ff ff       	jmp    8010537d <alltraps>

8010613e <vector218>:
.globl vector218
vector218:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $218
80106140:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106145:	e9 33 f2 ff ff       	jmp    8010537d <alltraps>

8010614a <vector219>:
.globl vector219
vector219:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $219
8010614c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106151:	e9 27 f2 ff ff       	jmp    8010537d <alltraps>

80106156 <vector220>:
.globl vector220
vector220:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $220
80106158:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010615d:	e9 1b f2 ff ff       	jmp    8010537d <alltraps>

80106162 <vector221>:
.globl vector221
vector221:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $221
80106164:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106169:	e9 0f f2 ff ff       	jmp    8010537d <alltraps>

8010616e <vector222>:
.globl vector222
vector222:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $222
80106170:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106175:	e9 03 f2 ff ff       	jmp    8010537d <alltraps>

8010617a <vector223>:
.globl vector223
vector223:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $223
8010617c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106181:	e9 f7 f1 ff ff       	jmp    8010537d <alltraps>

80106186 <vector224>:
.globl vector224
vector224:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $224
80106188:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010618d:	e9 eb f1 ff ff       	jmp    8010537d <alltraps>

80106192 <vector225>:
.globl vector225
vector225:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $225
80106194:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106199:	e9 df f1 ff ff       	jmp    8010537d <alltraps>

8010619e <vector226>:
.globl vector226
vector226:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $226
801061a0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801061a5:	e9 d3 f1 ff ff       	jmp    8010537d <alltraps>

801061aa <vector227>:
.globl vector227
vector227:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $227
801061ac:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061b1:	e9 c7 f1 ff ff       	jmp    8010537d <alltraps>

801061b6 <vector228>:
.globl vector228
vector228:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $228
801061b8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061bd:	e9 bb f1 ff ff       	jmp    8010537d <alltraps>

801061c2 <vector229>:
.globl vector229
vector229:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $229
801061c4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061c9:	e9 af f1 ff ff       	jmp    8010537d <alltraps>

801061ce <vector230>:
.globl vector230
vector230:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $230
801061d0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061d5:	e9 a3 f1 ff ff       	jmp    8010537d <alltraps>

801061da <vector231>:
.globl vector231
vector231:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $231
801061dc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801061e1:	e9 97 f1 ff ff       	jmp    8010537d <alltraps>

801061e6 <vector232>:
.globl vector232
vector232:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $232
801061e8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801061ed:	e9 8b f1 ff ff       	jmp    8010537d <alltraps>

801061f2 <vector233>:
.globl vector233
vector233:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $233
801061f4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801061f9:	e9 7f f1 ff ff       	jmp    8010537d <alltraps>

801061fe <vector234>:
.globl vector234
vector234:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $234
80106200:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106205:	e9 73 f1 ff ff       	jmp    8010537d <alltraps>

8010620a <vector235>:
.globl vector235
vector235:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $235
8010620c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106211:	e9 67 f1 ff ff       	jmp    8010537d <alltraps>

80106216 <vector236>:
.globl vector236
vector236:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $236
80106218:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010621d:	e9 5b f1 ff ff       	jmp    8010537d <alltraps>

80106222 <vector237>:
.globl vector237
vector237:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $237
80106224:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106229:	e9 4f f1 ff ff       	jmp    8010537d <alltraps>

8010622e <vector238>:
.globl vector238
vector238:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $238
80106230:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106235:	e9 43 f1 ff ff       	jmp    8010537d <alltraps>

8010623a <vector239>:
.globl vector239
vector239:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $239
8010623c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106241:	e9 37 f1 ff ff       	jmp    8010537d <alltraps>

80106246 <vector240>:
.globl vector240
vector240:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $240
80106248:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010624d:	e9 2b f1 ff ff       	jmp    8010537d <alltraps>

80106252 <vector241>:
.globl vector241
vector241:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $241
80106254:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106259:	e9 1f f1 ff ff       	jmp    8010537d <alltraps>

8010625e <vector242>:
.globl vector242
vector242:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $242
80106260:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106265:	e9 13 f1 ff ff       	jmp    8010537d <alltraps>

8010626a <vector243>:
.globl vector243
vector243:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $243
8010626c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106271:	e9 07 f1 ff ff       	jmp    8010537d <alltraps>

80106276 <vector244>:
.globl vector244
vector244:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $244
80106278:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010627d:	e9 fb f0 ff ff       	jmp    8010537d <alltraps>

80106282 <vector245>:
.globl vector245
vector245:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $245
80106284:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106289:	e9 ef f0 ff ff       	jmp    8010537d <alltraps>

8010628e <vector246>:
.globl vector246
vector246:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $246
80106290:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106295:	e9 e3 f0 ff ff       	jmp    8010537d <alltraps>

8010629a <vector247>:
.globl vector247
vector247:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $247
8010629c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801062a1:	e9 d7 f0 ff ff       	jmp    8010537d <alltraps>

801062a6 <vector248>:
.globl vector248
vector248:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $248
801062a8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801062ad:	e9 cb f0 ff ff       	jmp    8010537d <alltraps>

801062b2 <vector249>:
.globl vector249
vector249:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $249
801062b4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062b9:	e9 bf f0 ff ff       	jmp    8010537d <alltraps>

801062be <vector250>:
.globl vector250
vector250:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $250
801062c0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062c5:	e9 b3 f0 ff ff       	jmp    8010537d <alltraps>

801062ca <vector251>:
.globl vector251
vector251:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $251
801062cc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062d1:	e9 a7 f0 ff ff       	jmp    8010537d <alltraps>

801062d6 <vector252>:
.globl vector252
vector252:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $252
801062d8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062dd:	e9 9b f0 ff ff       	jmp    8010537d <alltraps>

801062e2 <vector253>:
.globl vector253
vector253:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $253
801062e4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801062e9:	e9 8f f0 ff ff       	jmp    8010537d <alltraps>

801062ee <vector254>:
.globl vector254
vector254:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $254
801062f0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801062f5:	e9 83 f0 ff ff       	jmp    8010537d <alltraps>

801062fa <vector255>:
.globl vector255
vector255:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $255
801062fc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106301:	e9 77 f0 ff ff       	jmp    8010537d <alltraps>
80106306:	66 90                	xchg   %ax,%ax
80106308:	66 90                	xchg   %ax,%ax
8010630a:	66 90                	xchg   %ax,%ax
8010630c:	66 90                	xchg   %ax,%ax
8010630e:	66 90                	xchg   %ax,%ax

80106310 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	57                   	push   %edi
80106314:	56                   	push   %esi
80106315:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106317:	c1 ea 16             	shr    $0x16,%edx
{
8010631a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010631b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010631e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106321:	8b 1f                	mov    (%edi),%ebx
80106323:	f6 c3 01             	test   $0x1,%bl
80106326:	74 28                	je     80106350 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106328:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010632e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106334:	c1 ee 0a             	shr    $0xa,%esi
}
80106337:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010633a:	89 f2                	mov    %esi,%edx
8010633c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106342:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106345:	5b                   	pop    %ebx
80106346:	5e                   	pop    %esi
80106347:	5f                   	pop    %edi
80106348:	5d                   	pop    %ebp
80106349:	c3                   	ret    
8010634a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106350:	85 c9                	test   %ecx,%ecx
80106352:	74 34                	je     80106388 <walkpgdir+0x78>
80106354:	e8 17 c1 ff ff       	call   80102470 <kalloc>
80106359:	85 c0                	test   %eax,%eax
8010635b:	89 c3                	mov    %eax,%ebx
8010635d:	74 29                	je     80106388 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010635f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106366:	00 
80106367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010636e:	00 
8010636f:	89 04 24             	mov    %eax,(%esp)
80106372:	e8 f9 de ff ff       	call   80104270 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106377:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010637d:	83 c8 07             	or     $0x7,%eax
80106380:	89 07                	mov    %eax,(%edi)
80106382:	eb b0                	jmp    80106334 <walkpgdir+0x24>
80106384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106388:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010638b:	31 c0                	xor    %eax,%eax
}
8010638d:	5b                   	pop    %ebx
8010638e:	5e                   	pop    %esi
8010638f:	5f                   	pop    %edi
80106390:	5d                   	pop    %ebp
80106391:	c3                   	ret    
80106392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	57                   	push   %edi
801063a4:	56                   	push   %esi
801063a5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801063a6:	89 d3                	mov    %edx,%ebx
{
801063a8:	83 ec 1c             	sub    $0x1c,%esp
801063ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
801063ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801063b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801063b7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801063bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801063be:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801063c2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801063c9:	29 df                	sub    %ebx,%edi
801063cb:	eb 18                	jmp    801063e5 <mappages+0x45>
801063cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
801063d0:	f6 00 01             	testb  $0x1,(%eax)
801063d3:	75 3d                	jne    80106412 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801063d5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801063d8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801063db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801063dd:	74 29                	je     80106408 <mappages+0x68>
      break;
    a += PGSIZE;
801063df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801063ed:	89 da                	mov    %ebx,%edx
801063ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801063f2:	e8 19 ff ff ff       	call   80106310 <walkpgdir>
801063f7:	85 c0                	test   %eax,%eax
801063f9:	75 d5                	jne    801063d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801063fb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801063fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106403:	5b                   	pop    %ebx
80106404:	5e                   	pop    %esi
80106405:	5f                   	pop    %edi
80106406:	5d                   	pop    %ebp
80106407:	c3                   	ret    
80106408:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010640b:	31 c0                	xor    %eax,%eax
}
8010640d:	5b                   	pop    %ebx
8010640e:	5e                   	pop    %esi
8010640f:	5f                   	pop    %edi
80106410:	5d                   	pop    %ebp
80106411:	c3                   	ret    
      panic("remap");
80106412:	c7 04 24 f0 75 10 80 	movl   $0x801075f0,(%esp)
80106419:	e8 42 9f ff ff       	call   80100360 <panic>
8010641e:	66 90                	xchg   %ax,%ax

80106420 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	57                   	push   %edi
80106424:	89 c7                	mov    %eax,%edi
80106426:	56                   	push   %esi
80106427:	89 d6                	mov    %edx,%esi
80106429:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010642a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106430:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106433:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106439:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010643b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010643e:	72 3b                	jb     8010647b <deallocuvm.part.0+0x5b>
80106440:	eb 5e                	jmp    801064a0 <deallocuvm.part.0+0x80>
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106448:	8b 10                	mov    (%eax),%edx
8010644a:	f6 c2 01             	test   $0x1,%dl
8010644d:	74 22                	je     80106471 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010644f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106455:	74 54                	je     801064ab <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106457:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010645d:	89 14 24             	mov    %edx,(%esp)
80106460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106463:	e8 58 be ff ff       	call   801022c0 <kfree>
      *pte = 0;
80106468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010646b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106477:	39 f3                	cmp    %esi,%ebx
80106479:	73 25                	jae    801064a0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010647b:	31 c9                	xor    %ecx,%ecx
8010647d:	89 da                	mov    %ebx,%edx
8010647f:	89 f8                	mov    %edi,%eax
80106481:	e8 8a fe ff ff       	call   80106310 <walkpgdir>
    if(!pte)
80106486:	85 c0                	test   %eax,%eax
80106488:	75 be                	jne    80106448 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010648a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106490:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106496:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010649c:	39 f3                	cmp    %esi,%ebx
8010649e:	72 db                	jb     8010647b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
801064a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064a3:	83 c4 1c             	add    $0x1c,%esp
801064a6:	5b                   	pop    %ebx
801064a7:	5e                   	pop    %esi
801064a8:	5f                   	pop    %edi
801064a9:	5d                   	pop    %ebp
801064aa:	c3                   	ret    
        panic("kfree");
801064ab:	c7 04 24 46 6f 10 80 	movl   $0x80106f46,(%esp)
801064b2:	e8 a9 9e ff ff       	call   80100360 <panic>
801064b7:	89 f6                	mov    %esi,%esi
801064b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064c0 <seginit>:
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801064c6:	e8 85 d1 ff ff       	call   80103650 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064cb:	31 c9                	xor    %ecx,%ecx
801064cd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801064d2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064d8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064dd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064e1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801064e6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064e9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064ed:	31 c9                	xor    %ecx,%ecx
801064ef:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064f8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064fc:	31 c9                	xor    %ecx,%ecx
801064fe:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106502:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106507:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010650b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010650d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106511:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106515:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106519:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010651d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106521:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106525:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106529:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010652d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106531:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106536:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010653a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010653e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106542:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106546:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010654a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010654e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106552:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106556:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010655a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010655e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106562:	c1 e8 10             	shr    $0x10,%eax
80106565:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106569:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010656c:	0f 01 10             	lgdtl  (%eax)
}
8010656f:	c9                   	leave  
80106570:	c3                   	ret    
80106571:	eb 0d                	jmp    80106580 <switchkvm>
80106573:	90                   	nop
80106574:	90                   	nop
80106575:	90                   	nop
80106576:	90                   	nop
80106577:	90                   	nop
80106578:	90                   	nop
80106579:	90                   	nop
8010657a:	90                   	nop
8010657b:	90                   	nop
8010657c:	90                   	nop
8010657d:	90                   	nop
8010657e:	90                   	nop
8010657f:	90                   	nop

80106580 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106580:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
80106585:	55                   	push   %ebp
80106586:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106588:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010658d:	0f 22 d8             	mov    %eax,%cr3
}
80106590:	5d                   	pop    %ebp
80106591:	c3                   	ret    
80106592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065a0 <switchuvm>:
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
801065a6:	83 ec 1c             	sub    $0x1c,%esp
801065a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801065ac:	85 f6                	test   %esi,%esi
801065ae:	0f 84 cd 00 00 00    	je     80106681 <switchuvm+0xe1>
  if(p->kstack == 0)
801065b4:	8b 46 08             	mov    0x8(%esi),%eax
801065b7:	85 c0                	test   %eax,%eax
801065b9:	0f 84 da 00 00 00    	je     80106699 <switchuvm+0xf9>
  if(p->pgdir == 0)
801065bf:	8b 7e 04             	mov    0x4(%esi),%edi
801065c2:	85 ff                	test   %edi,%edi
801065c4:	0f 84 c3 00 00 00    	je     8010668d <switchuvm+0xed>
  pushcli();
801065ca:	e8 f1 da ff ff       	call   801040c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801065cf:	e8 fc cf ff ff       	call   801035d0 <mycpu>
801065d4:	89 c3                	mov    %eax,%ebx
801065d6:	e8 f5 cf ff ff       	call   801035d0 <mycpu>
801065db:	89 c7                	mov    %eax,%edi
801065dd:	e8 ee cf ff ff       	call   801035d0 <mycpu>
801065e2:	83 c7 08             	add    $0x8,%edi
801065e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065e8:	e8 e3 cf ff ff       	call   801035d0 <mycpu>
801065ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065f0:	ba 67 00 00 00       	mov    $0x67,%edx
801065f5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801065fc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106603:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010660a:	83 c1 08             	add    $0x8,%ecx
8010660d:	c1 e9 10             	shr    $0x10,%ecx
80106610:	83 c0 08             	add    $0x8,%eax
80106613:	c1 e8 18             	shr    $0x18,%eax
80106616:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010661c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106623:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106629:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010662e:	e8 9d cf ff ff       	call   801035d0 <mycpu>
80106633:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010663a:	e8 91 cf ff ff       	call   801035d0 <mycpu>
8010663f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106644:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106648:	e8 83 cf ff ff       	call   801035d0 <mycpu>
8010664d:	8b 56 08             	mov    0x8(%esi),%edx
80106650:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106656:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106659:	e8 72 cf ff ff       	call   801035d0 <mycpu>
8010665e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106662:	b8 28 00 00 00       	mov    $0x28,%eax
80106667:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010666a:	8b 46 04             	mov    0x4(%esi),%eax
8010666d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106672:	0f 22 d8             	mov    %eax,%cr3
}
80106675:	83 c4 1c             	add    $0x1c,%esp
80106678:	5b                   	pop    %ebx
80106679:	5e                   	pop    %esi
8010667a:	5f                   	pop    %edi
8010667b:	5d                   	pop    %ebp
  popcli();
8010667c:	e9 7f da ff ff       	jmp    80104100 <popcli>
    panic("switchuvm: no process");
80106681:	c7 04 24 f6 75 10 80 	movl   $0x801075f6,(%esp)
80106688:	e8 d3 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010668d:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
80106694:	e8 c7 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106699:	c7 04 24 0c 76 10 80 	movl   $0x8010760c,(%esp)
801066a0:	e8 bb 9c ff ff       	call   80100360 <panic>
801066a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066b0 <inituvm>:
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	53                   	push   %ebx
801066b6:	83 ec 1c             	sub    $0x1c,%esp
801066b9:	8b 75 10             	mov    0x10(%ebp),%esi
801066bc:	8b 45 08             	mov    0x8(%ebp),%eax
801066bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801066c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801066c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801066cb:	77 54                	ja     80106721 <inituvm+0x71>
  mem = kalloc();
801066cd:	e8 9e bd ff ff       	call   80102470 <kalloc>
  memset(mem, 0, PGSIZE);
801066d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066d9:	00 
801066da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066e1:	00 
  mem = kalloc();
801066e2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801066e4:	89 04 24             	mov    %eax,(%esp)
801066e7:	e8 84 db ff ff       	call   80104270 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801066ec:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066f7:	89 04 24             	mov    %eax,(%esp)
801066fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066fd:	31 d2                	xor    %edx,%edx
801066ff:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106706:	00 
80106707:	e8 94 fc ff ff       	call   801063a0 <mappages>
  memmove(mem, init, sz);
8010670c:	89 75 10             	mov    %esi,0x10(%ebp)
8010670f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106712:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106715:	83 c4 1c             	add    $0x1c,%esp
80106718:	5b                   	pop    %ebx
80106719:	5e                   	pop    %esi
8010671a:	5f                   	pop    %edi
8010671b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010671c:	e9 ef db ff ff       	jmp    80104310 <memmove>
    panic("inituvm: more than a page");
80106721:	c7 04 24 35 76 10 80 	movl   $0x80107635,(%esp)
80106728:	e8 33 9c ff ff       	call   80100360 <panic>
8010672d:	8d 76 00             	lea    0x0(%esi),%esi

80106730 <loaduvm>:
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
80106735:	53                   	push   %ebx
80106736:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106739:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106740:	0f 85 98 00 00 00    	jne    801067de <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106746:	8b 75 18             	mov    0x18(%ebp),%esi
80106749:	31 db                	xor    %ebx,%ebx
8010674b:	85 f6                	test   %esi,%esi
8010674d:	75 1a                	jne    80106769 <loaduvm+0x39>
8010674f:	eb 77                	jmp    801067c8 <loaduvm+0x98>
80106751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106758:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010675e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106764:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106767:	76 5f                	jbe    801067c8 <loaduvm+0x98>
80106769:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010676c:	31 c9                	xor    %ecx,%ecx
8010676e:	8b 45 08             	mov    0x8(%ebp),%eax
80106771:	01 da                	add    %ebx,%edx
80106773:	e8 98 fb ff ff       	call   80106310 <walkpgdir>
80106778:	85 c0                	test   %eax,%eax
8010677a:	74 56                	je     801067d2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010677c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010677e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106783:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106786:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010678b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106791:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106794:	05 00 00 00 80       	add    $0x80000000,%eax
80106799:	89 44 24 04          	mov    %eax,0x4(%esp)
8010679d:	8b 45 10             	mov    0x10(%ebp),%eax
801067a0:	01 d9                	add    %ebx,%ecx
801067a2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801067a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067aa:	89 04 24             	mov    %eax,(%esp)
801067ad:	e8 7e b1 ff ff       	call   80101930 <readi>
801067b2:	39 f8                	cmp    %edi,%eax
801067b4:	74 a2                	je     80106758 <loaduvm+0x28>
}
801067b6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801067b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067be:	5b                   	pop    %ebx
801067bf:	5e                   	pop    %esi
801067c0:	5f                   	pop    %edi
801067c1:	5d                   	pop    %ebp
801067c2:	c3                   	ret    
801067c3:	90                   	nop
801067c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067c8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801067cb:	31 c0                	xor    %eax,%eax
}
801067cd:	5b                   	pop    %ebx
801067ce:	5e                   	pop    %esi
801067cf:	5f                   	pop    %edi
801067d0:	5d                   	pop    %ebp
801067d1:	c3                   	ret    
      panic("loaduvm: address should exist");
801067d2:	c7 04 24 4f 76 10 80 	movl   $0x8010764f,(%esp)
801067d9:	e8 82 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
801067de:	c7 04 24 f0 76 10 80 	movl   $0x801076f0,(%esp)
801067e5:	e8 76 9b ff ff       	call   80100360 <panic>
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067f0 <allocuvm>:
{
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
801067f6:	83 ec 1c             	sub    $0x1c,%esp
801067f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801067fc:	85 ff                	test   %edi,%edi
801067fe:	0f 88 7e 00 00 00    	js     80106882 <allocuvm+0x92>
  if(newsz < oldsz)
80106804:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106807:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010680a:	72 78                	jb     80106884 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
8010680c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106812:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106818:	39 df                	cmp    %ebx,%edi
8010681a:	77 4a                	ja     80106866 <allocuvm+0x76>
8010681c:	eb 72                	jmp    80106890 <allocuvm+0xa0>
8010681e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106820:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106827:	00 
80106828:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010682f:	00 
80106830:	89 04 24             	mov    %eax,(%esp)
80106833:	e8 38 da ff ff       	call   80104270 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106838:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010683e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106843:	89 04 24             	mov    %eax,(%esp)
80106846:	8b 45 08             	mov    0x8(%ebp),%eax
80106849:	89 da                	mov    %ebx,%edx
8010684b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106852:	00 
80106853:	e8 48 fb ff ff       	call   801063a0 <mappages>
80106858:	85 c0                	test   %eax,%eax
8010685a:	78 44                	js     801068a0 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
8010685c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106862:	39 df                	cmp    %ebx,%edi
80106864:	76 2a                	jbe    80106890 <allocuvm+0xa0>
    mem = kalloc();
80106866:	e8 05 bc ff ff       	call   80102470 <kalloc>
    if(mem == 0){
8010686b:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010686d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010686f:	75 af                	jne    80106820 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106871:	c7 04 24 6d 76 10 80 	movl   $0x8010766d,(%esp)
80106878:	e8 d3 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010687d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106880:	77 48                	ja     801068ca <allocuvm+0xda>
      return 0;
80106882:	31 c0                	xor    %eax,%eax
}
80106884:	83 c4 1c             	add    $0x1c,%esp
80106887:	5b                   	pop    %ebx
80106888:	5e                   	pop    %esi
80106889:	5f                   	pop    %edi
8010688a:	5d                   	pop    %ebp
8010688b:	c3                   	ret    
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106890:	83 c4 1c             	add    $0x1c,%esp
80106893:	89 f8                	mov    %edi,%eax
80106895:	5b                   	pop    %ebx
80106896:	5e                   	pop    %esi
80106897:	5f                   	pop    %edi
80106898:	5d                   	pop    %ebp
80106899:	c3                   	ret    
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801068a0:	c7 04 24 85 76 10 80 	movl   $0x80107685,(%esp)
801068a7:	e8 a4 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068ac:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068af:	76 0d                	jbe    801068be <allocuvm+0xce>
801068b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068b4:	89 fa                	mov    %edi,%edx
801068b6:	8b 45 08             	mov    0x8(%ebp),%eax
801068b9:	e8 62 fb ff ff       	call   80106420 <deallocuvm.part.0>
      kfree(mem);
801068be:	89 34 24             	mov    %esi,(%esp)
801068c1:	e8 fa b9 ff ff       	call   801022c0 <kfree>
      return 0;
801068c6:	31 c0                	xor    %eax,%eax
801068c8:	eb ba                	jmp    80106884 <allocuvm+0x94>
801068ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068cd:	89 fa                	mov    %edi,%edx
801068cf:	8b 45 08             	mov    0x8(%ebp),%eax
801068d2:	e8 49 fb ff ff       	call   80106420 <deallocuvm.part.0>
      return 0;
801068d7:	31 c0                	xor    %eax,%eax
801068d9:	eb a9                	jmp    80106884 <allocuvm+0x94>
801068db:	90                   	nop
801068dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068e0 <deallocuvm>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801068e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801068e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801068ec:	39 d1                	cmp    %edx,%ecx
801068ee:	73 08                	jae    801068f8 <deallocuvm+0x18>
}
801068f0:	5d                   	pop    %ebp
801068f1:	e9 2a fb ff ff       	jmp    80106420 <deallocuvm.part.0>
801068f6:	66 90                	xchg   %ax,%ax
801068f8:	89 d0                	mov    %edx,%eax
801068fa:	5d                   	pop    %ebp
801068fb:	c3                   	ret    
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106900 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	56                   	push   %esi
80106904:	53                   	push   %ebx
80106905:	83 ec 10             	sub    $0x10,%esp
80106908:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010690b:	85 f6                	test   %esi,%esi
8010690d:	74 59                	je     80106968 <freevm+0x68>
8010690f:	31 c9                	xor    %ecx,%ecx
80106911:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106916:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106918:	31 db                	xor    %ebx,%ebx
8010691a:	e8 01 fb ff ff       	call   80106420 <deallocuvm.part.0>
8010691f:	eb 12                	jmp    80106933 <freevm+0x33>
80106921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106928:	83 c3 01             	add    $0x1,%ebx
8010692b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106931:	74 27                	je     8010695a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106933:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106936:	f6 c2 01             	test   $0x1,%dl
80106939:	74 ed                	je     80106928 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010693b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106941:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106944:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010694a:	89 14 24             	mov    %edx,(%esp)
8010694d:	e8 6e b9 ff ff       	call   801022c0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106952:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106958:	75 d9                	jne    80106933 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
8010695a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010695d:	83 c4 10             	add    $0x10,%esp
80106960:	5b                   	pop    %ebx
80106961:	5e                   	pop    %esi
80106962:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106963:	e9 58 b9 ff ff       	jmp    801022c0 <kfree>
    panic("freevm: no pgdir");
80106968:	c7 04 24 a1 76 10 80 	movl   $0x801076a1,(%esp)
8010696f:	e8 ec 99 ff ff       	call   80100360 <panic>
80106974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010697a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106980 <setupkvm>:
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	56                   	push   %esi
80106984:	53                   	push   %ebx
80106985:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106988:	e8 e3 ba ff ff       	call   80102470 <kalloc>
8010698d:	85 c0                	test   %eax,%eax
8010698f:	89 c6                	mov    %eax,%esi
80106991:	74 6d                	je     80106a00 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106993:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010699a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010699b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801069a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069a7:	00 
801069a8:	89 04 24             	mov    %eax,(%esp)
801069ab:	e8 c0 d8 ff ff       	call   80104270 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801069b0:	8b 53 0c             	mov    0xc(%ebx),%edx
801069b3:	8b 43 04             	mov    0x4(%ebx),%eax
801069b6:	8b 4b 08             	mov    0x8(%ebx),%ecx
801069b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801069bd:	8b 13                	mov    (%ebx),%edx
801069bf:	89 04 24             	mov    %eax,(%esp)
801069c2:	29 c1                	sub    %eax,%ecx
801069c4:	89 f0                	mov    %esi,%eax
801069c6:	e8 d5 f9 ff ff       	call   801063a0 <mappages>
801069cb:	85 c0                	test   %eax,%eax
801069cd:	78 19                	js     801069e8 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069cf:	83 c3 10             	add    $0x10,%ebx
801069d2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069d8:	72 d6                	jb     801069b0 <setupkvm+0x30>
801069da:	89 f0                	mov    %esi,%eax
}
801069dc:	83 c4 10             	add    $0x10,%esp
801069df:	5b                   	pop    %ebx
801069e0:	5e                   	pop    %esi
801069e1:	5d                   	pop    %ebp
801069e2:	c3                   	ret    
801069e3:	90                   	nop
801069e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801069e8:	89 34 24             	mov    %esi,(%esp)
801069eb:	e8 10 ff ff ff       	call   80106900 <freevm>
}
801069f0:	83 c4 10             	add    $0x10,%esp
      return 0;
801069f3:	31 c0                	xor    %eax,%eax
}
801069f5:	5b                   	pop    %ebx
801069f6:	5e                   	pop    %esi
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    
801069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a00:	31 c0                	xor    %eax,%eax
80106a02:	eb d8                	jmp    801069dc <setupkvm+0x5c>
80106a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a10 <kvmalloc>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a16:	e8 65 ff ff ff       	call   80106980 <setupkvm>
80106a1b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a20:	05 00 00 00 80       	add    $0x80000000,%eax
80106a25:	0f 22 d8             	mov    %eax,%cr3
}
80106a28:	c9                   	leave  
80106a29:	c3                   	ret    
80106a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a30 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a31:	31 c9                	xor    %ecx,%ecx
{
80106a33:	89 e5                	mov    %esp,%ebp
80106a35:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106a38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3e:	e8 cd f8 ff ff       	call   80106310 <walkpgdir>
  if(pte == 0)
80106a43:	85 c0                	test   %eax,%eax
80106a45:	74 05                	je     80106a4c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106a47:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106a4a:	c9                   	leave  
80106a4b:	c3                   	ret    
    panic("clearpteu");
80106a4c:	c7 04 24 b2 76 10 80 	movl   $0x801076b2,(%esp)
80106a53:	e8 08 99 ff ff       	call   80100360 <panic>
80106a58:	90                   	nop
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106a69:	e8 12 ff ff ff       	call   80106980 <setupkvm>
80106a6e:	85 c0                	test   %eax,%eax
80106a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a73:	0f 84 76 01 00 00    	je     80106bef <copyuvm+0x18f>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a7c:	85 c0                	test   %eax,%eax
80106a7e:	0f 84 b4 00 00 00    	je     80106b38 <copyuvm+0xd8>
80106a84:	31 ff                	xor    %edi,%edi
80106a86:	eb 48                	jmp    80106ad0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106a88:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106a8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a95:	00 
80106a96:	89 74 24 04          	mov    %esi,0x4(%esp)
80106a9a:	89 04 24             	mov    %eax,(%esp)
80106a9d:	e8 6e d8 ff ff       	call   80104310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106aa5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106aaa:	89 fa                	mov    %edi,%edx
80106aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ab0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ab6:	89 04 24             	mov    %eax,(%esp)
80106ab9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106abc:	e8 df f8 ff ff       	call   801063a0 <mappages>
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	78 63                	js     80106b28 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106ac5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106acb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106ace:	76 68                	jbe    80106b38 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad3:	31 c9                	xor    %ecx,%ecx
80106ad5:	89 fa                	mov    %edi,%edx
80106ad7:	e8 34 f8 ff ff       	call   80106310 <walkpgdir>
80106adc:	85 c0                	test   %eax,%eax
80106ade:	0f 84 1e 01 00 00    	je     80106c02 <copyuvm+0x1a2>
    if(!(*pte & PTE_P))
80106ae4:	8b 00                	mov    (%eax),%eax
80106ae6:	a8 01                	test   $0x1,%al
80106ae8:	0f 84 08 01 00 00    	je     80106bf6 <copyuvm+0x196>
    pa = PTE_ADDR(*pte);
80106aee:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106af0:	25 ff 0f 00 00       	and    $0xfff,%eax
80106af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106af8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106afe:	e8 6d b9 ff ff       	call   80102470 <kalloc>
80106b03:	85 c0                	test   %eax,%eax
80106b05:	89 c3                	mov    %eax,%ebx
80106b07:	0f 85 7b ff ff ff    	jne    80106a88 <copyuvm+0x28>
	}
  }
  return d;

bad:
  freevm(d);
80106b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b10:	89 04 24             	mov    %eax,(%esp)
80106b13:	e8 e8 fd ff ff       	call   80106900 <freevm>
  return 0;
80106b18:	31 c0                	xor    %eax,%eax
}
80106b1a:	83 c4 2c             	add    $0x2c,%esp
80106b1d:	5b                   	pop    %ebx
80106b1e:	5e                   	pop    %esi
80106b1f:	5f                   	pop    %edi
80106b20:	5d                   	pop    %ebp
80106b21:	c3                   	ret    
80106b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	   kfree(mem);
80106b28:	89 1c 24             	mov    %ebx,(%esp)
80106b2b:	e8 90 b7 ff ff       	call   801022c0 <kfree>
	   goto bad;
80106b30:	eb db                	jmp    80106b0d <copyuvm+0xad>
80106b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint stackEnd = STACKTOP - PGSIZE*(myproc()->stackPages);
80106b38:	e8 33 cb ff ff       	call   80103670 <myproc>
  for(i = PGROUNDUP(stackEnd); i < STACKTOP; i += PGSIZE){
80106b3d:	bf fe 0f 00 80       	mov    $0x80000ffe,%edi
  uint stackEnd = STACKTOP - PGSIZE*(myproc()->stackPages);
80106b42:	8b 40 7c             	mov    0x7c(%eax),%eax
80106b45:	c1 e0 0c             	shl    $0xc,%eax
  for(i = PGROUNDUP(stackEnd); i < STACKTOP; i += PGSIZE){
80106b48:	29 c7                	sub    %eax,%edi
80106b4a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106b50:	81 ff fe ff ff 7f    	cmp    $0x7ffffffe,%edi
80106b56:	76 52                	jbe    80106baa <copyuvm+0x14a>
80106b58:	e9 87 00 00 00       	jmp    80106be4 <copyuvm+0x184>
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi
	memmove(mem, (char*)P2V(pa), PGSIZE);
80106b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b6a:	00 
80106b6b:	89 1c 24             	mov    %ebx,(%esp)
80106b6e:	05 00 00 00 80       	add    $0x80000000,%eax
80106b73:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b77:	e8 94 d7 ff ff       	call   80104310 <memmove>
	if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0){
80106b7c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b82:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b87:	89 04 24             	mov    %eax,(%esp)
80106b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b8d:	89 fa                	mov    %edi,%edx
80106b8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80106b93:	e8 08 f8 ff ff       	call   801063a0 <mappages>
80106b98:	85 c0                	test   %eax,%eax
80106b9a:	78 8c                	js     80106b28 <copyuvm+0xc8>
  for(i = PGROUNDUP(stackEnd); i < STACKTOP; i += PGSIZE){
80106b9c:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ba2:	81 ff fe ff ff 7f    	cmp    $0x7ffffffe,%edi
80106ba8:	77 3a                	ja     80106be4 <copyuvm+0x184>
	if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106baa:	8b 45 08             	mov    0x8(%ebp),%eax
80106bad:	31 c9                	xor    %ecx,%ecx
80106baf:	89 fa                	mov    %edi,%edx
80106bb1:	e8 5a f7 ff ff       	call   80106310 <walkpgdir>
80106bb6:	85 c0                	test   %eax,%eax
80106bb8:	74 48                	je     80106c02 <copyuvm+0x1a2>
	if(!(*pte & PTE_P))
80106bba:	8b 30                	mov    (%eax),%esi
80106bbc:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106bc2:	74 32                	je     80106bf6 <copyuvm+0x196>
	pa = PTE_ADDR(*pte);
80106bc4:	89 f0                	mov    %esi,%eax
	flags = PTE_FLAGS(*pte);
80106bc6:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
	pa = PTE_ADDR(*pte);
80106bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if((mem = kalloc()) == 0)
80106bd4:	e8 97 b8 ff ff       	call   80102470 <kalloc>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	75 81                	jne    80106b60 <copyuvm+0x100>
80106bdf:	e9 29 ff ff ff       	jmp    80106b0d <copyuvm+0xad>
80106be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106be7:	83 c4 2c             	add    $0x2c,%esp
80106bea:	5b                   	pop    %ebx
80106beb:	5e                   	pop    %esi
80106bec:	5f                   	pop    %edi
80106bed:	5d                   	pop    %ebp
80106bee:	c3                   	ret    
    return 0;
80106bef:	31 c0                	xor    %eax,%eax
80106bf1:	e9 24 ff ff ff       	jmp    80106b1a <copyuvm+0xba>
      panic("copyuvm: page not present");
80106bf6:	c7 04 24 d6 76 10 80 	movl   $0x801076d6,(%esp)
80106bfd:	e8 5e 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106c02:	c7 04 24 bc 76 10 80 	movl   $0x801076bc,(%esp)
80106c09:	e8 52 97 ff ff       	call   80100360 <panic>
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c11:	31 c9                	xor    %ecx,%ecx
{
80106c13:	89 e5                	mov    %esp,%ebp
80106c15:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106c18:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1e:	e8 ed f6 ff ff       	call   80106310 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c23:	8b 00                	mov    (%eax),%eax
80106c25:	89 c2                	mov    %eax,%edx
80106c27:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c2a:	83 fa 05             	cmp    $0x5,%edx
80106c2d:	75 11                	jne    80106c40 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c34:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c39:	c9                   	leave  
80106c3a:	c3                   	ret    
80106c3b:	90                   	nop
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106c40:	31 c0                	xor    %eax,%eax
}
80106c42:	c9                   	leave  
80106c43:	c3                   	ret    
80106c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c62:	85 db                	test   %ebx,%ebx
80106c64:	75 3a                	jne    80106ca0 <copyout+0x50>
80106c66:	eb 68                	jmp    80106cd0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106c68:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c6b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106c6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106c71:	29 ca                	sub    %ecx,%edx
80106c73:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106c79:	39 da                	cmp    %ebx,%edx
80106c7b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106c7e:	29 f1                	sub    %esi,%ecx
80106c80:	01 c8                	add    %ecx,%eax
80106c82:	89 54 24 08          	mov    %edx,0x8(%esp)
80106c86:	89 04 24             	mov    %eax,(%esp)
80106c89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106c8c:	e8 7f d6 ff ff       	call   80104310 <memmove>
    len -= n;
    buf += n;
80106c91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106c94:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106c9a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106c9c:	29 d3                	sub    %edx,%ebx
80106c9e:	74 30                	je     80106cd0 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106ca0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106ca3:	89 ce                	mov    %ecx,%esi
80106ca5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106cab:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106caf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106cb2:	89 04 24             	mov    %eax,(%esp)
80106cb5:	e8 56 ff ff ff       	call   80106c10 <uva2ka>
    if(pa0 == 0)
80106cba:	85 c0                	test   %eax,%eax
80106cbc:	75 aa                	jne    80106c68 <copyout+0x18>
  }
  return 0;
}
80106cbe:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc6:	5b                   	pop    %ebx
80106cc7:	5e                   	pop    %esi
80106cc8:	5f                   	pop    %edi
80106cc9:	5d                   	pop    %ebp
80106cca:	c3                   	ret    
80106ccb:	90                   	nop
80106ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cd0:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
