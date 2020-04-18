import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

export default function History({navigation}) {
  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Text>Home!</Text>
      <Button
        title="Go to Editor"
        onPress={() => navigation.navigate('Add More')}
      />
    </View>
  );
}