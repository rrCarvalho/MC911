@.formatting.string = private constant [4 x i8] c"%d\0A\00"
%struct.array = type { i32, i32 * }
%class.BT = type { }
%class.Tree = type { %class.Tree *, %class.Tree *, i32, i1, i1, %class.Tree * }
define i32 @main() {
entry0:
  %tmp121 = alloca i32
  store i32 0, i32 * %tmp121
  %tmp126 = mul i32 0, 1
  %tmp127 = call i8* @malloc ( i32 %tmp126)
  %tmp125 = bitcast i8* %tmp127 to %class.BT*
  call void  @__BT_BT(%class.BT * %tmp125)
  %tmp124 = call i32  @__Start_BT(%class.BT * %tmp125)
  %tmp128 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp129 = call i32 (i8 *, ...)* @printf(i8 * %tmp128, i32 %tmp124)
  %tmp130 = load i32 * %tmp121
  ret i32 %tmp130
}
define i32 @__Start_BT(%class.BT * %this) {
entry0:
  %root = alloca %class.Tree *
  %ntb = alloca i1
  %nti = alloca i32
  %tmp132 = mul i32 30, 1
  %tmp133 = call i8* @malloc ( i32 %tmp132)
  %tmp131 = bitcast i8* %tmp133 to %class.Tree*
  call void  @__Tree_Tree(%class.Tree * %tmp131)
  store %class.Tree * %tmp131, %class.Tree * * %root
  %tmp138 = load %class.Tree * * %root
  %tmp136 = call i1  @__Init_Tree(%class.Tree * %tmp138, i32 16)
  store i1 %tmp136, i1 * %ntb
  %tmp143 = load %class.Tree * * %root
  %tmp141 = call i1  @__Print_Tree(%class.Tree * %tmp143)
  store i1 %tmp141, i1 * %ntb
  %tmp144 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp145 = call i32 (i8 *, ...)* @printf(i8 * %tmp144, i32 100000000)
  %tmp150 = load %class.Tree * * %root
  %tmp148 = call i1  @__Insert_Tree(%class.Tree * %tmp150, i32 8)
  store i1 %tmp148, i1 * %ntb
  %tmp155 = load %class.Tree * * %root
  %tmp153 = call i1  @__Print_Tree(%class.Tree * %tmp155)
  store i1 %tmp153, i1 * %ntb
  %tmp160 = load %class.Tree * * %root
  %tmp158 = call i1  @__Insert_Tree(%class.Tree * %tmp160, i32 24)
  store i1 %tmp158, i1 * %ntb
  %tmp165 = load %class.Tree * * %root
  %tmp163 = call i1  @__Insert_Tree(%class.Tree * %tmp165, i32 4)
  store i1 %tmp163, i1 * %ntb
  %tmp170 = load %class.Tree * * %root
  %tmp168 = call i1  @__Insert_Tree(%class.Tree * %tmp170, i32 12)
  store i1 %tmp168, i1 * %ntb
  %tmp175 = load %class.Tree * * %root
  %tmp173 = call i1  @__Insert_Tree(%class.Tree * %tmp175, i32 20)
  store i1 %tmp173, i1 * %ntb
  %tmp180 = load %class.Tree * * %root
  %tmp178 = call i1  @__Insert_Tree(%class.Tree * %tmp180, i32 28)
  store i1 %tmp178, i1 * %ntb
  %tmp185 = load %class.Tree * * %root
  %tmp183 = call i1  @__Insert_Tree(%class.Tree * %tmp185, i32 14)
  store i1 %tmp183, i1 * %ntb
  %tmp190 = load %class.Tree * * %root
  %tmp188 = call i1  @__Print_Tree(%class.Tree * %tmp190)
  store i1 %tmp188, i1 * %ntb
  %tmp195 = load %class.Tree * * %root
  %tmp193 = call i32  @__Search_Tree(%class.Tree * %tmp195, i32 24)
  %tmp196 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp197 = call i32 (i8 *, ...)* @printf(i8 * %tmp196, i32 %tmp193)
  %tmp202 = load %class.Tree * * %root
  %tmp200 = call i32  @__Search_Tree(%class.Tree * %tmp202, i32 12)
  %tmp203 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp204 = call i32 (i8 *, ...)* @printf(i8 * %tmp203, i32 %tmp200)
  %tmp209 = load %class.Tree * * %root
  %tmp207 = call i32  @__Search_Tree(%class.Tree * %tmp209, i32 16)
  %tmp210 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp211 = call i32 (i8 *, ...)* @printf(i8 * %tmp210, i32 %tmp207)
  %tmp216 = load %class.Tree * * %root
  %tmp214 = call i32  @__Search_Tree(%class.Tree * %tmp216, i32 50)
  %tmp217 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp218 = call i32 (i8 *, ...)* @printf(i8 * %tmp217, i32 %tmp214)
  %tmp223 = load %class.Tree * * %root
  %tmp221 = call i32  @__Search_Tree(%class.Tree * %tmp223, i32 12)
  %tmp224 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp225 = call i32 (i8 *, ...)* @printf(i8 * %tmp224, i32 %tmp221)
  %tmp230 = load %class.Tree * * %root
  %tmp228 = call i1  @__Delete_Tree(%class.Tree * %tmp230, i32 12)
  store i1 %tmp228, i1 * %ntb
  %tmp235 = load %class.Tree * * %root
  %tmp233 = call i1  @__Print_Tree(%class.Tree * %tmp235)
  store i1 %tmp233, i1 * %ntb
  %tmp240 = load %class.Tree * * %root
  %tmp238 = call i32  @__Search_Tree(%class.Tree * %tmp240, i32 12)
  %tmp241 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp242 = call i32 (i8 *, ...)* @printf(i8 * %tmp241, i32 %tmp238)
  ret i32 0
}
define void @__BT_BT(%class.BT * %this) {
entry0:
  %this_addr = alloca %class.BT *
  store %class.BT * %this, %class.BT * * %this_addr
  ret void 
}
define i1 @__Init_Tree(%class.Tree * %this, i32 %v_key) {
entry0:
  %v_key_addr = alloca i32
  store i32 %v_key, i32 * %v_key_addr
  %tmp245 = load i32 * %v_key_addr
  %tmp246 = getelementptr %class.Tree * %this, i32 0, i32 2
  store i32 %tmp245, i32 * %tmp246
  %tmp247 = getelementptr %class.Tree * %this, i32 0, i32 3
  store i1 false, i1 * %tmp247
  %tmp248 = getelementptr %class.Tree * %this, i32 0, i32 4
  store i1 false, i1 * %tmp248
  ret i1 true
}
define i1 @__SetRight_Tree(%class.Tree * %this, %class.Tree * %rn) {
entry0:
  %rn_addr = alloca %class.Tree *
  store %class.Tree * %rn, %class.Tree * * %rn_addr
  %tmp251 = load %class.Tree * * %rn_addr
  %tmp252 = getelementptr %class.Tree * %this, i32 0, i32 1
  store %class.Tree * %tmp251, %class.Tree * * %tmp252
  ret i1 true
}
define i1 @__SetLeft_Tree(%class.Tree * %this, %class.Tree * %ln) {
entry0:
  %ln_addr = alloca %class.Tree *
  store %class.Tree * %ln, %class.Tree * * %ln_addr
  %tmp255 = load %class.Tree * * %ln_addr
  %tmp256 = getelementptr %class.Tree * %this, i32 0, i32 0
  store %class.Tree * %tmp255, %class.Tree * * %tmp256
  ret i1 true
}
define %class.Tree * @__GetRight_Tree(%class.Tree * %this) {
entry0:
  %tmp261 = getelementptr %class.Tree * %this, i32 0, i32 1
  %tmp260 = load %class.Tree * * %tmp261
  ret %class.Tree * %tmp260
}
define %class.Tree * @__GetLeft_Tree(%class.Tree * %this) {
entry0:
  %tmp265 = getelementptr %class.Tree * %this, i32 0, i32 0
  %tmp264 = load %class.Tree * * %tmp265
  ret %class.Tree * %tmp264
}
define i32 @__GetKey_Tree(%class.Tree * %this) {
entry0:
  %tmp269 = getelementptr %class.Tree * %this, i32 0, i32 2
  %tmp268 = load i32 * %tmp269
  ret i32 %tmp268
}
define i1 @__SetKey_Tree(%class.Tree * %this, i32 %v_key) {
entry0:
  %v_key_addr = alloca i32
  store i32 %v_key, i32 * %v_key_addr
  %tmp271 = load i32 * %v_key_addr
  %tmp272 = getelementptr %class.Tree * %this, i32 0, i32 2
  store i32 %tmp271, i32 * %tmp272
  ret i1 true
}
define i1 @__GetHas_Right_Tree(%class.Tree * %this) {
entry0:
  %tmp277 = getelementptr %class.Tree * %this, i32 0, i32 4
  %tmp276 = load i1 * %tmp277
  ret i1 %tmp276
}
define i1 @__GetHas_Left_Tree(%class.Tree * %this) {
entry0:
  %tmp281 = getelementptr %class.Tree * %this, i32 0, i32 3
  %tmp280 = load i1 * %tmp281
  ret i1 %tmp280
}
define i1 @__SetHas_Left_Tree(%class.Tree * %this, i1 %val) {
entry0:
  %val_addr = alloca i1
  store i1 %val, i1 * %val_addr
  %tmp283 = load i1 * %val_addr
  %tmp284 = getelementptr %class.Tree * %this, i32 0, i32 3
  store i1 %tmp283, i1 * %tmp284
  ret i1 true
}
define i1 @__SetHas_Right_Tree(%class.Tree * %this, i1 %val) {
entry0:
  %val_addr = alloca i1
  store i1 %val, i1 * %val_addr
  %tmp287 = load i1 * %val_addr
  %tmp288 = getelementptr %class.Tree * %this, i32 0, i32 4
  store i1 %tmp287, i1 * %tmp288
  ret i1 true
}
define i1 @__Compare_Tree(%class.Tree * %this, i32 %num1, i32 %num2) {
entry0:
  %num1_addr = alloca i32
  store i32 %num1, i32 * %num1_addr
  %num2_addr = alloca i32
  store i32 %num2, i32 * %num2_addr
  %ntb = alloca i1
  %nti = alloca i32
  store i1 false, i1 * %ntb
  %tmp291 = load i32 * %num2_addr
  %tmp292 = add i32 %tmp291, 1
  store i32 %tmp292, i32 * %nti
  %tmp294 = load i32 * %num1_addr
  %tmp296 = load i32 * %num2_addr
  %tmp297 = icmp slt i32 %tmp294, %tmp296
  br i1 %tmp297, label %IfThen0, label %IfElse0
IfThen0:
  store i1 false, i1 * %ntb
  br label %IfEnd0
IfElse0:
  %tmp299 = load i32 * %num1_addr
  %tmp301 = load i32 * %nti
  %tmp302 = icmp slt i32 %tmp299, %tmp301
  %tmp303 = xor i1 %tmp302, 1
  br i1 %tmp303, label %IfThen1, label %IfElse1
IfThen1:
  store i1 false, i1 * %ntb
  br label %IfEnd1
IfElse1:
  store i1 true, i1 * %ntb
  br label %IfEnd1
IfEnd1:
  br label %IfEnd0
IfEnd0:
  %tmp306 = load i1 * %ntb
  ret i1 %tmp306
}
define i1 @__Insert_Tree(%class.Tree * %this, i32 %v_key) {
entry0:
  %v_key_addr = alloca i32
  store i32 %v_key, i32 * %v_key_addr
  %new_node = alloca %class.Tree *
  %ntb = alloca i1
  %cont = alloca i1
  %key_aux = alloca i32
  %current_node = alloca %class.Tree *
  %tmp308 = mul i32 30, 1
  %tmp309 = call i8* @malloc ( i32 %tmp308)
  %tmp307 = bitcast i8* %tmp309 to %class.Tree*
  call void  @__Tree_Tree(%class.Tree * %tmp307)
  store %class.Tree * %tmp307, %class.Tree * * %new_node
  %tmp314 = load %class.Tree * * %new_node
  %tmp316 = load i32 * %v_key_addr
  %tmp312 = call i1  @__Init_Tree(%class.Tree * %tmp314, i32 %tmp316)
  store i1 %tmp312, i1 * %ntb
  store %class.Tree * %this, %class.Tree * * %current_node
  store i1 true, i1 * %cont
  br label %WhileTest0
WhileTest0:
  %tmp319 = load i1 * %cont
  br i1 %tmp319, label %WhileStart0, label %WhileEnd0
WhileStart0:
  %tmp324 = load %class.Tree * * %current_node
  %tmp322 = call i32  @__GetKey_Tree(%class.Tree * %tmp324)
  store i32 %tmp322, i32 * %key_aux
  %tmp326 = load i32 * %v_key_addr
  %tmp328 = load i32 * %key_aux
  %tmp329 = icmp slt i32 %tmp326, %tmp328
  br i1 %tmp329, label %IfThen1, label %IfElse1
IfThen1:
  %tmp334 = load %class.Tree * * %current_node
  %tmp332 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp334)
  br i1 %tmp332, label %IfThen2, label %IfElse2
