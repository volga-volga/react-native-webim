# react-native-webim

Implementation of [webim sdk](https://webim.ru/) for [react-native](https://github.com/facebook/react-native)

**Important:** last tested react-native version is 59.9

## Installation

```
yarn add react-native-webim
react-native link react-native-webim
```

iOS:

 - add `Libraries/RNWebim/Libraries/WebimClientLibrary/Product/WebimClientLibrary.framework` into **Link Binary With Libraries**
 - to be done

## Usage

**Important:** All methods are promise based and can throw exceptions

- Init chat:
 ```js
 webim.resumeSession("accountName", "location")
 ```

- Init events listeners:
```js
webim.addListener(webimEvents.NEW_MESSAGE, ({ msg }) => {
    // do something
});
```
Supported events: `NEW_MESSAGE, REMOVE_MESSAGE, EDIT_MESSAGE, CLEAR_DIALOG`

- Get messages:
```js
const { messages } = await webim.getLastMessages(100);
// or
const { messages } = await webim.getNextMessages(100);
// or
const { messages } = await webim.getAllMessages();
```
Note: method `getAllMessages` works strange on iOS, and sometimes returns empty array. We recommend to use `getLastMessages` instead

- Send text message:
```
webim.send(message);
```

- Use build in method for file attaching:
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

- or attach files by yourself:
```js
try {
  webim.sendFile(uri, name, mime, extension)
} catch (e) {
  // can throw 'file size exceeded' and 'type not allowed' errors
}
```

- rate current operator:
```js
webim.rateOperator()
```

- destroy session:
```js
webim.destroySession();
```

See `index.d.ts` for getting types information
