package ru.vvdev.webim;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.webkit.MimeTypeMap;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.webimapp.android.sdk.Message;
import com.webimapp.android.sdk.MessageListener;
import com.webimapp.android.sdk.MessageStream;
import com.webimapp.android.sdk.MessageTracker;
import com.webimapp.android.sdk.Operator;
import com.webimapp.android.sdk.Webim;
import com.webimapp.android.sdk.WebimError;
import com.webimapp.android.sdk.WebimSession;

public class WebimModule extends ReactContextBaseJavaModule implements MessageListener {
    private static final int FILE_SELECT_CODE = 0;
    private static final String REACT_CLASS = "RNWebim";
    private static ReactApplicationContext reactContext = null;

    private Callback fileCbSuccess;
    private Callback fileCbFailure;
    private MessageTracker tracker;
    private WebimSession session;

    WebimModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;
        // todo: чистить cb
        ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
            @Override
            public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
                if (requestCode == FILE_SELECT_CODE) {
                    if (resultCode == Activity.RESULT_OK) {
                        Uri uri = data.getData();
                        Activity _activity = getContext().getCurrentActivity();
                        if (_activity != null && uri != null) {
                            String mime = _activity.getContentResolver().getType(uri);
                            String extension = mime == null
                                    ? null
                                    : MimeTypeMap.getSingleton().getExtensionFromMimeType(mime);
                            String name = extension == null
                                    ? null
                                    : uri.getLastPathSegment() + "." + extension;
                            if (fileCbSuccess != null) {
                                fileCbSuccess.invoke(uri.toString(), name, mime, extension);
                            }
                        } else {
                            fileCbFailure.invoke(getSimpleMap("message", "unknown"));
                        }
                        clearAttachCallbacks();
                        return;
                    }
                    if (resultCode != Activity.RESULT_CANCELED) {
                        if (fileCbFailure != null) {
                            fileCbFailure.invoke(getSimpleMap("message", "canceled"));
                        }
                        clearAttachCallbacks();
                    }
                }
            }
        };
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    private ReactApplicationContext getContext() {
        return reactContext;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public Map<String, Object> getConstants() {
        return new HashMap<>();
    }

    private void init(String accountName, String location, String account) {
        Webim.SessionBuilder builder = Webim.newSessionBuilder()
                .setContext(reactContext)
                .setAccountName(accountName)
                .setLocation(location)
                .setPushSystem(Webim.PushSystem.FCM)
                .setPushToken("none");
        if (account != null) {
            builder.setVisitorFieldsJson(account);
        }
        session = builder.build();
    }

    @ReactMethod
    public void resumeSession(String accountName, String location, String account, final Callback errorCallback, final Callback successCallback) {
        if (session == null) {
            init(accountName, location, account);
        }
        session.resume();
        session.getStream().startChat();
        session.getStream().setChatRead();
        tracker = session.getStream().newMessageTracker(this);
        successCallback.invoke(Arguments.createMap());
    }

    @ReactMethod
    public void destroySession(final Callback errorCallback, final Callback successCallback) {
        if (session != null) {
            session.getStream().closeChat();
            tracker.destroy();
            session.destroy();
            session = null;
        }
        successCallback.invoke(Arguments.createMap());
    }

    private WritableMap messagesToJson(@NonNull List<? extends Message> messages) {
        WritableMap response = Arguments.createMap();
        WritableArray jsonMessages = Arguments.createArray();
        for (Message message : messages) {
            jsonMessages.pushMap(messageToJson(message));
        }
        response.putArray("messages", jsonMessages);
        return response;
    }

    private MessageTracker.GetMessagesCallback getMessagesCallback(final Callback successCallback) {
        return new MessageTracker.GetMessagesCallback() {
            @Override
            public void receive(@NonNull List<? extends Message> messages) {
                WritableMap response = messagesToJson(messages);
                successCallback.invoke(response);
            }
        };
    }

    @ReactMethod
    public void getLastMessages(int limit, final Callback errorCallback, final Callback successCallback) {
        tracker.getLastMessages(limit, getMessagesCallback(successCallback));
    }

    @ReactMethod
    public void getNextMessages(int limit, final Callback errorCallback, final Callback successCallback) {
        tracker.getNextMessages(limit, getMessagesCallback(successCallback));
    }

    @ReactMethod
    public void getAllMessages(final Callback errorCallback, final Callback successCallback) {
        tracker.getAllMessages(getMessagesCallback(successCallback));
    }

    @ReactMethod
    public void rateOperator(int rate, final Callback errorCallback, final Callback successCallback) {
        Operator operator = session.getStream().getCurrentOperator();
        if (operator != null) {
            session.getStream().rateOperator(operator.getId(), rate, new MessageStream.RateOperatorCallback() {
                @Override
                public void onSuccess() {
                    successCallback.invoke(Arguments.createMap());
                }

                @Override
                public void onFailure(@NonNull WebimError<RateOperatorError> rateOperatorError) {
                    errorCallback.invoke(getSimpleMap("message", rateOperatorError.getErrorString()));
                }
            });
        } else {
            errorCallback.invoke(getSimpleMap("message", "no operator"));
        }
    }

    @ReactMethod
    public void tryAttachFile(Callback failureCb, Callback successCb) {
        fileCbFailure = failureCb;
        fileCbSuccess = successCb;
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("*/*");
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        Activity activity = reactContext.getCurrentActivity();
        if (activity != null) {
            activity.startActivityForResult(Intent.createChooser(intent, "Выбор файла"), FILE_SELECT_CODE);
        } else {
            failureCb.invoke("pick error");
            fileCbFailure = null;
            fileCbSuccess = null;
        }
    }

    @ReactMethod
    public void sendFile(String uri, String name, String mime, String extension, final Callback failureCb, final Callback successCb) {
        File file = null;
        try {
            Activity activity = getContext().getCurrentActivity();
            if (activity == null) {
                failureCb.invoke("");
                return;
            }
            InputStream inp = activity.getContentResolver().openInputStream(Uri.parse(uri));
            if (inp != null) {
                file = File.createTempFile("webim", extension, activity.getCacheDir());
                writeFully(file, inp);
            }
        } catch (IOException e) {
            if (file != null) {
                file.delete();
            }
            failureCb.invoke(getSimpleMap("message", "unknown"));
            return;
        }
        if (file != null && name != null) {
            final File fileToUpload = file;
            session.getStream().sendFile(fileToUpload, name, mime, new MessageStream.SendFileCallback() {
                @Override
                public void onProgress(@NonNull Message.Id id, long sentBytes) {
                }

                @Override
                public void onSuccess(@NonNull Message.Id id) {
                    fileToUpload.delete();
                    successCb.invoke(getSimpleMap("id", id.toString()));
                }

                @Override
                public void onFailure(@NonNull Message.Id id,
                                      @NonNull WebimError<SendFileError> error) {
                    fileToUpload.delete();
                    String msg;
                    switch (error.getErrorType()) {
                        case FILE_TYPE_NOT_ALLOWED:
                            msg = "type not allowed";
                            break;
                        case FILE_SIZE_EXCEEDED:
                            msg = "file size exceeded";
                            break;
                        default:
                            msg = "unknown";
                    }
                    failureCb.invoke(getSimpleMap("message", msg));
                }
            });
        } else {
            failureCb.invoke(getSimpleMap("message", "no file"));
        }
    }

    @ReactMethod
    public void send(String message, final Callback failureCb, final Callback successCb) {
        session.getStream().sendMessage(message);
        successCb.invoke();
    }

    @Override
    public void messageAdded(@Nullable Message before, @NonNull Message message) {
        final WritableMap msg = Arguments.createMap();
        msg.putMap("msg", messageToJson(message));
        emitDeviceEvent("newMessage", msg);
    }

    @Override
    public void messageChanged(@NonNull Message from, @NonNull Message to) {
        final WritableMap map = Arguments.createMap();
        map.putMap("to", messageToJson(to));
        map.putMap("from", messageToJson(from));
        emitDeviceEvent("changedMessage", map);
    }

    @Override
    public void allMessagesRemoved() {
        final WritableMap map = Arguments.createMap();
        emitDeviceEvent("allMessagesRemoved", map);
    }

    @Override
    public void messageRemoved(@NonNull Message message) {
        final WritableMap msg = Arguments.createMap();
        msg.putMap("msg", messageToJson(message));
        emitDeviceEvent("removeMessage", msg);
    }

    private static void emitDeviceEvent(String eventName, @Nullable WritableMap eventData) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, eventData);
    }

    private WritableMap messageToJson(Message msg) {
        final WritableMap map = Arguments.createMap();
        map.putString("id", msg.getId().toString());
        map.putInt("time", (int) msg.getTime());
        map.putString("type", msg.getType().toString());
        map.putString("text", msg.getText());
        map.putString("name", msg.getSenderName());
        map.putString("status", msg.getSendStatus().toString());
        map.putString("avatar", msg.getSenderAvatarUrl());
        map.putBoolean("read", msg.isReadByOperator());
        map.putBoolean("canEdit", msg.canBeEdited());
        Message.Attachment attach = msg.getAttachment();
        if (attach != null) {
            WritableMap _att = Arguments.createMap();
            _att.putString("contentType", attach.getContentType());
            _att.putString("name", attach.getFileName());
            _att.putString("info", "attach.getImageInfo().toString()");
            _att.putDouble("size", attach.getSize());
            _att.putString("url", attach.getUrl());
            map.putMap("attachment", _att);
        }
        return map;
    }

    private static void writeFully(@NonNull File to, @NonNull InputStream from) throws IOException {
        byte[] buffer = new byte[4096];
        OutputStream out = null;
        try {
            out = new FileOutputStream(to);
            for (int read; (read = from.read(buffer)) != -1; ) {
                out.write(buffer, 0, read);
            }
        } finally {
            from.close();
            if (out != null) {
                out.close();
            }
        }
    }

    private void clearAttachCallbacks() {
        fileCbFailure = null;
        fileCbSuccess = null;
    }

    private WritableMap getSimpleMap(String key, String value) {
        WritableMap map = Arguments.createMap();
        map.putString(key, value);
        return map;
    }
}
