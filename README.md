# H4OME
## H4OME Holistic Holonic Holographic Object Meta Environment

As sequel to [Noomap](https://larcombe.io/projects/noomap/),
H4OME aims at being a new approach to how we do The Web
and cybersphere technology in general by combining holonic data representation
with blockchain technology, smart contracts, decentralized file storage,
isomorphic data-visualization, 3D AR/VR ready interfaces and a programmable
object space that introduces Holon Oriented Programming (HOOP) as the closure
of Object Oriented Programming with Subject Oriented Programming.

H4OME is designed to make use of [Ethereum](http://ethereum.org) and
[IPFS](https://ipfs.io/), though in its first
iterations and current state, those technologies are mocked within the
Holonic Map Server (H4MS) API backend.

The core of this system is the native client written mostly in QML/JavaScript
with a bit of C++. This code base is meant to run on iOS, Android, Linux,
MacOSX and Windows. It is a browser to navigate through the decentralized
and fractal holonic cyberspace that H4OME is.

### Contents

1. ```doc```: Documentation, holon examples, API spec, ...
2. ```h4ome```: native client, h4ome browser, UI around h4ome_core, Qt project
3. ```h4ome_core```: core classes and code, static library, Qt project
4. ```holon_directory_watcher```: tool to sync a filesystem directory into holon land, Qt commandline project
3. ```holonic_map_server```: REST API written with Ruby on Rails, now acting as an API
    backend to mock away Ethereum and IPFS, will later be a node within the
    decentralized system to store/cache holons and implement higher-level
    functionality as synergy engines and AIs
4. ```tests```: tests for native client, Qt project


### Build

To build the client you need [Qt >=5.7](https://www.qt.io/download/)
and a complete C++ toolchain installed.
You can use QtCreator and open all.pro or do a

```
qmake
make
```

in a shell.

For the Holonic Map Server you need [Ruby on Rails >=5.0](http://rubyonrails.org/) (which needs [Ruby >=2.2](https://github.com/rbenv/rbenv)).

__See also READMEs in subdirectories__

## Credits

Vision and code co-authored by Nicolas Luck and Chris Larcombe, 2017.