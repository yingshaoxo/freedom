import React, { useContext, useEffect, useState } from 'react';
import { StyleSheet, Text, View, ScrollView, Image } from 'react-native';
import { TextInput, Button } from 'react-native';

import { Ionicons } from '@expo/vector-icons';
import { TouchableOpacity } from 'react-native';

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
    //console.log(data)
    let everyday = messages.EveryDay.deserializeBinary(data.mine)
    //console.log(everyday)
    let oneday_list = everyday.getOnedayList()
    //console.log(oneday_list)
    return oneday_list
  })
  .catch(function (error: any) {
    console.log(error);
  });
}

async function make_a_post_deletion_request(state, date: string, type: string, text: string) {
  axios.post(state.urls.delete_url, {
    date,
    type,
    text,
  })
  .then(function (response: any) {
    location.reload();
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
  let {oneday, state} = props
  const [modalVisible, setModalVisible] = useState(false);

  //console.log(content.getImageList())
  let has_text = oneday.getText().trim().length > 0

  let text_and_images = (
  <View
      style={styles.content}
  >
    {
    has_text && 
    <Text
      style={styles.text}
    >
      {oneday.getText()}
    </Text>
    }

    <Images
      image_list={oneday.getImageList()}
    >
    </Images>

  </View>
  )

  let delete_this_post = () => {
    make_a_post_deletion_request(state, oneday.getDate(), "mine", oneday.getText())
  }

  return (
    <View
      style={styles.oneday}
    >
      <View
        style={styles.datebar}
      >
        <TouchableOpacity onPress={delete_this_post}> 
          <Ionicons name="md-close" color="#E0E0E0" />
        </TouchableOpacity>
        <Text
          style={styles.date}
        >{oneday.getDate()}
        </Text>
        <TouchableOpacity onPress={() => {}}> 
          <Ionicons name="md-create" color="#E0E0E0" />
        </TouchableOpacity>
      </View>

      {text_and_images}
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
          state={state}
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
  datebar: {
    flexDirection: "row",
    justifyContent: "space-between",
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