IfThen2:
  %tmp339 = load %class.Tree * * %current_node
  %tmp337 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp339)
  store %class.Tree * %tmp337, %class.Tree * * %current_node
  br label %IfEnd2
IfElse2:
  store i1 false, i1 * %cont
  %tmp344 = load %class.Tree * * %current_node
  %tmp342 = call i1  @__SetHas_Left_Tree(%class.Tree * %tmp344, i1 true)
  store i1 %tmp342, i1 * %ntb
  %tmp349 = load %class.Tree * * %current_node
  %tmp351 = load %class.Tree * * %new_node
  %tmp347 = call i1  @__SetLeft_Tree(%class.Tree * %tmp349, %class.Tree * %tmp351)
  store i1 %tmp347, i1 * %ntb
  br label %IfEnd2
IfEnd2:
  br label %IfEnd1
IfElse1:
  %tmp356 = load %class.Tree * * %current_node
  %tmp354 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp356)
  br i1 %tmp354, label %IfThen3, label %IfElse3
IfThen3:
  %tmp361 = load %class.Tree * * %current_node
  %tmp359 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp361)
  store %class.Tree * %tmp359, %class.Tree * * %current_node
  br label %IfEnd3
IfElse3:
  store i1 false, i1 * %cont
  %tmp366 = load %class.Tree * * %current_node
  %tmp364 = call i1  @__SetHas_Right_Tree(%class.Tree * %tmp366, i1 true)
  store i1 %tmp364, i1 * %ntb
  %tmp371 = load %class.Tree * * %current_node
  %tmp373 = load %class.Tree * * %new_node
  %tmp369 = call i1  @__SetRight_Tree(%class.Tree * %tmp371, %class.Tree * %tmp373)
  store i1 %tmp369, i1 * %ntb
  br label %IfEnd3
