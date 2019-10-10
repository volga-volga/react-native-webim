module.exports = {
  dependencies: {
    'react-native-webim': {
      platforms: {
        ios: {
          podspecPath: `${__dirname}/node_modules/react-native-webim/RNWebim.podspec`,
        },
        android: {
          packageImportPath: 'import ru.vvdev.webim.WebimPackage;',
          packageInstance: 'new WebimPackage()'
        },
      },
    },
  },
};
