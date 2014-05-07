@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry0:
  %tmp10 = alloca i32
  store i32 0, i32 * %tmp10
  %tmp15 = mul i32 16, 1
  %tmp16 = call i8* @malloc ( i32 %tmp15)
  %tmp14 = bitcast i8* %tmp16 to %class.b*
  call void  @__b_b(%class.b * %tmp14)
  %tmp13 = call i32  @__m_b(%class.b * %tmp14, i32 10)
  %tmp17 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp18 = call i32 (i8 *, ...)* @printf(i8 * %tmp17, i32 %tmp13)
  %tmp19 = load i32 * %tmp10
  ret i32 %tmp19
}
%struct.array = type { i32, i32 * }
%class.b = type { %class.c *, %struct.array * }
define i32 @__m_b(%class.b * %this, i32 %ss) {
entry0:
  %ss_addr = alloca i32
  store i32 %ss, i32 * %ss_addr
  %k = alloca i32
  %tmp21 = getelementptr %class.b * %this, i32 0, i32 0
  %tmp22 = load %class.c * * %tmp21
  %tmp20 = getelementptr %class.c * %tmp22, i32 0, i32 0
  store i32 2, i32 * %tmp20
  %tmp27 = getelementptr %class.b * %this, i32 0, i32 0
  %tmp28 = load %class.c * * %tmp27
  %tmp26 = getelementptr %class.c * %tmp28, i32 0, i32 0
  %tmp25 = load i32 * %tmp26
  ret i32 %tmp25
}
define i32 @__n_b(%class.b * %this, i32 %sz) {
entry0:
  %sz_addr = alloca i32
  store i32 %sz, i32 * %sz_addr
  %tmp32 = getelementptr %class.b * %this, i32 0, i32 1
  %tmp31 = load %struct.array * * %tmp32
  %tmp33 = getelementptr %struct.array * %tmp31, i32 0, i32 0
  %tmp34 = load i32 * %tmp33
  ret i32 %tmp34
}
define void @__b_b(%class.b * %this) {
entry0:
  %this_addr = alloca %class.b *
  store %class.b * %this, %class.b * * %this_addr
  %tmp35 = load %class.b * * %this_addr
  %tmp36 = bitcast %class.b * * %this_addr to %class.c *
  call void  @__c_c(%class.c * %tmp36)
  %tmp37 = getelementptr %class.b * %this, i32 0, i32 0
  store %class.c * %tmp36, %class.c * %tmp37
  ret void 
}
%class.c = type { i32 }
define void @__c_c(%class.c * %this) {
entry0:
  %this_addr = alloca %class.c *
  store %class.c * %this, %class.c * * %this_addr
  ret void 
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
