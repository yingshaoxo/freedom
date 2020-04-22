import React, { useContext, useEffect, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, Image } from 'react-native';
import { TextInput, Button } from 'react-native';

import { Dimensions } from 'react-native';
const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

import { store } from '../Store';

const axios = require('axios').default;

async function make_a_request(state) {
  return axios.post(state.urls.download_url, {
    action: 'get_everyday',
  })
  .then(function (response: any) {
    //console.log(response);
    let data = response.data;
    return data
  })
  .catch(function (error: any) {
    console.log(error);
  });
}

async function download_it(state, dispatch) {
  /*
  let string = await make_a_request(state)
  string = string.sql
  var file;
  var data = [];
  data.push(string);
  var properties = {type: 'text/plain'}; // Specify the file's mime-type.
  try {
    // Specify the filename using the File constructor, but ...
    file = new File(data, "data.txt", properties);
  } catch (e) {
    // ... fall back to the Blob constructor if that isn't supported.
    file = new Blob(data, properties);
  }
  var url = URL.createObjectURL(file);
  console.log(url)
  */
  let url = state.urls.download_url
  if (state.data_download_url == undefined) {
    dispatch({type: "setDataDownloadUrl", payload: url})
  }
}

export default function Search() {
  const [state, dispatch] = useContext(store)

  return (
    <View
      style={styles.container}
    >
      <View
        style={styles.search_area}
      >

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
    backgroundColor: "#E1F5FE",
  },
  download_area: {
    flex: 1,
    alignItems: "center",
    //backgroundColor: "#000",
    backgroundColor: "#FCE4EC",
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