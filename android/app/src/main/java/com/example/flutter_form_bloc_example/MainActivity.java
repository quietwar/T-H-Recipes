package com.hgp.threcipes;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import android.support.annotation.NonNull;
//import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
    }
}
