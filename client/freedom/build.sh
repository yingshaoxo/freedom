#expo publish
#expo build:android --no-publish
expo build:web
cp web-build ../../../kivy-diary/webviewTest/ -fr
