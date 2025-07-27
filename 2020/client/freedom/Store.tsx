import React, {createContext, useReducer} from 'react';
import { Platform } from 'react-native'

let host = "http://127.0.0.1"
let port = "8888"
if (Platform.OS == "web") {
  console.log("hi, web")
  host = location.protocol + '//' + document.domain + ':' + port //location.protocol + '//' + document.domain + ':' + location.port
} else {
  host = 'http://' + "192.168.31.38" + ':' + port
  //host = 'http://' + "192.168.49.31" + ':' + port
}

const upload_url = host + "/api/v1/upload"
const get_url = host + "/api/v1/get"
const download_url = host + "/api/v1/download"
const search_url = host + "/api/v1/search"
const delete_url = host + "/api/v1/delete"

const initialState = {
    platform: Platform.OS,
    urls: {
        host: host,
        upload_url: upload_url,
        get_url: get_url,
        download_url,
        search_url,
        delete_url,
    },
    oneday_list: [],
    fetched_at_boot: false,
    data_download_url: undefined,
    search_result_list: undefined,
};
export const store = createContext(null);

const reducer = (state, action) => {
switch(action.type) {
    case 'setOnedayList':
      return {
        ...state,
        oneday_list: action.payload,
        fetched_at_boot: true,
      };
    case 'setDataDownloadUrl':
      return {
        ...state,
        data_download_url: action.payload,
      };
    case 'setSearchResultList':
      return {
        ...state,
        search_result_list: action.payload,
      }
    default:
      throw new Error();
  }
};

export const StateProvider = props => {
    const [state, dispatch] = useReducer(reducer, initialState)

    return (
        <store.Provider value={[ state, dispatch ]}>
            {props.children}
        </store.Provider>
    )
}