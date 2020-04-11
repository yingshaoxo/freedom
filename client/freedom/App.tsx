import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

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
          onPress={() => console.log('Button pressed')}
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