IfEnd3:
  br label %IfEnd1
IfEnd1:
  br label %WhileTest0
WhileEnd0:
  ret i1 true
}
define i1 @__Delete_Tree(%class.Tree * %this, i32 %v_key) {
entry0:
  %v_key_addr = alloca i32
  store i32 %v_key, i32 * %v_key_addr
  %current_node = alloca %class.Tree *
  %parent_node = alloca %class.Tree *
  %cont = alloca i1
  %found = alloca i1
  %is_root = alloca i1
  %key_aux = alloca i32
  %ntb = alloca i1
  store %class.Tree * %this, %class.Tree * * %current_node
  store %class.Tree * %this, %class.Tree * * %parent_node
  store i1 true, i1 * %cont
  store i1 false, i1 * %found
  store i1 true, i1 * %is_root
  br label %WhileTest0
WhileTest0:
  %tmp378 = load i1 * %cont
  br i1 %tmp378, label %WhileStart0, label %WhileEnd0
WhileStart0:
  %tmp383 = load %class.Tree * * %current_node
  %tmp381 = call i32  @__GetKey_Tree(%class.Tree * %tmp383)
  store i32 %tmp381, i32 * %key_aux
  %tmp385 = load i32 * %v_key_addr
  %tmp387 = load i32 * %key_aux
  %tmp388 = icmp slt i32 %tmp385, %tmp387
  br i1 %tmp388, label %IfThen1, label %IfElse1
IfThen1:
  %tmp393 = load %class.Tree * * %current_node
  %tmp391 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp393)
  br i1 %tmp391, label %IfThen2, label %IfElse2
