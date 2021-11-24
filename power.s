.section .data
.section .text
.global _start
_start:
  #准备参数
  pushq $3
  pushq $2
  #调用 power ，power 函数的返回值存在 eax 中
  #调用完之后，上面压入栈中的参数就没用了，要清理栈空间
  #eax 还要再用一次，所以要把 eax 的值压入栈中，暂存起来
  call power
  addq $16, %rsp
  pushq %rax
  pushq $2
  pushq $5
  #再次准备参数
  #调用 power 
  #恢复栈空间
  call power
  addq $16, %rsp
  #第一次调用 power 的结果暂存在栈中，pop 到 ebx 中
  #第二次调用 power 的结果在 eax 中，ebx = ebx + eax ，最终结果在 ebx 中
  popq %rbx
  addq %rax, %rbx
  movq %rbx, %rdi
  #利用 sys_exit 调用，打印出 rdi 的值
  movq $60, %rax
  syscall

.type power, @function
power:
  #存储 old ebp ，压入栈中存储
  #存储当前函数的基址，esp 的值存入 ebp 中
  pushq %rbp
  movq %rsp, %rbp
  #第一个参数是基数，存入 ebx 中
  #第二个参数是指数，存入 ecx 中
  #每次相乘得到结果存入 eax 中，初始化为基数
  movq 16(%rbp), %rbx
  movq 24(%rbp), %rcx
  movq %rbx, %rax
loop_start:
  #如果 ecx = 1 ，则直接结束循环，指数为 1 的情况在上面初始化时已经做好了
  #eax = eax * ebx
  #ecx--
  cmpq $1, %rcx
  je loop_exit
  imulq %rbx, %rax
  decq %rcx
  jmp loop_start
loop_exit:
  #恢复 esp
  #恢复 ebp  
  movq %rbp, %rsp
  popq %rbp
  ret
