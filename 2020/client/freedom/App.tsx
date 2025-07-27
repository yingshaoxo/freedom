import React, { useState, useContext } from 'react';

import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
//import { createStackNavigator } from '@react-navigation/stack';
//import { createDrawerNavigator } from '@react-navigation/drawer';
//const Stack = createStackNavigator();
//const Drawer = createDrawerNavigator();
const Tab = createBottomTabNavigator();

import { StateProvider } from './Store';
import History from "./components/History";
import Editor from "./components/Editor";
import Search from "./components/Search";

export default function App() {
  return (
    <StateProvider>
      <NavigationContainer>
        <Tab.Navigator initialRouteName="Your History">
          <Tab.Screen name="Your History" component={History} />
          <Tab.Screen name="Add More" component={Editor} />
          <Tab.Screen name="Search" component={Search} />
        </Tab.Navigator>
      </NavigationContainer>
    </StateProvider>
  );
}