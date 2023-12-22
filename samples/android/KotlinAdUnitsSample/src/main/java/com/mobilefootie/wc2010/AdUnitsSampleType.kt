/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

package com.mobilefootie.wc2010

enum class AdUnitsSampleType(val sampleType: String) {
  BANNER("Banner"),
  RECTANGLE("Rectangle"),
  INTERSTITIAL("Interstitial"),
  REWARDED_VIDEO("Rewarded Video"),
  REWARDED_INTERSTITIAL("Rewarded Interstitial"),
  NATIVE("Native Ad"),
  NATIVE_BANNER("Native Banner Ad"),
  HSCROLL("Native Ad in H-Scroll"),
  TEMPLATE("Native Ad Template");

  companion object {
    fun getSampleTypeFromName(name: String): AdUnitsSampleType? {
      for (type in values()) {
        if (type.sampleType.contentEquals(name)) {
          return type
        }
      }

      return null
    }
  }
}
