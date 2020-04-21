import React, { useState, useContext } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { TextInput, Button } from 'react-native';

import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
const Tab = createBottomTabNavigator();

import { StateProvider } from './Store';
import History from "./components/History";
import Editor from "./components/Editor";

export default function App() {
  return (
    <StateProvider>
      <NavigationContainer>
        <Tab.Navigator>
          <Tab.Screen name="Your History" component={History} />
          <Tab.Screen name="Add More" component={Editor} />
        </Tab.Navigator>
      </NavigationContainer>
    </StateProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});