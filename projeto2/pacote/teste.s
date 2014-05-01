@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = load i32 * %tmp0
  ret i32 %tmp1
}
%class.b = type { i32, i32 * }
define i32 @__met_(%class. * %this, i32 %i, i32 %j) {
entry:
  %tmp7 = alloca i32
  store i32 0, i32 * %tmp7
  %i_addr = alloca i32
  store i32 %i, i32 * %i_addr
  %j_addr = alloca i32
  store i32 %j, i32 * %j_addr
  %c = alloca i32
  %d = alloca i32 *
  store i32 10, i32 * %c
  %tmp10 = load i32 * %tmp7
  ret i32 %tmp10
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
