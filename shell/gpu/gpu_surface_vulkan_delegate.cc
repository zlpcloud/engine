// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// FLUTTER_NOLINT

#include "flutter/shell/gpu/gpu_surface_vulkan_delegate.h"

namespace flutter {

GPUSurfaceVulkanDelegate::~GPUSurfaceVulkanDelegate() = default;

ExternalViewEmbedder* GPUSurfaceVulkanDelegate::GetExternalViewEmbedder() {
  return nullptr;
}

}  // namespace flutter