IfThen2:
  %tmp395 = load %class.Tree * * %current_node
  store %class.Tree * %tmp395, %class.Tree * * %parent_node
  %tmp400 = load %class.Tree * * %current_node
  %tmp398 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp400)
  store %class.Tree * %tmp398, %class.Tree * * %current_node
  br label %IfEnd2
IfElse2:
  store i1 false, i1 * %cont
  br label %IfEnd2
IfEnd2:
  br label %IfEnd1
IfElse1:
  %tmp402 = load i32 * %key_aux
  %tmp404 = load i32 * %v_key_addr
  %tmp405 = icmp slt i32 %tmp402, %tmp404
  br i1 %tmp405, label %IfThen3, label %IfElse3
IfThen3:
  %tmp410 = load %class.Tree * * %current_node
  %tmp408 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp410)
  br i1 %tmp408, label %IfThen4, label %IfElse4
IfThen4:
  %tmp412 = load %class.Tree * * %current_node
  store %class.Tree * %tmp412, %class.Tree * * %parent_node
  %tmp417 = load %class.Tree * * %current_node
  %tmp415 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp417)
  store %class.Tree * %tmp415, %class.Tree * * %current_node
  br label %IfEnd4
IfElse4:
  store i1 false, i1 * %cont
  br label %IfEnd4
