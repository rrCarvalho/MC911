@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = load i32 * %tmp0
  ret i32 %tmp1
}
%class.b = type { i32, i32 * }
define i32 @__met_(%class. * %this, i32 %i, i32 %j) {
entry0:
  %tmp7 = alloca i32
  store i32 0, i32 * %tmp7
  %i_addr = alloca i32
  store i32 %i, i32 * %i_addr
  %j_addr = alloca i32
  store i32 %j, i32 * %j_addr
  %c = alloca i32
  %d = alloca i32 *
  %tmp10 = icmp eq i32 1, 1
  br i1 %tmp10, label %IfThen0, label %IfElse0
IfThen0:
  store i32 10, i32 * %c
  %tmp11 = icmp eq i32 2, 2
  br i1 %tmp11, label %IfThen1, label %IfElse1
IfThen1:
  br label %WhileTest2
WhileTest2:
  %tmp12 = icmp slt i32 2, 1
  br i1 %tmp12, label %WhileStart2, label %WhileEnd2
WhileStart2:
  %tmp13 = icmp eq i32 4, 4
  br i1 %tmp13, label %IfThen3, label %IfElse3
IfThen3:
  %tmp14 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp15 = call i32 (i8 *, ...)* @printf(i8 * %tmp14, i32 100)
  br label %IfEnd3
IfEnd3:
  br label %WhileTest2
WhileEnd2:
  br label %IfEnd1
IfElse1:
  %tmp16 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp17 = call i32 (i8 *, ...)* @printf(i8 * %tmp16, i32 200)
  br label %IfEnd1
IfEnd1:
  br label %IfEnd0
IfElse0:
  %tmp18 = icmp eq i32 3, 3
  br i1 %tmp18, label %IfThen4, label %IfElse4
IfThen4:
  store i32 40, i32 * %c
  br label %IfEnd4
IfElse4:
  br label %WhileTest5
WhileTest5:
  %tmp19 = icmp slt i32 4, 3
  br i1 %tmp19, label %WhileStart5, label %WhileEnd5
WhileStart5:
  %tmp20 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp21 = call i32 (i8 *, ...)* @printf(i8 * %tmp20, i32 300)
  br label %WhileTest5
WhileEnd5:
  br label %IfEnd4
IfEnd4:
  store i32 60, i32 * %c
  br label %IfEnd0
IfEnd0:
  %tmp22 = load i32 * %tmp7
  ret i32 %tmp22
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
