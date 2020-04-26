import React, { useContext, useEffect, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, Image } from 'react-native';
import { TextInput, Button } from 'react-native';

import { Dimensions } from 'react-native';
const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

import { store } from '../Store';

const axios = require('axios').default;

async function make_a_search_request(state, text: string) {
  return axios.post(state.urls.search_url, {
    text,
  })
  .then(function (response: any) {
    let data = response.data;
    if (data.status == "ok") {
      return data.result
    } else {
      return undefined
    }
  })
  .catch(function (error: any) {
    console.log(error);
  });
}

async function download_it(state, dispatch) {
  let url = state.urls.download_url
  if (state.data_download_url == undefined) {
    dispatch({type: "setDataDownloadUrl", payload: url})
  }
}

function SearchTextInput(props) {
  let {text, onTextChange, state, dispatch} = props

  return (
    <TextInput
      style={{ height: 5/100*windowHeight, borderColor: '#E0E0E0', borderWidth: 1 }}
      onChangeText={text => {
        onTextChange(text.trim())
      }}
      onKeyPress={(event) => {
        if (event.nativeEvent.key == "Enter") {
          async function do_it() {
            let search_result_list = await make_a_search_request(state, text)
            dispatch({type: "setSearchResultList", payload: search_result_list})
          }
          do_it()
        }
      }}
      value={text}
      placeholder={"What you wanna know?"}
      autoFocus
    />
  );
}

export default function Search() {
  const [state, dispatch] = useContext(store)
  const [text, onTextChange] = React.useState('');

  let search_output_view = []
  if (state.search_result_list != undefined) {
    state.search_result_list.map((message, index) => {
      //console.log(oneday.getDate())
      search_output_view.push(
        <View
          key={index}
        >
          <Text>
            {message.date}
          </Text>
          <Text>
            {message.text}
          </Text>
          { index+1 != state.search_result_list.length &&
            <Text>
              {"\n" + "---------------------" + "\n\n"}
            </Text>
          }
        </View>
      )
    })
  }

  return (
    <View
      style={styles.container}
    >
      <View
        style={styles.search_area}
      >
        <View
          style={styles.search_inputbox}
        >
          <SearchTextInput
            text={text}
            onTextChange={onTextChange}
            state={state}
            dispatch={dispatch}
          />
        </View>
        <View
          style={styles.search_outputbox}
        >
          <ScrollView
            contentContainerStyle={{ flexGrow: 1 }}
          >
            {search_output_view}
          </ScrollView>
        </View>
      </View>
      <View
        style={styles.download_area}
      >
        {
        state.data_download_url==undefined? 
        <View
          style={styles.download_button}
        >
          <Button
            title="Download Your Data"
            color="#90A4AE"
            onPress={() => {
              download_it(state, dispatch)
            }}
          >
          </Button>
        </View>
        :
        <View
          style={styles.download_link}
        >
          <a href={state.data_download_url}>
            {state.data_download_url}
          </a>
        </View>
        }
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexGrow: 1,
  },
  search_area: {
    flex: 1,
    justifyContent:"center",
    alignItems: "center",
    backgroundColor: "#E1F5FE",
  },
  download_area: {
    flex: 1,
    alignItems: "center",
    //backgroundColor: "#000",
    backgroundColor: "#FCE4EC",
  },
  search_inputbox: {
    flex: 1,
    width: windowWidth,
  },
  search_outputbox: {
    flex: 8,
    width: windowWidth,
    backgroundColor: "#E1F5FE",
    //backgroundColor: "#000",
  },
  download_button: {
    flex: 1,
    flexDirection: "column",
    justifyContent:"center",
    width: 50/100 * windowWidth,
  },
  download_link: {
    flex: 1,
    flexDirection: "column",
    justifyContent:"center",
  },
});