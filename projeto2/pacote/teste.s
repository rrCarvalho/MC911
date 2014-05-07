@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%struct.array = type { i32, i32 * }
%class.b = type { %class.e *, %struct.array * }
%class.c = type { %struct.array * }
%class.d = type { %class.c * }
%class.e = type { %class.d * }
define i32 @main() {
entry0:
  %tmp8 = alloca i32
  store i32 0, i32 * %tmp8
  %tmp13 = mul i32 16, 1
  %tmp14 = call i8* @malloc ( i32 %tmp13)
  %tmp12 = bitcast i8* %tmp14 to %class.b*
  call void  @__b_b(%class.b * %tmp12)
  %tmp11 = call i32  @__m_b(%class.b * %tmp12, i32 10)
  %tmp15 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp16 = call i32 (i8 *, ...)* @printf(i8 * %tmp15, i32 %tmp11)
  %tmp17 = load i32 * %tmp8
  ret i32 %tmp17
}
define i32 @__m_b(%class.b * %this, i32 %ss) {
entry0:
  %ss_addr = alloca i32
  store i32 %ss, i32 * %ss_addr
  %tmp19 = load i32 * %ss_addr
  %tmp21 = mul i32 12, 1
  %tmp22 = call i8* @malloc ( i32 %tmp21)
  %tmp20 = bitcast i8* %tmp22 to %struct.array*
  %tmp24 = mul i32 4, %tmp19
  %tmp25 = call i8* @malloc ( i32 %tmp24)
  %tmp23 = bitcast i8* %tmp25 to i32*
  %tmp26 = getelementptr %struct.array * %tmp20, i32 0, i32 1
  store i32 * %tmp23, i32 * * %tmp26
  %tmp27 = getelementptr %struct.array * %tmp20, i32 0, i32 0
  store i32 %tmp19, i32 * %tmp27
  %tmp29 = getelementptr %class.b * %this, i32 0, i32 0
  %tmp30 = load %class.c * * %tmp29
  %tmp28 = getelementptr %class.c * %tmp30, i32 0, i32 0
  store %struct.array * %tmp20, %struct.array * * %tmp28
  %tmp35 = getelementptr %class.b * %this, i32 0, i32 0
  %tmp36 = load %class.c * * %tmp35
  %tmp34 = getelementptr %class.c * %tmp36, i32 0, i32 0
  %tmp33 = load %struct.array * * %tmp34
  %tmp37 = getelementptr %struct.array * %tmp33, i32 0, i32 0
  %tmp38 = load i32 * %tmp37
  ret i32 %tmp38
}
define i32 @__n_b(%class.b * %this, i32 %sz) {
entry0:
  %sz_addr = alloca i32
  store i32 %sz, i32 * %sz_addr
  %tmp42 = getelementptr %class.b * %this, i32 0, i32 1
  %tmp41 = load %struct.array * * %tmp42
  %tmp43 = getelementptr %struct.array * %tmp41, i32 0, i32 0
  %tmp44 = load i32 * %tmp43
  ret i32 %tmp44
}
define void @__b_b(%class.b * %this) {
entry0:
  %this_addr = alloca %class.b *
  store %class.b * %this, %class.b * * %this_addr
  %tmp45 = load %class.b * * %this_addr
  %tmp46 = bitcast %class.b * * %this_addr to %class.e *
  call void  @__e_e(%class.e * %tmp46)
  %tmp47 = getelementptr %class.b * %this, i32 0, i32 0
  store %class.e * %tmp46, %class.e * * %tmp47
  ret void 
}
define void @__c_c(%class.c * %this) {
entry0:
  %this_addr = alloca %class.c *
  store %class.c * %this, %class.c * * %this_addr
  ret void 
}
define void @__d_d(%class.d * %this) {
entry0:
  %this_addr = alloca %class.d *
  store %class.d * %this, %class.d * * %this_addr
  %tmp48 = load %class.d * * %this_addr
  %tmp49 = bitcast %class.d * * %this_addr to %class.c *
  call void  @__c_c(%class.c * %tmp49)
  %tmp50 = getelementptr %class.d * %this, i32 0, i32 0
  store %class.c * %tmp49, %class.c * * %tmp50
  ret void 
}
define void @__e_e(%class.e * %this) {
entry0:
  %this_addr = alloca %class.e *
  store %class.e * %this, %class.e * * %this_addr
  %tmp51 = load %class.e * * %this_addr
  %tmp52 = bitcast %class.e * * %this_addr to %class.d *
  call void  @__d_d(%class.d * %tmp52)
  %tmp53 = getelementptr %class.e * %this, i32 0, i32 0
  store %class.d * %tmp52, %class.d * * %tmp53
  ret void 
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
