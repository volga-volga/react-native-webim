declare module 'react-native-webim' {
  export type WebimEvents = 'NEW_MESSAGE' | 'REMOVE_MESSAGE' | 'EDIT_MESSAGE' | 'CLEAR_DIALOG';

  export const webimEvents: { [K in WebimEvents]: string };

  export interface Attachment {
    contentType: string;
    info: string;
    name: string;
    size: number;
    url: string;
  }

  export interface Message {
    id: string;
    avatar?: string;
    time: number;
    type: 'OPERATOR' | 'VISITOR' | 'INFO';
    text: string;
    name: string;
    status: 'SENT';
    read: boolean;
    canEdit: boolean;
    attachment?: Attachment;
  }

  export type WebimListener<T> = (msg: T) => void;

  class RNWebim {
    resumeSession(accountName: string, location: string, acc?: string): Promise<void>;

    destroySession(): Promise<void>;

    getLastMessages(limit: number): Promise<{ messages: Message[] }>;

    getNextMessages(limit: number): Promise<{ messages: Message[] }>;

    getAllMessages(): Promise<{ messages: Message[] }>;

    send(message: string): Promise<{ id: string }>;

    rateOperator(rate: number): Promise<void>;

    tryAttachFile(): Promise<void>;

    sendFile(uri: string, name: string, mime: string, extension: string): Promise<void>;

    addListener<T>(event: string, listener: WebimListener<T>): void;

    removeListener<T>(event: string, listener: WebimListener<T>): void;

    removeAllListeners(event: string): void;
  }

  const Webim: RNWebim;

  export default Webim;
}
