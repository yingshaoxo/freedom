import React, { useContext, useEffect, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, Image } from 'react-native';
import { TextInput, Button } from 'react-native';

import { Dimensions } from 'react-native';
const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

import { store } from '../Store';

const axios = require('axios').default;
var messages = require('../protocol/everyday_pb');

async function make_a_request(state) {
  return axios.post(state.urls.get_url, {
    action: 'get_everyday',
  })
  .then(function (response: any) {
    //console.log(response);
    let data = response.data;
    let everyday = messages.EveryDay.deserializeBinary(data.sql)
    //console.log(everyday)
    let oneday_list = everyday.getOnedayList()
    //console.log(oneday_list)
    /*
    oneday_list.map((oneday) => {
      console.log(oneday.getDate())
      let contents = oneday.getContentList()
      contents.map((content, index) => {
        let images = content.getImageList()
        if (images) {
          images.map((image, index) => {
            console.log(image)
          })
        }
      })
    })
    */
    return oneday_list
  })
  .catch(function (error: any) {
    console.log(error);
  });
}

function Images(props) {
  let {image_list} = props
  let images_view = []

  image_list.map((image_data_uri, index) => {
    images_view.push(
      <Image
        key={index}
        style={styles.image}
        source={{
          uri: image_data_uri
        }}
      />
    )
  })

  return (
    <View
      style={styles.images}
    >
      {images_view}
    </View>
  )
}

function OneDay(props) {
  let {oneday} = props
  let content_list = oneday.getContentList()

  let content_view = []
  content_list.map((content, index) => {
    //console.log(content.getImageList())
    let has_text = content.getText().trim().length > 0
    content_view.push(
      <View
        style={styles.content}
        key={index}
      >

        {
        has_text && 
        <Text
          style={styles.text}
        >
          {content.getText()}
        </Text>
        }

        <Images
          image_list={content.getImageList()}
        >
        </Images>

      </View>
    )
  })

  return (
    <View
      style={styles.oneday}
    >
      <Text
        style={styles.date}
      >{oneday.getDate()}
      </Text>

      {content_view}
    </View>
  )
}

export default function History() {
  const [state, dispatch] = useContext(store)

  async function getData() {
    let oneday_list = await make_a_request(state)
    dispatch({type: "setOnedayList", payload: oneday_list})
  }

  let everyday_view = []
  if (state.fetched_at_boot == false) {
    getData()
  } else {
    state.oneday_list.map((oneday, index) => {
      //console.log(oneday.getDate())
      everyday_view.push(
        <OneDay
          key={index}
          oneday={oneday}
        >
        </OneDay>
      )
    })
  }

  return (
    <ScrollView
      contentContainerStyle={styles.everyday}
    >
      {everyday_view}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  everyday: {
    flexGrow: 1,
    backgroundColor: "#ECEFF1",
  },
  oneday: {
    width: windowWidth,
    marginBottom: 2/100 * windowHeight,
    backgroundColor: "#fff",
  },
  date: {
    textAlign: 'center', // <-- the magic
    marginBottom: 4/100 * windowHeight,
  },
  content: {
  },
  text: {
    textAlign: 'center', // <-- the magic
    fontSize: 16,
    marginBottom: 4/100 * windowHeight,
  },
  images: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "center",
    alignContent: "stretch",
    flexWrap: "wrap",
  },
  image: {
    width: 33.3/100*windowWidth, 
    height: 33.3/100*windowWidth,
    resizeMode: 'contain',
  }
});