IfEnd4:
  br label %IfEnd3
IfElse3:
  %tmp419 = load i1 * %is_root
  br i1 %tmp419, label %IfThen5, label %IfElse5
IfThen5:
  %tmp424 = load %class.Tree * * %current_node
  %tmp422 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp424)
  %tmp425 = xor i1 %tmp422, 1
  %tmp430 = load %class.Tree * * %current_node
  %tmp428 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp430)
  %tmp431 = xor i1 %tmp428, 1
  %tmp432 = and i1 %tmp425, %tmp431
  br i1 %tmp432, label %IfThen6, label %IfElse6
IfThen6:
  store i1 true, i1 * %ntb
  br label %IfEnd6
IfElse6:
  %tmp438 = load %class.Tree * * %parent_node
  %tmp440 = load %class.Tree * * %current_node
  %tmp435 = call i1  @__Remove_Tree(%class.Tree * %this, %class.Tree * %tmp438, %class.Tree * %tmp440)
  store i1 %tmp435, i1 * %ntb
  br label %IfEnd6
IfEnd6:
  br label %IfEnd5
IfElse5:
  %tmp446 = load %class.Tree * * %parent_node
  %tmp448 = load %class.Tree * * %current_node
  %tmp443 = call i1  @__Remove_Tree(%class.Tree * %this, %class.Tree * %tmp446, %class.Tree * %tmp448)
  store i1 %tmp443, i1 * %ntb
  br label %IfEnd5
IfEnd5:
  store i1 true, i1 * %found
  store i1 false, i1 * %cont
  br label %IfEnd3
IfEnd3:
  br label %IfEnd1
IfEnd1:
  store i1 false, i1 * %is_root
  br label %WhileTest0
