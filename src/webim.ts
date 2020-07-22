import {NativeModules, NativeEventEmitter} from 'react-native';
import {
  DialogClearedListener, ErrorListener,
  NativeError, NewMessageListener, RemoveMessageListener,
  SessionBuilderParams, TokenUpdatedListener, UpdateMessageListener, WebimEventListener,
  WebimEvents,
  WebimMessage,
} from './types';
import {WebimSubscription, processError} from './utils';

const {RNWebim: WebimNative} = NativeModules;
const emitter = new NativeEventEmitter(NativeModules.RNWebim);

const DEFAULT_MESSAGES_LIMIT = 100;

export class RNWebim {
  static resumeSession(params: SessionBuilderParams): Promise<void> {
    return new Promise((resolve, reject) => {
      WebimNative.resumeSession(
        params,
        (error: NativeError) => reject(processError(error)),
        () => resolve(),
      );
    });
  }

  static destroySession(clearData: boolean = false) {
    return new Promise((resolve, reject) => {
      WebimNative.destroySession(
        clearData,
        (error: NativeError) => reject(processError(error)),
        () => resolve(),
      );
    });
  }

  static getLastMessages(
    limit: number = DEFAULT_MESSAGES_LIMIT,
  ): Promise<{ messages: WebimMessage[] }> {
    return new Promise((resolve, reject) => {
      WebimNative.getLastMessages(
        limit,
        (error: NativeError) => reject(processError(error)),
        (messages: { messages: WebimMessage[] }) => resolve(messages),
      );
    });
  }

  static getNextMessages(
    limit: number = DEFAULT_MESSAGES_LIMIT,
  ): Promise<{ messages: WebimMessage[] }> {
    return new Promise((resolve, reject) => {
      WebimNative.getNextMessages(
        limit,
        (error: NativeError) => reject(processError(error)),
        (messages: { messages: WebimMessage[] }) => resolve(messages),
      );
    });
  }

  static getAllMessages(): Promise<{ messages: WebimMessage[] }> {
    return new Promise((resolve, reject) => {
      WebimNative.getAllMessages(
        (error: NativeError) => reject(processError(error)),
        (messages: { messages: WebimMessage[] }) => resolve(messages),
      );
    });
  }

  static send(message: string) {
    return new Promise((resolve, reject) =>
      WebimNative.send(
        message,
        (error: NativeError) => reject(processError(error)),
        (id: string) => resolve(id),
      ),
    );
  }

  static rateOperator(rate: number) {
    return new Promise((resolve, reject) => {
      WebimNative.rateOperator(
        rate,
        (error: NativeError) => reject(processError(error)),
        () => resolve(),
      );
    });
  }

  static tryAttachFile() {
    return new Promise((resolve, reject) => {
      WebimNative.tryAttachFile(
        (error: NativeError) => reject(processError(error)),
        async (file: {
          uri: string;
          name: string;
          mime: string;
          extension: string;
        }) => {
          const {uri, name, mime, extension} = file;
          try {
            await RNWebim.sendFile(uri, name, mime, extension);
            resolve();
          } catch (e) {
            reject(processError(e));
          }
        },
      );
    });
  }

  static sendFile(uri: string, name: string, mime: string, extension: string) {
    return new Promise((resolve, reject) =>
      WebimNative.sendFile(uri, name, mime, extension, reject, resolve),
    );
  }

  public static addNewMessageListener(listener: NewMessageListener): WebimSubscription {
    emitter.addListener(WebimEvents.NEW_MESSAGE, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.NEW_MESSAGE, listener));
  }

  public static addRemoveMessageListener(listener: RemoveMessageListener): WebimSubscription {
    emitter.addListener(WebimEvents.REMOVE_MESSAGE, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.REMOVE_MESSAGE, listener));
  }

  public static addEditMessageListener(listener: UpdateMessageListener): WebimSubscription {
    emitter.addListener(WebimEvents.EDIT_MESSAGE, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.EDIT_MESSAGE, listener));
  }

  public static addDialogClearedListener(listener: DialogClearedListener): WebimSubscription {
    emitter.addListener(WebimEvents.CLEAR_DIALOG, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.CLEAR_DIALOG, listener));
  }

  public static addTokenUpdatedListener(listener: TokenUpdatedListener): WebimSubscription {
    emitter.addListener(WebimEvents.TOKEN_UPDATED, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.TOKEN_UPDATED, listener));
  }

  public static addErrorListener(listener: ErrorListener): WebimSubscription {
    emitter.addListener(WebimEvents.ERROR, listener);
    return new WebimSubscription(() => RNWebim.removeListener(WebimEvents.ERROR, listener));
  }

  public static addListener(event: WebimEvents, listener: WebimEventListener): WebimSubscription {
    emitter.addListener(event, listener);
    return new WebimSubscription(() => RNWebim.removeListener(event, listener));
  }

  public static removeListener(event: WebimEvents, listener: WebimEventListener): void {
    emitter.removeListener(event, listener);
  }

  static removeAllListeners(event: WebimEvents) {
    emitter.removeAllListeners(event);
  }
}

export default RNWebim;

