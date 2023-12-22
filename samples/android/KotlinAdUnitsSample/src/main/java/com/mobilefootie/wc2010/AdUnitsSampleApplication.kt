/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

package com.mobilefootie.wc2010

import android.app.Application

class AdUnitsSampleApplication : Application() {

  override fun onCreate() {
    super.onCreate()


    AudienceNetworkInitializeHelper.initialize(this)

  }
}