WhileEnd0:
  %tmp451 = load i1 * %found
  ret i1 %tmp451
}
define i1 @__Remove_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry0:
  %p_node_addr = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node_addr
  %c_node_addr = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node_addr
  %ntb = alloca i1
  %auxkey1 = alloca i32
  %auxkey2 = alloca i32
  %tmp456 = load %class.Tree * * %c_node_addr
  %tmp454 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp456)
  br i1 %tmp454, label %IfThen0, label %IfElse0
IfThen0:
  %tmp462 = load %class.Tree * * %p_node_addr
  %tmp464 = load %class.Tree * * %c_node_addr
  %tmp459 = call i1  @__RemoveLeft_Tree(%class.Tree * %this, %class.Tree * %tmp462, %class.Tree * %tmp464)
  store i1 %tmp459, i1 * %ntb
  br label %IfEnd0
IfElse0:
  %tmp469 = load %class.Tree * * %c_node_addr
  %tmp467 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp469)
  br i1 %tmp467, label %IfThen1, label %IfElse1
IfThen1:
  %tmp475 = load %class.Tree * * %p_node_addr
  %tmp477 = load %class.Tree * * %c_node_addr
  %tmp472 = call i1  @__RemoveRight_Tree(%class.Tree * %this, %class.Tree * %tmp475, %class.Tree * %tmp477)
  store i1 %tmp472, i1 * %ntb
  br label %IfEnd1
IfElse1:
  %tmp482 = load %class.Tree * * %c_node_addr
  %tmp480 = call i32  @__GetKey_Tree(%class.Tree * %tmp482)
  store i32 %tmp480, i32 * %auxkey1
  %tmp490 = load %class.Tree * * %p_node_addr
  %tmp488 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp490)
  %tmp485 = call i32  @__GetKey_Tree(%class.Tree * %tmp488)
  store i32 %tmp485, i32 * %auxkey2
  %tmp496 = load i32 * %auxkey1
  %tmp498 = load i32 * %auxkey2
  %tmp493 = call i1  @__Compare_Tree(%class.Tree * %this, i32 %tmp496, i32 %tmp498)
  br i1 %tmp493, label %IfThen2, label %IfElse2
IfThen2:
  %tmp503 = load %class.Tree * * %p_node_addr
  %tmp506 = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp505 = load %class.Tree * * %tmp506
  %tmp501 = call i1  @__SetLeft_Tree(%class.Tree * %tmp503, %class.Tree * %tmp505)
  store i1 %tmp501, i1 * %ntb
  %tmp511 = load %class.Tree * * %p_node_addr
  %tmp509 = call i1  @__SetHas_Left_Tree(%class.Tree * %tmp511, i1 false)
  store i1 %tmp509, i1 * %ntb
  br label %IfEnd2
IfElse2:
  %tmp516 = load %class.Tree * * %p_node_addr
  %tmp519 = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp518 = load %class.Tree * * %tmp519
  %tmp514 = call i1  @__SetRight_Tree(%class.Tree * %tmp516, %class.Tree * %tmp518)
  store i1 %tmp514, i1 * %ntb
  %tmp524 = load %class.Tree * * %p_node_addr
  %tmp522 = call i1  @__SetHas_Right_Tree(%class.Tree * %tmp524, i1 false)
  store i1 %tmp522, i1 * %ntb
  br label %IfEnd2
IfEnd2:
  br label %IfEnd1
IfEnd1:
  br label %IfEnd0
IfEnd0:
  ret i1 true
}
define i1 @__RemoveRight_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry0:
  %p_node_addr = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node_addr
  %c_node_addr = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node_addr
  %ntb = alloca i1
  br label %WhileTest0
WhileTest0:
  %tmp530 = load %class.Tree * * %c_node_addr
  %tmp528 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp530)
  br i1 %tmp528, label %WhileStart0, label %WhileEnd0
