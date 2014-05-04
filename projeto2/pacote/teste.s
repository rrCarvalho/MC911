@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp5 = alloca i32
  store i32 0, i32 * %tmp5
  %tmp10 = mul i32 8, 1
  %tmp11 = call i8* @malloc ( i32 %tmp10)
  %tmp9 = bitcast i8* %tmp11 to %class.b*
  %tmp8 = call i32  @__m_b(%class.b * %tmp9)
  %tmp12 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp13 = call i32 (i8 *, ...)* @printf(i8 * %tmp12, i32 %tmp8)
  %tmp14 = load i32 * %tmp5
  ret i32 %tmp14
}
%struct.array = type { i32, i32 * }
%class.b = type { %struct.array * }
define i32 @__m_b(%class.b * %this) {
entry0:
  %j = alloca %struct.array *
  %i = alloca i32
  %tmp16 = mul i32 12, 1
  %tmp17 = call i8* @malloc ( i32 %tmp16)
  %tmp15 = bitcast i8* %tmp17 to %struct.array*
  %tmp19 = mul i32 4, 7
  %tmp20 = call i8* @malloc ( i32 %tmp19)
  %tmp18 = bitcast i8* %tmp20 to i32*
  %tmp21 = getelementptr %struct.array * %tmp15, i32 0, i32 1
  store i32 * %tmp18, i32 * * %tmp21
  %tmp22 = getelementptr %struct.array * %tmp15, i32 0, i32 0
  store i32 7, i32 * %tmp22
  store %struct.array * %tmp15, %struct.array * * %j
  %tmp23 = add i32 1, 22
  %tmp24 = load %struct.array * * %j
  %tmp25 = getelementptr %struct.array * %tmp24, i32 0, i32 1
  %tmp26 = load i32 * * %tmp25
  %tmp27 = getelementptr i32 * %tmp26, i32 3
  store i32 %tmp23, i32 * %tmp27
  %tmp29 = load %struct.array * * %j
  %tmp30 = getelementptr %struct.array * %tmp29, i32 0, i32 0
  %tmp31 = load i32 * %tmp30
  store i32 %tmp31, i32 * %i
  %tmp34 = load i32 * %i
  ret i32 %tmp34
}
define i32 @__n_b(%class.b * %this) {
entry0:
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
