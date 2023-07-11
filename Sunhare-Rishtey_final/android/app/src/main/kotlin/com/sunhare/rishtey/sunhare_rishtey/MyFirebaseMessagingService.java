package com.sunhare.rishtey;

import android.util.Log;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    int m = 1015;

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        sendMsgReceived(remoteMessage);
    }

    void sendMsgReceived(RemoteMessage remoteMessage) {
        String target = remoteMessage.getData().get("target");
        String userId = remoteMessage.getData().get("userId");
        String uid = FirebaseAuth.getInstance().getUid();

        if (uid != null && !target.equals("-1") && userId != null && target.equals("435")) {
            FirebaseDatabase.getInstance().getReference().child("PersonalChatsPersons").child(uid).child(userId)
                    .child("lastReceived").setValue(System.currentTimeMillis()+500);
        }
    }
}