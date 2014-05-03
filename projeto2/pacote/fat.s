@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp3 = alloca i32
  store i32 0, i32 * %tmp3
  %tmp8 = mul i32 0, 1
  %tmp9 = call i8* @malloc ( i32 %tmp8)
  %tmp7 = bitcast i8* %tmp9 to %class.Fac*
  %tmp6 = call i32  @__ComputeFac_Fac(%class.Fac * %tmp7, i32 10)
  %tmp10 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp11 = call i32 (i8 *, ...)* @printf(i8 * %tmp10, i32 %tmp6)
  %tmp12 = load i32 * %tmp3
  ret i32 %tmp12
}
%class.Fac = type { }
define i32 @__ComputeFac_Fac(%class.Fac * %this, i32 %num) {
entry0:
  %num_addr = alloca i32
  store i32 %num, i32 * %num_addr
  %num_aux = alloca i32
  %tmp14 = load i32 * %num_addr
  %tmp15 = icmp slt i32 %tmp14, 1
  br i1 %tmp15, label %IfThen0, label %IfElse0
IfThen0:
  store i32 1, i32 * %num_aux
  br label %IfEnd0
IfElse0:
  %tmp17 = load i32 * %num_addr
  %tmp23 = load i32 * %num_addr
  %tmp24 = sub i32 %tmp23, 1
  %tmp20 = call i32  @__ComputeFac_Fac(%class.Fac * %this, i32 %tmp24)
  %tmp25 = mul i32 %tmp17, %tmp20
  store i32 %tmp25, i32 * %num_aux
  br label %IfEnd0
IfEnd0:
  %tmp28 = load i32 * %num_aux
  ret i32 %tmp28
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
