import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

const axios = require('axios').default;
var messages = require('./protocol/everyday_pb');

const host = location.protocol + '//' + document.domain + ':' + "8888" //location.protocol + '//' + document.domain + ':' + location.port
const upload_url = host + "/api/v1/upload"


function make_a_request() {
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
      numberOfLines={4}
      maxLength={40}
      style={styles.textInput}
    />
  );
}

export default function App() {
  const [text, setText] = React.useState('');

  const onChange = (text: string) => {
    console.log(text)
  }

  return (
    <View style={styles.container}>
      <UselessTextInput
        onChangeText={(text: string) => {
            setText(text)
            onChange(text)
        }}
        value={text}
        placeholder={"What you wanna say?\nType it here."}
      />

      <View
        style={styles.button}
      >
        <Button
          title="Save"
          onPress={() => {
            console.log('Button pressed')
            make_a_request()
          }}
        />
      </View>

    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#DCEDC8',
    alignItems: 'center',
    justifyContent: 'center',
  },
  textInput: {
    backgroundColor: '#F1F8E9',
    width: '100vw',
  },
  button: {
    marginTop: '2vh'
  }
});
