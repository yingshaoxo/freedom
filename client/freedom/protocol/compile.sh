#yarn add google-protobuf
#sudo yarn global add google-protobuf
protoc --proto_path=. --js_out=import_style=commonjs,binary:. everyday.proto
