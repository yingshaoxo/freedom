import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

import MyImagePicker from "./components/ImagePicker"; 
const axios = require('axios').default;
var messages = require('./protocol/everyday_pb');

//const host = location.protocol + '//' + document.domain + ':' + "8888" //location.protocol + '//' + document.domain + ':' + location.port
const host = 'http//' + "192.168.31.38" + ':' + "8888" //location.protocol + '//' + document.domain + ':' + location.port
const upload_url = host + "/api/v1/upload"


function make_a_request(text:String, imageUriList:Array<String>) {
  console.log(imageUriList.length)
  console.log(imageUriList)

  var everyday = new messages.EveryDay()
  console.log(everyday)
  let oneday = everyday.addOneday()
  oneday.setDate("3.1")
  let content = oneday.addContent()
  content.setText("hi")
  content = oneday.addContent()
  content.setText("I'm yingshaoxo")
  console.log(everyday)
  console.log(everyday.serializeBinary())
  let data = new TextDecoder().decode(everyday.serializeBinary())
  console.log(data)

  axios.post(upload_url, {
    action: 'everday',
    data: data
  })
  .then(function (response: any) {
    console.log(response);
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
      numberOfLines={8}
      maxLength={40}
    />
  );
}

export default function App() {
  const [text, setText] = React.useState<String>('');
  const [imageUriList, setImageUriList] = React.useState<Array<String>>([]);

  const onTextChange = (text: string) => {
    console.log(text)
  }

  return (
    <View style={styles.container}>
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
              console.log('Button pressed')
              make_a_request(text, imageUriList)
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
              console.log('Button pressed')
              make_a_request(text, imageUriList)
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
              onTextChange(text)
          }}
          value={text}
          placeholder={"What's happenning?"}
        />
      </View>

      <MyImagePicker
        style={styles.imagePicker}
        imageUriList={imageUriList}
        setImageUriList={setImageUriList}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
  },
  topBar: {
    //https://reactnative.dev/docs/flexbox
    marginTop: '0',
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
  },
  cancelButton: {
    width: "20vw",
  },
  saveButton: {
    width: "20vw",
  },
  inputBox: {
    justifyContent: "center",
    alignItems: "center",
    margin: "2vh",
  },
  textInput: {
    width: "90vw",
  },
  imagePicker: {
    flex: 1,
    justifyContent: "center",
  },
});
