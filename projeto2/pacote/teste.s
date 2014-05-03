@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp6 = alloca i32
  store i32 0, i32 * %tmp6
  %tmp11 = mul i32 0, 1
  %tmp12 = call i8* @malloc ( i32 %tmp11)
  %tmp10 = bitcast i8* %tmp12 to %class.c*
  %tmp9 = call i32  @__n_c(%class.c * %tmp10)
  %tmp13 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp14 = call i32 (i8 *, ...)* @printf(i8 * %tmp13, i32 %tmp9)
  %tmp15 = load i32 * %tmp6
  ret i32 %tmp15
}
%struct.array = type { i32, i32 * }
%class.b = type { %struct.array * }
define i32 @__m_b(%class.b * %this, %struct.array * %j, i32 %h) {
entry0:
  %j_addr = alloca %struct.array *
  store %struct.array * %j, %struct.array * * %j_addr
  %h_addr = alloca i32
  store i32 %h, i32 * %h_addr
  %c = alloca %struct.array *
  %tmp17 = mul i32 12, 1
  %tmp18 = call i8* @malloc ( i32 %tmp17)
  %tmp16 = bitcast i8* %tmp18 to %struct.array*
  %tmp20 = mul i32 4, 7
  %tmp21 = call i8* @malloc ( i32 %tmp20)
  %tmp19 = bitcast i8* %tmp21 to i32*
  %tmp22 = getelementptr %struct.array * %tmp16, i32 0, i32 1
  store i32 * %tmp19, i32 * * %tmp22
  store %struct.array * %tmp16, %struct.array * * %j_addr
  ret i32 0
}
%class.c = type { }
define i32 @__n_c(%class.c * %this) {
entry0:
  ret i32 3334
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
