// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.10
part of engine;

/// A bag of all experiment flags in the web engine.
///
/// This class also handles platform messages that can be sent to enable/disable
/// certain experiments at runtime without the need to access engine internals.
class WebExperiments {
  WebExperiments._() {
    js.context['_flutter_internal_update_experiment'] = updateExperiment;
    registerHotRestartListener(() {
      js.context['_flutter_internal_update_experiment'] = null;
    });
  }

  static WebExperiments ensureInitialized() {
    return WebExperiments.instance ?? (WebExperiments.instance = WebExperiments._());
  }

  static WebExperiments? instance;

  /// Experiment flag for using canvas-based text measurement.
  bool get useCanvasText => _useCanvasText;
  set useCanvasText(bool? enabled) {
    _useCanvasText = enabled ?? _defaultUseCanvasText;
  }

  static const bool _defaultUseCanvasText = const bool.fromEnvironment(
    'FLUTTER_WEB_USE_EXPERIMENTAL_CANVAS_TEXT',
    defaultValue: true,
  );

  bool _useCanvasText = _defaultUseCanvasText;

  /// Reset all experimental flags to their default values.
  void reset() {
    _useCanvasText = _defaultUseCanvasText;
  }

  /// Used to enable/disable experimental flags in the web engine.
  void updateExperiment(String name, bool enabled) {
    switch (name) {
      case 'useCanvasText':
        useCanvasText = enabled;
        break;
    }
  }
}
