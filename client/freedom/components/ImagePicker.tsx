import * as React from 'react';
import { Button, Image, View } from 'react-native';
import * as ImagePicker from 'expo-image-picker';
import Constants from 'expo-constants';
import * as Permissions from 'expo-permissions';

import {Dimensions} from 'react-native';
const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

import { StyleSheet } from 'react-native';

type MyImagePickerProps = {
  imageUriList: Array<String>
  setImageUriList: Function
}

export default class MyImagePicker extends React.Component<MyImagePickerProps> {
  render() {
    return (
      <View 
        {...this.props}
      >
        <View
          style={styles.pickImageButton}
        >
          <Button 
            title="Pick an image" 
            color="#FFCC80"
            onPress={this._pickImage} 
          />
        </View>

        <View
          style={styles.imageBox}
        >
          {
            this.props.imageUriList.map((value, index) => {
                return (
                  <View
                    style={styles.image}
                    key={index}
                  >
                    <Image key={index} source={{ uri: value }} style={styles.image}/>
                  </View>
                )
            })
          }
        </View>
      </View>
    );
  }

  componentDidMount() {
    this.getPermissionAsync();
  }

  getPermissionAsync = async () => {
    if (Constants.platform.ios) {
      const { status } = await Permissions.askAsync(Permissions.CAMERA_ROLL);
      if (status !== 'granted') {
        alert('Sorry, we need camera roll permissions to make this work!');
      }
    }
  };

  _pickImage = async () => {
    try {
      let result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        allowsEditing: true,
        aspect: [4, 3],
        quality: 1,
      });
      if (!result.cancelled) {
        this.props.setImageUriList([...this.props.imageUriList, result.uri])
      }
    } catch (E) {
      console.log(E);
    }
  };
}

const styles = StyleSheet.create({
  pickImageButton: {
    marginBottom: 0.5/100*windowHeight,
  },
  imageBox: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "flex-start",
    alignContent: "stretch",
    flexWrap: "wrap",
  },
  image: {
    width: 33.3/100*windowWidth, 
    height: 33.3/100*windowWidth,
  }
});
