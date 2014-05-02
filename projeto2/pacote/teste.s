@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = icmp eq i32 10, 10
  br i1 %tmp1, label %IfThen0, label %IfElse0
IfThen0:
  br label %IfEnd0
IfEnd0:
  %tmp2 = icmp eq i32 20, 20
  br i1 %tmp2, label %IfThen1, label %IfElse1
IfThen1:
  br label %IfEnd1
IfEnd1:
  %tmp3 = load i32 * %tmp0
  ret i32 %tmp3
}
%class.b = type { i32, i32 * }
define i32 @__met_(%class. * %this, i32 %i, i32 %j) {
entry0:
  %tmp9 = alloca i32
  store i32 0, i32 * %tmp9
  %i_addr = alloca i32
  store i32 %i, i32 * %i_addr
  %j_addr = alloca i32
  store i32 %j, i32 * %j_addr
  %c = alloca i32
  %d = alloca i32 *
  %tmp12 = icmp eq i32 1, 1
  br i1 %tmp12, label %IfThen0, label %IfElse0
IfThen0:
  store i32 10, i32 * %c
  %tmp13 = icmp eq i32 2, 2
  br i1 %tmp13, label %IfThen1, label %IfElse1
IfThen1:
  br label %WhileTest2
WhileTest2:
  %tmp14 = icmp slt i32 2, 1
  br i1 %tmp14, label %WhileStart2, label %WhileEnd2
WhileStart2:
  %tmp15 = icmp eq i32 4, 4
  br i1 %tmp15, label %IfThen3, label %IfElse3
IfThen3:
  %tmp16 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp17 = call i32 (i8 *, ...)* @printf(i8 * %tmp16, i32 100)
  br label %IfEnd3
IfEnd3:
  br label %WhileTest2
WhileEnd2:
  br label %IfEnd1
IfElse1:
  %tmp18 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp19 = call i32 (i8 *, ...)* @printf(i8 * %tmp18, i32 200)
  br label %IfEnd1
IfEnd1:
  br label %IfEnd0
IfElse0:
  %tmp20 = icmp eq i32 3, 3
  br i1 %tmp20, label %IfThen4, label %IfElse4
IfThen4:
  store i32 40, i32 * %c
  br label %IfEnd4
IfElse4:
  br label %WhileTest5
WhileTest5:
  %tmp21 = icmp slt i32 4, 3
  br i1 %tmp21, label %WhileStart5, label %WhileEnd5
WhileStart5:
  %tmp22 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp23 = call i32 (i8 *, ...)* @printf(i8 * %tmp22, i32 300)
  br label %WhileTest5
WhileEnd5:
  br label %IfEnd4
IfEnd4:
  store i32 60, i32 * %c
  br label %IfEnd0
IfEnd0:
  %tmp24 = load i32 * %tmp9
  ret i32 %tmp24
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
