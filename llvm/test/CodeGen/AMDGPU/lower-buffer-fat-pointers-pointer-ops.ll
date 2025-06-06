; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -mcpu=gfx900 -amdgpu-lower-buffer-fat-pointers < %s | FileCheck %s
; RUN: opt -S -mcpu=gfx900 -passes=amdgpu-lower-buffer-fat-pointers < %s | FileCheck %s

target triple = "amdgcn--"

define ptr addrspace(7) @gep(ptr addrspace(7) %in, i32 %idx) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[IN:%.*]], i32 [[IDX:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[IN_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[IN]], 0
; CHECK-NEXT:    [[IN_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[IN]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nsw i32 [[IDX]], 40
; CHECK-NEXT:    [[RET_OFFS:%.*]] = add nsw i32 [[RET_IDX]], 8
; CHECK-NEXT:    [[RET_OFFS1:%.*]] = add nsw i32 [[RET_OFFS]], 24
; CHECK-NEXT:    [[RET:%.*]] = add i32 [[IN_OFF]], [[RET_OFFS1]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[IN]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %ret = getelementptr inbounds {i32, [4 x ptr]}, ptr addrspace(7) %in, i32 %idx, i32 1, i32 3
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @gep_vectors(<2 x ptr addrspace(7)> %in, <2 x i32> %idx) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @gep_vectors
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[IN:%.*]], <2 x i32> [[IDX:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[IN_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], 0
; CHECK-NEXT:    [[IN_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nsw <2 x i32> [[IDX]], splat (i32 40)
; CHECK-NEXT:    [[RET_OFFS:%.*]] = add nsw <2 x i32> [[RET_IDX]], splat (i32 8)
; CHECK-NEXT:    [[RET_OFFS1:%.*]] = add nsw <2 x i32> [[RET_OFFS]], splat (i32 24)
; CHECK-NEXT:    [[RET:%.*]] = add <2 x i32> [[IN_OFF]], [[RET_OFFS1]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], <2 x i32> [[RET]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]]
;
  %ret = getelementptr inbounds {i32, [4 x ptr]}, <2 x ptr addrspace(7)> %in, <2 x i32> %idx, i32 1, i32 3
  ret <2 x ptr addrspace(7)> %ret
}

define <2 x ptr addrspace(7)> @gep_vector_scalar(<2 x ptr addrspace(7)> %in, i64 %idx) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @gep_vector_scalar
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[IN:%.*]], i64 [[IDX:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[IN_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], 0
; CHECK-NEXT:    [[IN_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], 1
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[IDX]], i64 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <2 x i64> [[DOTSPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[DOTSPLAT_C:%.*]] = trunc <2 x i64> [[DOTSPLAT]] to <2 x i32>
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nsw <2 x i32> [[DOTSPLAT_C]], splat (i32 40)
; CHECK-NEXT:    [[RET_OFFS:%.*]] = add nsw <2 x i32> [[RET_IDX]], splat (i32 8)
; CHECK-NEXT:    [[RET_OFFS1:%.*]] = add nsw <2 x i32> [[RET_OFFS]], splat (i32 24)
; CHECK-NEXT:    [[RET:%.*]] = add <2 x i32> [[IN_OFF]], [[RET_OFFS1]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[IN]], <2 x i32> [[RET]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]]
;
  %ret = getelementptr inbounds {i32, [4 x ptr]}, <2 x ptr addrspace(7)> %in, i64 %idx, i32 1, i32 3
  ret <2 x ptr addrspace(7)> %ret
}

define <2 x ptr addrspace(7)> @gep_scalar_vector(ptr addrspace(7) %in, <2 x i32> %idxs) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @gep_scalar_vector
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[IN:%.*]], <2 x i32> [[IDXS:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[IN_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[IN]], 0
; CHECK-NEXT:    [[IN_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[IN]], 1
; CHECK-NEXT:    [[IN_RSRC_SPLATINSERT:%.*]] = insertelement <2 x ptr addrspace(8)> poison, ptr addrspace(8) [[IN_RSRC]], i64 0
; CHECK-NEXT:    [[IN_RSRC_SPLAT:%.*]] = shufflevector <2 x ptr addrspace(8)> [[IN_RSRC_SPLATINSERT]], <2 x ptr addrspace(8)> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[IN_OFF_SPLATINSERT:%.*]] = insertelement <2 x i32> poison, i32 [[IN_OFF]], i64 0
; CHECK-NEXT:    [[IN_OFF_SPLAT:%.*]] = shufflevector <2 x i32> [[IN_OFF_SPLATINSERT]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[RET:%.*]] = add <2 x i32> [[IN_OFF_SPLAT]], [[IDXS]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } poison, <2 x ptr addrspace(8)> [[IN_RSRC_SPLAT]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]], <2 x i32> [[RET]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP2]]
;
  %ret = getelementptr inbounds i8, ptr addrspace(7) %in, <2 x i32> %idxs
  ret <2 x ptr addrspace(7)> %ret
}

define ptr addrspace(7) @simple_gep(ptr addrspace(7) %ptr, i32 %off) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @simple_gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]], i32 [[OFF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul i32 [[OFF]], 4
; CHECK-NEXT:    [[RET:%.*]] = add i32 [[PTR_OFF]], [[RET_IDX]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[PTR]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %ret = getelementptr i32, ptr addrspace(7) %ptr, i32 %off
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @simple_inbounds_gep(ptr addrspace(7) %ptr, i32 %off) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @simple_inbounds_gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]], i32 [[OFF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nsw i32 [[OFF]], 4
; CHECK-NEXT:    [[RET:%.*]] = add i32 [[PTR_OFF]], [[RET_IDX]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[PTR]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %ret = getelementptr inbounds i32, ptr addrspace(7) %ptr, i32 %off
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @simple_nuw_gep(ptr addrspace(7) %ptr, i32 %off) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @simple_nuw_gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]], i32 [[OFF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nuw i32 [[OFF]], 4
; CHECK-NEXT:    [[RET:%.*]] = add nuw i32 [[PTR_OFF]], [[RET_IDX]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[PTR]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %ret = getelementptr nuw i32, ptr addrspace(7) %ptr, i32 %off
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @simple_nusw_gep(ptr addrspace(7) %ptr, i32 %off) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @simple_nusw_gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]], i32 [[OFF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_IDX:%.*]] = mul nsw i32 [[OFF]], 4
; CHECK-NEXT:    [[RET:%.*]] = add i32 [[PTR_OFF]], [[RET_IDX]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[PTR]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %ret = getelementptr nusw i32, ptr addrspace(7) %ptr, i32 %off
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @nusw_gep_pair(ptr addrspace(7) %ptr, i32 %off) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @nusw_gep_pair
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]], i32 [[OFF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[P1_IDX:%.*]] = mul nsw i32 [[OFF]], 4
; CHECK-NEXT:    [[P1:%.*]] = add i32 [[PTR_OFF]], [[P1_IDX]]
; CHECK-NEXT:    [[RET:%.*]] = add nuw i32 [[P1]], 16
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[PTR]], i32 [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %p1 = getelementptr nusw i32, ptr addrspace(7) %ptr, i32 %off
  %ret = getelementptr nusw i32, ptr addrspace(7) %p1, i32 4
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @zero_gep(ptr addrspace(7) %ptr) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @zero_gep
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[RET:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[RET]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[RET]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = getelementptr i8, ptr addrspace(7) %ptr, i32 0
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @zero_gep_goes_second(ptr addrspace(7) %v0, i32 %arg) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @zero_gep_goes_second
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[V0:%.*]], i32 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[V0_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[V0]], 0
; CHECK-NEXT:    [[V0_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[V0]], 1
; CHECK-NEXT:    [[V1:%.*]] = add i32 [[V0_OFF]], [[ARG]]
; CHECK-NEXT:    [[V2:%.*]] = insertvalue { ptr addrspace(8), i32 } [[V0]], i32 [[V1]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[V2]]
;
  %v1 = getelementptr i8, ptr addrspace(7) %v0, i32 %arg
  %v2 = getelementptr i8, ptr addrspace(7) %v1, i32 0
  ret ptr addrspace(7) %v2
}

define ptr addrspace(7) @zero_gep_goes_first(ptr addrspace(7) %v0, i32 %arg) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @zero_gep_goes_first
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[V0:%.*]], i32 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[V0_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[V0]], 0
; CHECK-NEXT:    [[V0_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[V0]], 1
; CHECK-NEXT:    [[V2:%.*]] = add i32 [[V0_OFF]], [[ARG]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } [[V0]], i32 [[V2]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP1]]
;
  %v1 = getelementptr i8, ptr addrspace(7) %v0, i32 0
  %v2 = getelementptr i8, ptr addrspace(7) %v1, i32 %arg
  ret ptr addrspace(7) %v2
}

define i160 @ptrtoint(ptr addrspace(7) %ptr) {
; CHECK-LABEL: define i160 @ptrtoint
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = ptrtoint ptr addrspace(8) [[PTR_RSRC]] to i160
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw i160 [[RET_RSRC]], 32
; CHECK-NEXT:    [[RET_OFF:%.*]] = zext i32 [[PTR_OFF]] to i160
; CHECK-NEXT:    [[RET:%.*]] = or i160 [[TMP1]], [[RET_OFF]]
; CHECK-NEXT:    ret i160 [[RET]]
;
  %ret = ptrtoint ptr addrspace(7) %ptr to i160
  ret i160 %ret
}

define <2 x i160> @ptrtoint_vec(<2 x ptr addrspace(7)> %ptr) {
; CHECK-LABEL: define <2 x i160> @ptrtoint_vec
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[PTR:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[PTR]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = ptrtoint <2 x ptr addrspace(8)> [[PTR_RSRC]] to <2 x i160>
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw <2 x i160> [[RET_RSRC]], splat (i160 32)
; CHECK-NEXT:    [[RET_OFF:%.*]] = zext <2 x i32> [[PTR_OFF]] to <2 x i160>
; CHECK-NEXT:    [[RET:%.*]] = or <2 x i160> [[TMP1]], [[RET_OFF]]
; CHECK-NEXT:    ret <2 x i160> [[RET]]
;
  %ret = ptrtoint <2 x ptr addrspace(7)> %ptr to <2 x i160>
  ret <2 x i160> %ret
}

define i256 @ptrtoint_long(ptr addrspace(7) %ptr) {
; CHECK-LABEL: define i256 @ptrtoint_long
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = ptrtoint ptr addrspace(8) [[PTR_RSRC]] to i256
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw nsw i256 [[RET_RSRC]], 32
; CHECK-NEXT:    [[RET_OFF:%.*]] = zext i32 [[PTR_OFF]] to i256
; CHECK-NEXT:    [[RET:%.*]] = or i256 [[TMP1]], [[RET_OFF]]
; CHECK-NEXT:    ret i256 [[RET]]
;
  %ret = ptrtoint ptr addrspace(7) %ptr to i256
  ret i256 %ret
}

define i64 @ptrtoint_short(ptr addrspace(7) %ptr) {
; CHECK-LABEL: define i64 @ptrtoint_short
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[PTR_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = ptrtoint ptr addrspace(8) [[PTR_RSRC]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[RET_RSRC]], 32
; CHECK-NEXT:    [[RET_OFF:%.*]] = zext i32 [[PTR_OFF]] to i64
; CHECK-NEXT:    [[RET:%.*]] = or i64 [[TMP1]], [[RET_OFF]]
; CHECK-NEXT:    ret i64 [[RET]]
;
  %ret = ptrtoint ptr addrspace(7) %ptr to i64
  ret i64 %ret
}

define i32 @ptrtoint_offset(ptr addrspace(7) %ptr) {
; CHECK-LABEL: define i32 @ptrtoint_offset
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[PTR:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 0
; CHECK-NEXT:    [[RET:%.*]] = extractvalue { ptr addrspace(8), i32 } [[PTR]], 1
; CHECK-NEXT:    ret i32 [[RET]]
;
  %ret = ptrtoint ptr addrspace(7) %ptr to i32
  ret i32 %ret
}

define ptr addrspace(7) @inttoptr(i160 %v) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @inttoptr
; CHECK-SAME: (i160 [[V:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i160 [[V]], 32
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i160 [[TMP1]] to i128
; CHECK-NEXT:    [[RET_RSRC:%.*]] = inttoptr i128 [[TMP2]] to ptr addrspace(8)
; CHECK-NEXT:    [[RET_OFF:%.*]] = trunc i160 [[V]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP3]], i32 [[RET_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = inttoptr i160 %v to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @inttoptr_vec(<2 x i160> %v) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @inttoptr_vec
; CHECK-SAME: (<2 x i160> [[V:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i160> [[V]], splat (i160 32)
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <2 x i160> [[TMP1]] to <2 x i128>
; CHECK-NEXT:    [[RET_RSRC:%.*]] = inttoptr <2 x i128> [[TMP2]] to <2 x ptr addrspace(8)>
; CHECK-NEXT:    [[RET_OFF:%.*]] = trunc <2 x i160> [[V]] to <2 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } poison, <2 x ptr addrspace(8)> [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP3]], <2 x i32> [[RET_OFF]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[RET]]
;
  %ret = inttoptr <2 x i160> %v to <2 x ptr addrspace(7)>
  ret <2 x ptr addrspace(7)> %ret
}

define ptr addrspace(7) @inttoptr_long(i256 %v) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @inttoptr_long
; CHECK-SAME: (i256 [[V:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i256 [[V]], 32
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i256 [[TMP1]] to i128
; CHECK-NEXT:    [[RET_RSRC:%.*]] = inttoptr i128 [[TMP2]] to ptr addrspace(8)
; CHECK-NEXT:    [[RET_OFF:%.*]] = trunc i256 [[V]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP3]], i32 [[RET_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = inttoptr i256 %v to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @inttoptr_offset(i32 %v) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @inttoptr_offset
; CHECK-SAME: (i32 [[V:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, i32 [[V]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = inttoptr i32 %v to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define ptr addrspace(7) @addrspacecast(ptr addrspace(8) %buf) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @addrspacecast
; CHECK-SAME: (ptr addrspace(8) [[BUF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[BUF]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP1]], i32 0, 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = addrspacecast ptr addrspace(8) %buf to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @addrspacecast_vec(<2 x ptr addrspace(8)> %buf) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @addrspacecast_vec
; CHECK-SAME: (<2 x ptr addrspace(8)> [[BUF:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } poison, <2 x ptr addrspace(8)> [[BUF]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]], <2 x i32> zeroinitializer, 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[RET]]
;
  %ret = addrspacecast <2 x ptr addrspace(8)> %buf to <2 x ptr addrspace(7)>
  ret <2 x ptr addrspace(7)> %ret
}

define ptr addrspace(7) @addrspacecast_null() {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @addrspacecast_null
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } zeroinitializer
;
  %ret = addrspacecast ptr null to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @addrspacecast_null_vec() {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @addrspacecast_null_vec
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } zeroinitializer
;
  %ret = addrspacecast <2 x ptr> zeroinitializer to <2 x ptr addrspace(7)>
  ret <2 x ptr addrspace(7)> %ret
}

define i1 @test_null(ptr addrspace(7) %p) {
; CHECK-LABEL: define i1 @test_null
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 1
; CHECK-NEXT:    [[IS_NULL_RSRC:%.*]] = icmp eq ptr addrspace(8) [[P_RSRC]], null
; CHECK-NEXT:    [[IS_NULL_OFF:%.*]] = icmp eq i32 [[P_OFF]], 0
; CHECK-NEXT:    [[IS_NULL:%.*]] = and i1 [[IS_NULL_RSRC]], [[IS_NULL_OFF]]
; CHECK-NEXT:    ret i1 [[IS_NULL]]
;
  %is.null = icmp eq ptr addrspace(7) %p, addrspacecast (ptr null to ptr addrspace(7))
  ret i1 %is.null
}

define ptr addrspace(7) @addrspacecast_undef() {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @addrspacecast_undef
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } undef
;
  %ret = addrspacecast ptr undef to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @addrspacecast_undef_vec() {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @addrspacecast_undef_vec
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } undef
;
  %ret = addrspacecast <2 x ptr> undef to <2 x ptr addrspace(7)>
  ret <2 x ptr addrspace(7)> %ret
}

define ptr addrspace(7) @addrspacecast_poison() {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @addrspacecast_poison
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } poison
;
  %ret = addrspacecast ptr poison to ptr addrspace(7)
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @addrspacecast_poison_vec() {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @addrspacecast_poison_vec
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } poison
;
  %ret = addrspacecast <2 x ptr> poison to <2 x ptr addrspace(7)>
  ret <2 x ptr addrspace(7)> %ret
}

declare ptr addrspace(7) @llvm.amdgcn.make.buffer.rsrc.p7.p1(ptr addrspace(1), i16, i32, i32)

define ptr addrspace(7) @make_buffer_rsrc(ptr addrspace(1) %buf, i16 %stride, i32 %numRecords, i32 %flags) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @make_buffer_rsrc
; CHECK-SAME: (ptr addrspace(1) [[BUF:%.*]], i16 [[STRIDE:%.*]], i32 [[NUMRECORDS:%.*]], i32 [[FLAGS:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[RET:%.*]] = call ptr addrspace(8) @llvm.amdgcn.make.buffer.rsrc.p8.p1(ptr addrspace(1) [[BUF]], i16 [[STRIDE]], i32 [[NUMRECORDS]], i32 [[FLAGS]])
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[RET]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP1]], i32 0, 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP2]]
;
  %ret = call ptr addrspace(7) @llvm.amdgcn.make.buffer.rsrc.p7.p1(ptr addrspace(1) %buf, i16 %stride, i32 %numRecords, i32 %flags)
  ret ptr addrspace(7) %ret
}

define i1 @icmp_eq(ptr addrspace(7) %a, ptr addrspace(7) %b) {
; CHECK-LABEL: define i1 @icmp_eq
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[A:%.*]], { ptr addrspace(8), i32 } [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[B_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[B]], 0
; CHECK-NEXT:    [[B_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[B]], 1
; CHECK-NEXT:    [[A_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[A]], 0
; CHECK-NEXT:    [[A_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[A]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = icmp eq ptr addrspace(8) [[A_RSRC]], [[B_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = icmp eq i32 [[A_OFF]], [[B_OFF]]
; CHECK-NEXT:    [[RET:%.*]] = and i1 [[RET_RSRC]], [[RET_OFF]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %ret = icmp eq ptr addrspace(7) %a, %b
  ret i1 %ret
}

define i1 @icmp_ne(ptr addrspace(7) %a, ptr addrspace(7) %b) {
; CHECK-LABEL: define i1 @icmp_ne
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[A:%.*]], { ptr addrspace(8), i32 } [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[B_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[B]], 0
; CHECK-NEXT:    [[B_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[B]], 1
; CHECK-NEXT:    [[A_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[A]], 0
; CHECK-NEXT:    [[A_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[A]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = icmp ne ptr addrspace(8) [[A_RSRC]], [[B_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = icmp ne i32 [[A_OFF]], [[B_OFF]]
; CHECK-NEXT:    [[RET:%.*]] = or i1 [[RET_RSRC]], [[RET_OFF]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %ret = icmp ne ptr addrspace(7) %a, %b
  ret i1 %ret
}

define <2 x i1> @icmp_eq_vec(<2 x ptr addrspace(7)> %a, <2 x ptr addrspace(7)> %b) {
; CHECK-LABEL: define <2 x i1> @icmp_eq_vec
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[A:%.*]], { <2 x ptr addrspace(8)>, <2 x i32> } [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[B_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 0
; CHECK-NEXT:    [[B_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 1
; CHECK-NEXT:    [[A_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 0
; CHECK-NEXT:    [[A_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = icmp eq <2 x ptr addrspace(8)> [[A_RSRC]], [[B_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = icmp eq <2 x i32> [[A_OFF]], [[B_OFF]]
; CHECK-NEXT:    [[RET:%.*]] = and <2 x i1> [[RET_RSRC]], [[RET_OFF]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %ret = icmp eq <2 x ptr addrspace(7)> %a, %b
  ret <2 x i1> %ret
}

define <2 x i1> @icmp_ne_vec(<2 x ptr addrspace(7)> %a, <2 x ptr addrspace(7)> %b) {
; CHECK-LABEL: define <2 x i1> @icmp_ne_vec
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[A:%.*]], { <2 x ptr addrspace(8)>, <2 x i32> } [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[B_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 0
; CHECK-NEXT:    [[B_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 1
; CHECK-NEXT:    [[A_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 0
; CHECK-NEXT:    [[A_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = icmp ne <2 x ptr addrspace(8)> [[A_RSRC]], [[B_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = icmp ne <2 x i32> [[A_OFF]], [[B_OFF]]
; CHECK-NEXT:    [[RET:%.*]] = or <2 x i1> [[RET_RSRC]], [[RET_OFF]]
; CHECK-NEXT:    ret <2 x i1> [[RET]]
;
  %ret = icmp ne <2 x ptr addrspace(7)> %a, %b
  ret <2 x i1> %ret
}

define ptr addrspace(7) @freeze(ptr addrspace(7) %p) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @freeze
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = freeze ptr addrspace(8) [[P_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = freeze i32 [[P_OFF]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP1]], i32 [[RET_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = freeze ptr addrspace(7) %p
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @freeze_vec(<2 x ptr addrspace(7)> %p) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @freeze_vec
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[P]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = freeze <2 x ptr addrspace(8)> [[P_RSRC]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = freeze <2 x i32> [[P_OFF]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } poison, <2 x ptr addrspace(8)> [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]], <2 x i32> [[RET_OFF]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[RET]]
;
  %ret = freeze <2 x ptr addrspace(7)> %p
  ret <2 x ptr addrspace(7)> %ret
}

define ptr addrspace(7) @extractelement(<2 x ptr addrspace(7)> %v, i32 %i) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @extractelement
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[V:%.*]], i32 [[I:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[V_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[V]], 0
; CHECK-NEXT:    [[V_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[V]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = extractelement <2 x ptr addrspace(8)> [[V_RSRC]], i32 [[I]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = extractelement <2 x i32> [[V_OFF]], i32 [[I]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP1]], i32 [[RET_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = extractelement <2 x ptr addrspace(7)> %v, i32 %i
  ret ptr addrspace(7) %ret
}

define <2 x ptr addrspace(7)> @insertelement(<2 x ptr addrspace(7)> %v, ptr addrspace(7) %s, i32 %i) {
; CHECK-LABEL: define { <2 x ptr addrspace(8)>, <2 x i32> } @insertelement
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[V:%.*]], { ptr addrspace(8), i32 } [[S:%.*]], i32 [[I:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[S_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[S]], 0
; CHECK-NEXT:    [[S_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[S]], 1
; CHECK-NEXT:    [[V_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[V]], 0
; CHECK-NEXT:    [[V_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[V]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = insertelement <2 x ptr addrspace(8)> [[V_RSRC]], ptr addrspace(8) [[S_RSRC]], i32 [[I]]
; CHECK-NEXT:    [[RET_OFF:%.*]] = insertelement <2 x i32> [[V_OFF]], i32 [[S_OFF]], i32 [[I]]
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } poison, <2 x ptr addrspace(8)> [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[TMP1]], <2 x i32> [[RET_OFF]], 1
; CHECK-NEXT:    ret { <2 x ptr addrspace(8)>, <2 x i32> } [[RET]]
;
  %ret = insertelement <2 x ptr addrspace(7)> %v, ptr addrspace(7) %s, i32 %i
  ret <2 x ptr addrspace(7)> %ret
}

define <4 x ptr addrspace(7)> @shufflenvector(<2 x ptr addrspace(7)> %a, <2 x ptr addrspace(7)> %b) {
; CHECK-LABEL: define { <4 x ptr addrspace(8)>, <4 x i32> } @shufflenvector
; CHECK-SAME: ({ <2 x ptr addrspace(8)>, <2 x i32> } [[A:%.*]], { <2 x ptr addrspace(8)>, <2 x i32> } [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[B_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 0
; CHECK-NEXT:    [[B_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[B]], 1
; CHECK-NEXT:    [[A_RSRC:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 0
; CHECK-NEXT:    [[A_OFF:%.*]] = extractvalue { <2 x ptr addrspace(8)>, <2 x i32> } [[A]], 1
; CHECK-NEXT:    [[RET_RSRC:%.*]] = shufflevector <2 x ptr addrspace(8)> [[A_RSRC]], <2 x ptr addrspace(8)> [[B_RSRC]], <4 x i32> <i32 0, i32 3, i32 1, i32 2>
; CHECK-NEXT:    [[RET_OFF:%.*]] = shufflevector <2 x i32> [[A_OFF]], <2 x i32> [[B_OFF]], <4 x i32> <i32 0, i32 3, i32 1, i32 2>
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { <4 x ptr addrspace(8)>, <4 x i32> } poison, <4 x ptr addrspace(8)> [[RET_RSRC]], 0
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { <4 x ptr addrspace(8)>, <4 x i32> } [[TMP1]], <4 x i32> [[RET_OFF]], 1
; CHECK-NEXT:    ret { <4 x ptr addrspace(8)>, <4 x i32> } [[RET]]
;
  %ret = shufflevector <2 x ptr addrspace(7)> %a, <2 x ptr addrspace(7)> %b, <4 x i32> <i32 0, i32 3, i32 1, i32 2>
  ret <4 x ptr addrspace(7)> %ret
}

declare ptr addrspace(7) @llvm.ptrmask.p7.i32(ptr addrspace(7), i32)

define ptr addrspace(7) @ptrmask(ptr addrspace(7) %p, i32 %mask) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @ptrmask
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[P:%.*]], i32 [[MASK:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 1
; CHECK-NEXT:    [[RET_OFF:%.*]] = and i32 [[P_OFF]], [[MASK]]
; CHECK-NEXT:    [[RET:%.*]] = insertvalue { ptr addrspace(8), i32 } [[P]], i32 [[RET_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[RET]]
;
  %ret = call ptr addrspace(7) @llvm.ptrmask.p7.i32(ptr addrspace(7) %p, i32 %mask)
  ret ptr addrspace(7) %ret
}

declare ptr @llvm.invariant.start.p7(i64, ptr addrspace(7) nocapture)
declare void @llvm.invariant.end.p7(ptr, i64, ptr addrspace(7) nocapture)

define i32 @invariant_start_end(ptr addrspace(7) %p) {
; CHECK-LABEL: define i32 @invariant_start_end
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 1
; CHECK-NEXT:    [[INV:%.*]] = call ptr @llvm.invariant.start.p8(i64 256, ptr addrspace(8) [[P_RSRC]])
; CHECK-NEXT:    [[V:%.*]] = call i32 @llvm.amdgcn.raw.ptr.buffer.load.i32(ptr addrspace(8) align 4 [[P_RSRC]], i32 [[P_OFF]], i32 0, i32 0)
; CHECK-NEXT:    call void @llvm.invariant.end.p8(ptr [[INV]], i64 256, ptr addrspace(8) [[P_RSRC]])
; CHECK-NEXT:    ret i32 [[V]]
;
  %inv = call ptr @llvm.invariant.start.p7(i64 256, ptr addrspace(7) %p)
  %v = load i32, ptr addrspace(7) %p
  call void @llvm.invariant.end.p7(ptr %inv, i64 256, ptr addrspace(7) %p)
  ret i32 %v
}

declare ptr addrspace(7) @llvm.launder.invariant.group.p7(ptr addrspace(7) nocapture)
declare ptr addrspace(7) @llvm.strip.invariant.group.p7(ptr addrspace(7) nocapture)

define ptr addrspace(7) @invariant_group(ptr addrspace(7) %p) {
; CHECK-LABEL: define { ptr addrspace(8), i32 } @invariant_group
; CHECK-SAME: ({ ptr addrspace(8), i32 } [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[P_RSRC:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 0
; CHECK-NEXT:    [[P_OFF:%.*]] = extractvalue { ptr addrspace(8), i32 } [[P]], 1
; CHECK-NEXT:    [[LAUNDERED:%.*]] = call ptr addrspace(8) @llvm.launder.invariant.group.p8(ptr addrspace(8) [[P_RSRC]])
; CHECK-NEXT:    [[STRIPPED:%.*]] = call ptr addrspace(8) @llvm.strip.invariant.group.p8(ptr addrspace(8) [[LAUNDERED]])
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { ptr addrspace(8), i32 } poison, ptr addrspace(8) [[STRIPPED]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { ptr addrspace(8), i32 } [[TMP1]], i32 [[P_OFF]], 1
; CHECK-NEXT:    ret { ptr addrspace(8), i32 } [[TMP2]]
;
  %laundered = call ptr addrspace(7) @llvm.launder.invariant.group.p7(ptr addrspace(7) %p)
  %stripped = call ptr addrspace(7) @llvm.strip.invariant.group.p7(ptr addrspace(7) %laundered)
  ret ptr addrspace(7) %stripped
}
