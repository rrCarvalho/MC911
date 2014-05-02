@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp10 = alloca i32
  store i32 0, i32 * %tmp10
  %tmp16 = mul i32 8, 1
  %tmp17 = call i8* @malloc ( i32 %tmp16)
  %tmp15 = bitcast i8* %tmp17 to %class.c*
  %tmp13 = call i32  @__mC_c(%class.c * %tmp15, i32 1)
  %tmp18 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp19 = call i32 (i8 *, ...)* @printf(i8 * %tmp18, i32 %tmp13)
  %tmp20 = load i32 * %tmp10
  ret i32 %tmp20
}
%class.b = type { i32, i32 * }
define i32 @__mA_b(%class.b * %this, i32 %i, i32 * %j) {
entry0:
  %i_addr = alloca i32
  store i32 %i, i32 * %i_addr
  %j_addr = alloca i32 *
  store i32 * %j, i32 * * %j_addr
  %c = alloca i32
  %d = alloca i32 *
  %tmp22 = load i32 * 0
  ret i32 %tmp22
}
%class.c = type { %class.b * }
define i32 @__mC_c(%class.c * %this, i32 %h) {
entry0:
  %h_addr = alloca i32
  store i32 %h, i32 * %h_addr
  %tmp25 = add i32 1, 2
  %tmp24 = load i32 * %tmp25
  ret i32 %tmp24
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