WhileStart0:
  %tmp535 = load %class.Tree * * %c_node_addr
  %tmp543 = load %class.Tree * * %c_node_addr
  %tmp541 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp543)
  %tmp538 = call i32  @__GetKey_Tree(%class.Tree * %tmp541)
  %tmp533 = call i1  @__SetKey_Tree(%class.Tree * %tmp535, i32 %tmp538)
  store i1 %tmp533, i1 * %ntb
  %tmp545 = load %class.Tree * * %c_node_addr
  store %class.Tree * %tmp545, %class.Tree * * %p_node_addr
  %tmp550 = load %class.Tree * * %c_node_addr
  %tmp548 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp550)
  store %class.Tree * %tmp548, %class.Tree * * %c_node_addr
  br label %WhileTest0
WhileEnd0:
  %tmp555 = load %class.Tree * * %p_node_addr
  %tmp558 = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp557 = load %class.Tree * * %tmp558
  %tmp553 = call i1  @__SetRight_Tree(%class.Tree * %tmp555, %class.Tree * %tmp557)
  store i1 %tmp553, i1 * %ntb
  %tmp563 = load %class.Tree * * %p_node_addr
  %tmp561 = call i1  @__SetHas_Right_Tree(%class.Tree * %tmp563, i1 false)
  store i1 %tmp561, i1 * %ntb
  ret i1 true
}
define i1 @__RemoveLeft_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry0:
  %p_node_addr = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node_addr
  %c_node_addr = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node_addr
  %ntb = alloca i1
  br label %WhileTest0
WhileTest0:
  %tmp569 = load %class.Tree * * %c_node_addr
  %tmp567 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp569)
  br i1 %tmp567, label %WhileStart0, label %WhileEnd0
WhileStart0:
  %tmp574 = load %class.Tree * * %c_node_addr
  %tmp582 = load %class.Tree * * %c_node_addr
  %tmp580 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp582)
  %tmp577 = call i32  @__GetKey_Tree(%class.Tree * %tmp580)
  %tmp572 = call i1  @__SetKey_Tree(%class.Tree * %tmp574, i32 %tmp577)
  store i1 %tmp572, i1 * %ntb
  %tmp584 = load %class.Tree * * %c_node_addr
  store %class.Tree * %tmp584, %class.Tree * * %p_node_addr
  %tmp589 = load %class.Tree * * %c_node_addr
  %tmp587 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp589)
  store %class.Tree * %tmp587, %class.Tree * * %c_node_addr
  br label %WhileTest0
WhileEnd0:
  %tmp594 = load %class.Tree * * %p_node_addr
  %tmp597 = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp596 = load %class.Tree * * %tmp597
  %tmp592 = call i1  @__SetLeft_Tree(%class.Tree * %tmp594, %class.Tree * %tmp596)
  store i1 %tmp592, i1 * %ntb
  %tmp602 = load %class.Tree * * %p_node_addr
  %tmp600 = call i1  @__SetHas_Left_Tree(%class.Tree * %tmp602, i1 false)
  store i1 %tmp600, i1 * %ntb
  ret i1 true
}
define i32 @__Search_Tree(%class.Tree * %this, i32 %v_key) {
entry0:
  %v_key_addr = alloca i32
  store i32 %v_key, i32 * %v_key_addr
  %cont = alloca i1
  %ifound = alloca i32
  %current_node = alloca %class.Tree *
  %key_aux = alloca i32
  store %class.Tree * %this, %class.Tree * * %current_node
  store i1 true, i1 * %cont
  store i32 0, i32 * %ifound
  br label %WhileTest0
WhileTest0:
  %tmp606 = load i1 * %cont
  br i1 %tmp606, label %WhileStart0, label %WhileEnd0
WhileStart0:
  %tmp611 = load %class.Tree * * %current_node
  %tmp609 = call i32  @__GetKey_Tree(%class.Tree * %tmp611)
  store i32 %tmp609, i32 * %key_aux
  %tmp613 = load i32 * %v_key_addr
  %tmp615 = load i32 * %key_aux
  %tmp616 = icmp slt i32 %tmp613, %tmp615
  br i1 %tmp616, label %IfThen1, label %IfElse1
IfThen1:
  %tmp621 = load %class.Tree * * %current_node
  %tmp619 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp621)
  br i1 %tmp619, label %IfThen2, label %IfElse2
