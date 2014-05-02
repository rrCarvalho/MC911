@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp3 = alloca i32
  store i32 0, i32 * %tmp3
  %tmp9 = mul i32 0, 1
  %tmp10 = call i8* @malloc ( i32 %tmp9)
  %tmp8 = bitcast i8* %tmp10 to %class.Fac*
  %tmp6 = call i32  @__ComputeFac_Fac(%class.Fac * %tmp8, i32 10)
  %tmp11 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp12 = call i32 (i8 *, ...)* @printf(i8 * %tmp11, i32 %tmp6)
  %tmp13 = load i32 * %tmp3
  ret i32 %tmp13
}
%class.Fac = type { }
define i32 @__ComputeFac_Fac(%class.Fac * %this, i32 %num) {
entry0:
  %num_addr = alloca i32
  store i32 %num, i32 * %num_addr
  %num_aux = alloca i32
  %tmp15 = icmp slt i32 %num, 1
  br i1 %tmp15, label %IfThen0, label %IfElse0
IfThen0:
  store i32 1, i32 * %num_aux
  br label %IfEnd0
IfElse0:
  %tmp23 = sub i32 %num, 1
  %tmp19 = call i32  @__ComputeFac_Fac(%class.Fac * %this, i32 %tmp23)
  %tmp24 = mul i32 %num, %tmp19
  store i32 %tmp24, i32 * %num_aux
  br label %IfEnd0
IfEnd0:
  ret i32 %num_aux
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
