@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp5 = alloca i32
  store i32 0, i32 * %tmp5
  %tmp10 = mul i32 0, 1
  %tmp11 = call i8* @malloc ( i32 %tmp10)
  %tmp9 = bitcast i8* %tmp11 to %class.b*
  %tmp8 = call i32  @__m_b(%class.b * %tmp9)
  %tmp12 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp13 = call i32 (i8 *, ...)* @printf(i8 * %tmp12, i32 %tmp8)
  %tmp18 = mul i32 0, 1
  %tmp19 = call i8* @malloc ( i32 %tmp18)
  %tmp17 = bitcast i8* %tmp19 to %class.b*
  %tmp16 = call i32  @__n_b(%class.b * %tmp17, i32 45)
  %tmp20 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp21 = call i32 (i8 *, ...)* @printf(i8 * %tmp20, i32 %tmp16)
  %tmp26 = mul i32 0, 1
  %tmp27 = call i8* @malloc ( i32 %tmp26)
  %tmp25 = bitcast i8* %tmp27 to %class.b*
  %tmp24 = call i32  @__dd_b(%class.b * %tmp25)
  %tmp28 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp29 = call i32 (i8 *, ...)* @printf(i8 * %tmp28, i32 %tmp24)
  %tmp30 = load i32 * %tmp5
  ret i32 %tmp30
}
%class.b = type { }
define i32 @__m_b(%class.b * %this) {
entry0:
  %c = alloca i32
  store i32 1, i32 * %c
  %tmp32 = add i32 1, 2
  ret i32 %tmp32
}
define i32 @__n_b(%class.b * %this, i32 %f) {
entry0:
  %f_addr = alloca i32
  store i32 %f, i32 * %f_addr
  %tmp35 = load i32 * %f_addr
  ret i32 %tmp35
}
define i32 @__dd_b(%class.b * %this) {
entry0:
  ret i32 99
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
