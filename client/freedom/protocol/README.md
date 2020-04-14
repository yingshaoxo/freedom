### Compile
see `compile.sh`

### Usage
```
var messages = require('./protocol/everyday_pb');

var everyday = new messages.EveryDay()
console.log(everyday)
let oneday = everyday.addOneday()
oneday.setDate("3.1")
let content = oneday.addContent()
content.setText("hi")
content = oneday.addContent()
content.setText("I'm yingshaoxo")
console.log(everyday)
console.log(everyday.serializeBinary())
console.log(new TextDecoder().decode(everyday.serializeBinary()))
```