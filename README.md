# webim-react-native

Implementation of [webim sdk](https://webim.ru/) for [react-native](https://github.com/facebook/react-native)

**Important:** Updated version for RN 0.60+

## Installation

```
yarn add webim-react-native
```

iOS
- add to PodFile
 ```
    use_frameworks!
    pod 'WebimClientLibrary', :git => 'https://github.com/webim/webim-client-sdk-ios.git', :tag => '3.34.4'
```
- pod install 

**Note:** Flipper doesn't work with use_frameworks flag

## Usage

**Important:** All methods are promise based and can throw exceptions

### Init chat

 ```ts
import webim from 'webim-react-native';

webim.resumeSession(builderParams)
```

```ts
type SessionBuilderParams = {
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
 ```
- accountName (required) - name of your account in webim system
- location (required) - name of location. For example "mobile"
- accountJSON - encrypted json with user data. See **Start chat with user data**
- clearVisitorData - clear visitor data before start chat
- storeHistoryLocally - cache messages in local store
- title - title for chat in webim web panel
- providedAuthorizationToken - user token. Session will not start with wrong token. Read webim documentation
- pushToken
- appVersion


### Init events listeners

```js
import webim, { WebimEvents} from 'webim-react-native';

const listener = webim.addNewMessageListener(({ msg }) => {
  // do something
});
// usubscribe
listener.remove();

// or
const listener2 = webim.addListener(WebimEvents.NEW_MESSAGE, ({ msg }) => {
    // do something
});
```
Supported events (`WebimEvents`): 
- WebimEvents.NEW_MESSAGE;
- WebimEvents.REMOVE_MESSAGE;
- WebimEvents.EDIT_MESSAGE;
- WebimEvents.CLEAR_DIALOG;
- WebimEvents.TOKEN_UPDATED;
- WebimEvents.ERROR;

### Get messages

```js
const { messages } = await webim.getLastMessages(limit);
// or
const { messages } = await webim.getNextMessages(limit);
// or
const { messages } = await webim.getAllMessages();
```
Note: method `getAllMessages` works strange on iOS, and sometimes returns empty array. We recommend to use `getLastMessages` instead

### Send text message

```
webim.send(message);
```

### Attach files
  
#### Use build in method for file attaching:

```js
try {
  await webim.tryAttachFile();
} catch (err) {
  /*
   process err.message:
    - 'file size exceeded' - webim response
    - 'type not allowed' - webim response
    - 'canceled' - picker closed by user
   */
}
```

#### or attach files by yourself

```js
try {
  webim.sendFile(uri, name, mime, extension)
} catch (e) {
  // can throw 'file size exceeded' and 'type not allowed' errors
}
```

### Rate current operator
```js
webim.rateOperator()
```

### Destroy session
```js
webim.destroySession(clearData);
```

- clearData (optional) boolean - If true wil

## Start chat with user data

See [webim documentation](https://webim.ru/kb/dev/identification/8265-id-2-0/) for client identification.

Example:

- install [react-native-crypto](https://github.com/tradle/react-native-crypto) with all dependencies and run `rn-nodeify --hack --install`
- run `rn-nodeify --hack --install` after each `npm install` (add in postinstall script)

```ts
import './shim'; // set your path to shim.js
import crypto from 'crypto';

const getHmac_sha256 = (str: string, privateKey: string) => {
  const hmac = crypto.createHmac('sha256', privateKey);
  const promise = new Promise((resolve: (hash: string) => void) => hmac.on('readable', () => {
    const data = hmac.read();
    if (data) {
      resolve(data.toString('hex'));
    }
  }));
  hmac.write(str);
  hmac.end();
  return promise;
};

const getHash = (obj: { [key: string]: string }) => {
  const keys = Object.keys(obj).sort();
  const str = keys.map(key => obj[key]).join('');
  return getHmac_sha256(str, WEBIM_PRIVATE_KEY);
};
// set account here
const acc = {
  fields: {
    id: "some id",
    display_name: "name",
    phone: "phone",
  },
  hash: '',
};
acc.hash = await getHash(acc.fields);

await webim.resumeSession('accountName', 'location', JSON.stringify(acc));
```
