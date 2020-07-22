export type SessionBuilderParams = {
  accountName: string;
  location: string;
  accountJSON?: string;
  providedAuthorizationToken?: string;
  appVersion?: string;
  clearVisitorData?: boolean;
  storeHistoryLocally?: boolean;
  title?: string;
  pushToken?: string;
};

export enum WebimEvents {
  NEW_MESSAGE = 'newMessage',
  REMOVE_MESSAGE = 'removeMessage',
  EDIT_MESSAGE = 'changedMessage',
  CLEAR_DIALOG = 'allMessagesRemoved',
  TOKEN_UPDATED = 'tokenUpdated',
  ERROR = 'error',
}

export interface WebimAttachment {
  contentType: string;
  info: string;
  name: string;
  size: number;
  url: string;
}

export interface WebimMessage {
  id: string;
  avatar?: string;
  time: number;
  type: 'OPERATOR' | 'VISITOR' | 'INFO';
  text: string;
  name: string;
  status: 'SENT';
  read: boolean;
  canEdit: boolean;
  attachment?: WebimAttachment;
}

export type NativeError = {
  message: string;
};

export type NewMessageListener = (data: { msg: WebimMessage }) => void;
export type UpdateMessageListener = (data: { from: WebimMessage, to: WebimMessage }) => void;
export type RemoveMessageListener = (data: { msg: WebimMessage }) => void;
export type DialogClearedListener = () => void;
export type TokenUpdatedListener = (token: string) => void;
export type ErrorListener = (error: NativeError) => void;

export type WebimEventListener = NewMessageListener | UpdateMessageListener | RemoveMessageListener | DialogClearedListener | TokenUpdatedListener | ErrorListener;
