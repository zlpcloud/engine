// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "tonic/file_loader/file_loader.h"

#include <iostream>
#include <memory>
#include <utility>

#include "filesystem/file.h"
#include "filesystem/path.h"
#include "tonic/common/macros.h"
#include "tonic/converter/dart_converter.h"
#include "tonic/parsers/packages_map.h"

namespace tonic {

const std::string FileLoader::kPathSeparator = "/";
const char FileLoader::kFileURLPrefix[] = "file://";
const size_t FileLoader::kFileURLPrefixLength =
    sizeof(FileLoader::kFileURLPrefix) - 1;

namespace {

const size_t kFileSchemeLength = FileLoader::kFileURLPrefixLength - 2;

}  // namespace

std::string FileLoader::SanitizePath(const std::string& url) {
  return SanitizeURIEscapedCharacters(url);
}

std::string FileLoader::CanonicalizeFileURL(const std::string& url) {
  return url.substr(kFileSchemeLength);
}

bool FileLoader::ReadFileToString(const std::string& path,
                                  std::string* result) {
  TONIC_DCHECK(dirfd_ == -1);
  return filesystem::ReadFileToString(path, result);
}

std::pair<uint8_t*, intptr_t> FileLoader::ReadFileToBytes(
    const std::string& path) {
  TONIC_DCHECK(dirfd_ == -1);
  return filesystem::ReadFileToBytes(path);
}

}  // namespace tonic