IfThen2:
  %tmp626 = load %class.Tree * * %current_node
  %tmp624 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp626)
  store %class.Tree * %tmp624, %class.Tree * * %current_node
  br label %IfEnd2
IfElse2:
  store i1 false, i1 * %cont
  br label %IfEnd2
IfEnd2:
  br label %IfEnd1
IfElse1:
  %tmp628 = load i32 * %key_aux
  %tmp630 = load i32 * %v_key_addr
  %tmp631 = icmp slt i32 %tmp628, %tmp630
  br i1 %tmp631, label %IfThen3, label %IfElse3
IfThen3:
  %tmp636 = load %class.Tree * * %current_node
  %tmp634 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp636)
  br i1 %tmp634, label %IfThen4, label %IfElse4
IfThen4:
  %tmp641 = load %class.Tree * * %current_node
  %tmp639 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp641)
  store %class.Tree * %tmp639, %class.Tree * * %current_node
  br label %IfEnd4
IfElse4:
  store i1 false, i1 * %cont
  br label %IfEnd4
IfEnd4:
  br label %IfEnd3
IfElse3:
  store i32 1, i32 * %ifound
  store i1 false, i1 * %cont
  br label %IfEnd3
IfEnd3:
  br label %IfEnd1
IfEnd1:
  br label %WhileTest0
WhileEnd0:
  %tmp644 = load i32 * %ifound
  ret i32 %tmp644
}
define i1 @__Print_Tree(%class.Tree * %this) {
entry0:
  %current_node = alloca %class.Tree *
  %ntb = alloca i1
  store %class.Tree * %this, %class.Tree * * %current_node
  %tmp651 = load %class.Tree * * %current_node
  %tmp648 = call i1  @__RecPrint_Tree(%class.Tree * %this, %class.Tree * %tmp651)
  store i1 %tmp648, i1 * %ntb
  ret i1 true
}
define i1 @__RecPrint_Tree(%class.Tree * %this, %class.Tree * %node) {
entry0:
  %node_addr = alloca %class.Tree *
  store %class.Tree * %node, %class.Tree * * %node_addr
  %ntb = alloca i1
  %tmp657 = load %class.Tree * * %node_addr
  %tmp655 = call i1  @__GetHas_Left_Tree(%class.Tree * %tmp657)
  br i1 %tmp655, label %IfThen0, label %IfElse0
IfThen0:
  %tmp666 = load %class.Tree * * %node_addr
  %tmp664 = call %class.Tree *  @__GetLeft_Tree(%class.Tree * %tmp666)
  %tmp660 = call i1  @__RecPrint_Tree(%class.Tree * %this, %class.Tree * %tmp664)
  store i1 %tmp660, i1 * %ntb
  br label %IfEnd0
IfElse0:
  store i1 true, i1 * %ntb
  br label %IfEnd0
IfEnd0:
  %tmp671 = load %class.Tree * * %node_addr
  %tmp669 = call i32  @__GetKey_Tree(%class.Tree * %tmp671)
  %tmp672 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp673 = call i32 (i8 *, ...)* @printf(i8 * %tmp672, i32 %tmp669)
  %tmp678 = load %class.Tree * * %node_addr
  %tmp676 = call i1  @__GetHas_Right_Tree(%class.Tree * %tmp678)
  br i1 %tmp676, label %IfThen1, label %IfElse1
IfThen1:
  %tmp687 = load %class.Tree * * %node_addr
  %tmp685 = call %class.Tree *  @__GetRight_Tree(%class.Tree * %tmp687)
  %tmp681 = call i1  @__RecPrint_Tree(%class.Tree * %this, %class.Tree * %tmp685)
  store i1 %tmp681, i1 * %ntb
  br label %IfEnd1
IfElse1:
  store i1 true, i1 * %ntb
  br label %IfEnd1
IfEnd1:
  ret i1 true
}
define void @__Tree_Tree(%class.Tree * %this) {
entry0:
  %this_addr = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this_addr
  ret void 
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
