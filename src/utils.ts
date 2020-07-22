import {NativeError} from './types';

export function parseNativeResponse<T>(response?: T): T | null {
  return response || null;
}

export function processError(error: NativeError) {
  return new Error(error.message);
}

export class WebimSubscription {
  readonly remove: () => void;

  constructor(remove: () => void) {
    this.remove = remove;
  }
}
