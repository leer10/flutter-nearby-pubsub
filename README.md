# Flutter Nearby Pubsub

I've been toying around with using the [Nearby Connections](https://pub.dev/packages/nearby_connections) plugin and discovered that the API (as a result of Google's implementation) deals only with transmission of simple byte payloads. I wanted to use a framework that was more comprehensive (i.e. one that didn't require me to design and implement a client/server infrastructure) so I set to adapt one of the existing messenging-related plugins [pub_sub](https://pub.dev/packages/pub_sub) to use Nearby. This is just stuff I've cobbled together so it might need some cleanup but anyone's welcome to use my code as a reference or to integrate into their own projects.

I really wanted to work with Protobuf but I didn't wanna write too much by hand and gRPC integrates too tightly with HTTP/2. Socket IO has some really neat plugins on pub.dev but I couldn't figure out how to map Nearby StreamChannel connections (especially on the server side) to their WebSocket inputs. pub_sub does a lot for us by having a server on the host device, and emitting events to all the devices that are subscribed to those events without us having to deal with how it is doing that.

## Possible issues

 * I haven't tackled what should happen when one of the devices rejects a connection.
 * What happens when one of the devices loses connection is untested. However thanks to Nearby the connection does seem to survive a device's sleep button being touched.
 * pub_sub really prefers clients authenticate using IDs. It is possible to have the connecting devices send a generated ID and then when the pub_sub server is started, whitelist those IDs. However given only physically close devices can connect, I have no qualms trusting all clients with null IDs.
 * When publishing an event, the publishing device will not get its own event even if subscribed. Probably intentional to prevent doubled actions, but please keep it in mind.
 * Nearby doesn't react to hot-restart to my knowledge so when I was testing adding devices, I had to exit flutter and run "flutter run -d all" again.
 
## If you use this

You are by no means required to do this, but if you found this code at all useful and it helped you with a project than feel free to contact me and I would be happy to put your project here on a list.

## Special thanks

 * [thosakwe](https://github.com/thosakwe) for the pub_sub plugin
 * [mannprerak2](https://github.com/mannprerak2) for wiring the Nearby Connections API to a flutter plugin
 * The Google Nearby team for allowing serverless smartphone experiences
 * The Flutter team for making smartphone apps easy to write. Everything is a widget! XD
