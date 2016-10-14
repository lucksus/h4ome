# H4OME Native Client
This is the H4OME browser written mostly in QML/JS and a bit C++. It makes us of the [Flux architecture pattern](https://facebook.github.io/flux/docs/overview.html#content) with the QML Flux implementation [QuickFlux](https://github.com/benlau/quickflux) (must read: [Ben Lau's QML Application Architecture Guide with Flux](https://medium.com/@benlaud/qml-application-architecture-guide-with-flux-b4e970374635#.6y6qa6kd1))

## Build
Install [qpm](https://www.qpm.io/) and the do a

```
qpm install
```

in this directory which will download QuickFlux into the _vendor_ directory. Now you should be able build the project with QtCreator or

```
qmake
make
```

## Design
There is a **PersistenceStore** with two properties

 * holons
 * namespaces

Both are mapping strings to objects with meta attributes. Holons holds for every loaded holon its hash and the holon data itself:

```
{
	"/home/terence": {
		hash: 'Qm7af8555652ef7bc54b3d25998c3cd6b648948b4a509f5242f58d586a89cf86ef',
		data: {
			_holon_title: "Terence McKenna's example namespace",
			_holon_nodes: {
				"holon1": "Qm5aaf5c00fe1d97edb67d0e0c30496914ba49df11d2630863c695fa83761c367f"
			},
			_holon_edges:{}
		}
	}
}
```

Namespaces could look like this:

```
{
	"/home/terence": {
		writable: true,
		type: 'home',
		isSyncing: false,
		lastSynced: '2389472834', //unix time
		hash: "Qmasd3nddn23aefr23ln3wrt"
	},

	"/home/otherGuy": {
		writable: false,
		type: 'home',
		isSyncing: true,
		lastSynced: '...', //unix time
		hash: "Qmasd3nddn23aefr23ln3asdfasdfasdfwrt"
	}
}
```

A Flux store can only be read. Any updates are done by the store itself triggered by **Actions**. There **PersistanceActions** which are handled by the PersistenceStore:

* loadHolon(path)
* commitHolon(path, holon)
* pushNamespace(namespace_name)
* pullNamespace(namespace_name)
* createNamespace(namespace_name, options)

Find a usage example in *h4ome.qml* in **Component.onComplete**.