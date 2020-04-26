import React, { useContext } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

import { Dimensions } from 'react-native';
const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

import { store } from '../Store';
import MyImagePicker from "./ImagePicker";

const axios = require('axios').default;
var messages = require('../protocol/everyday_pb');

const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
const Base64 = {
  btoa: (input: string = '') => {
    let str = input;
    let output = '';

    for (let block = 0, charCode, i = 0, map = chars;
      str.charAt(i | 0) || (map = '=', i % 1);
      output += map.charAt(63 & block >> 8 - i % 1 * 8)) {

      charCode = str.charCodeAt(i += 3 / 4);

      if (charCode > 0xFF) {
        throw new Error("'btoa' failed: The string to be encoded contains characters outside of the Latin1 range.");
      }

      block = block << 8 | charCode;
    }

    return output;
  },

  atob: (input: string = '') => {
    let str = input.replace(/=+$/, '');
    let output = '';

    if (str.length % 4 == 1) {
      throw new Error("'atob' failed: The string to be decoded is not correctly encoded.");
    }
    for (let bc = 0, bs = 0, buffer, i = 0;
      buffer = str.charAt(i++);

      ~buffer && (bs = bc % 4 ? bs * 64 + buffer : buffer,
        bc++ % 4) ? output += String.fromCharCode(255 & bs >> (-2 * bc & 6)) : 0
    ) {
      buffer = chars.indexOf(buffer);
    }

    return output;
  }
};

function arrayBufferToBase64(buffer: Iterable<number>) {
  let binary = '';
  let bytes = new Uint8Array(buffer);
  let len = bytes.byteLength;
  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return Base64.btoa(Base64.btoa(binary));
}

function make_a_request(url: String, text: String, imageBase64List: Array<String>) {
  var oneday = new messages.OneDay()
  let content = oneday.addContent()
  content.setText(text.trim())
  content.setImageList(imageBase64List)
  let data = oneday.serializeBinary()
  data = arrayBufferToBase64(data)
  //console.log(data)
  axios.post(url, {
    action: 'oneday',
    data: data,
  })
  .then(function (response: any) {
    console.log(response);
    setTimeout(()=>{
      location.reload();
    }, 1000)
  })
  .catch(function (error: any) {
    console.log(error);
  });
}

function UselessTextInput(props) {
  return (
    <TextInput
      {...props} // Inherit any props passed to it; e.g., multiline, numberOfLines below
      editable
      multiline
      autoFocus
      numberOfLines={8}
      maxLength={40}
    />
  );
}

export default function Editor( {navigation} ) {
  const [text, setText] = React.useState<String>('');
  const [imageUriList, setImageUriList] = React.useState<Array<String>>([]);
  const [imageBase64List, setImageBase64List] = React.useState<Array<String>>([]);

  const [state, dispatch] = useContext(store)

  return (
    <View style={styles.container}>
      <View
        style={styles.topWhite}
      >
      </View>

      <View
        style={styles.topBar}
      >
        <View
          style={styles.cancelButton}
        >
          <Button
            title="Cancel"
            color="#90A4AE"
            onPress={() => {
              //make_a_request(text, imageUriList)
              setText("")
              setImageUriList([])
              setImageBase64List([])
              navigation.navigate('Your History')
            }}
          >
          </Button>
        </View>
        <View
          style={styles.saveButton}
        >
          <Button
            title="Save"
            color="#FF5252"
            onPress={() => {
              make_a_request(state.urls.upload_url, text, imageBase64List)
              navigation.navigate('Your History')
            }}
          />
        </View>
      </View>

      <View
        style={styles.inputBox}
      >
        <UselessTextInput
          style={styles.textInput}
          onChangeText={(text: string) => {
            setText(text)
          }}
          value={text}
          placeholder={"What's happenning?"}
        />
      </View>

      <MyImagePicker
        style={styles.imagePicker}
        imageUriList={imageUriList}
        setImageUriList={setImageUriList}
        imageBase64List={imageBase64List}
        setImageBase64List={setImageBase64List}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  topWhite: {
    //flex: 0.5,
    //backgroundColor: "#fff",
  },

  topBar: {
    //https://reactnative.dev/docs/flexbox
    flex: 0.8,
    flexDirection: "row",
    justifyContent: "space-between",
    //backgroundColor: "#81D4FA"
  },
  cancelButton: {
    width: 20 / 100 * windowWidth,
    justifyContent: "center",
  },
  saveButton: {
    width: 20 / 100 * windowWidth,
    justifyContent: "center",
  },

  inputBox: {
    flex: 6,
    justifyContent: "center",
    alignItems: "center",
    margin: 2 / 100 * windowHeight,
    //backgroundColor: "#E57373",
  },
  textInput: {
    fontSize: 24,
  },

  imagePicker: {
    flex: 10,
    justifyContent: "flex-start",
    //backgroundColor: "#AB47BC"
  },
});