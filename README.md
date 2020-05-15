## Using this application

The application can be accessed from <https://mixedreality.mozilla.org/area-demo-service-task>. Alternately, checkout the code, serve it from your webserver of choice, and load `index.html` in your browser.

The page is very simple, with a drop-down to select the service task, an indication of whether native WebXR is in use or the so-called "polyfill" which emulates WebXR on WebVR-only or non-XR browsers, and the last modified data of the file.

### The demo service task.

The application presents a highly-simplified service task. Choose a work from the drop-down list, and the second drop-down will display possible service tasks assigned to that worker.

The database of [workers](data/workers.json), [machines](data/machines.json), [services](data/services.json), and [assigned service tasks](data/assigned_services.json) is drawn from a set of local json files located in the `data` subdirectory.

Once the page has loaded, the WebAssembly module will be loaded, and provided the user has WebXR available, the button will display either "Enter AR" or "Enter VR", depending on device capabilities. Clicking the button will enter immersive mode.

In immersive mode, the three machines will be visible around the user. If using a head-mounted device with a controller, pointing the controller will display a ray which acts as a pointer for selection and action. On handheld devices, touching the screen will have the same effect.

Each machine will display its name in a floating label above the machine, and whether it is selected for service or not. You should be able to walk up to and around the machine to inspect it.

On the assigned machine, clicking the pointer will move to the next step in the service task.

Once the required steps are complete, a new service task can be initiated by navigating back to the main page and selecting a new user/task from the drop-down menus.

## How it works

The `index.html` file contains the page layout, as well as application settings, the WebAssembly loader, WebXR setup, and the main run loop. It is well commented, so looking through it should be instructive.

The is only one possible configuration; equally, the main run loop could have been in the WebAssembly module (as if calling `main()` in a C program). The choice to keep the main loop in Javascript in this application was made to assist understanding of the interaction between WebXR and OpenSceneGraph.



## Building from source

### Prerequisites

What | Minimum version | Where to download 
---- | --------------- | ------------
Emscripten | | <https://emscripten.org/docs/getting_started/downloads.html> |
OpenSceneGraph for WebAssembly | 3.7.0 | <https://github.com/MozillaReality/OpenSceneGraph/releases/download/OpenSceneGraph-3.7.0-wasm%2Bmozilla-gltf/openscenegraph-3.7.0-wasm+mozilla-gltf.zip>
bash shell | | On macOS/Linux use Terminal<br> On Windows, use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10), [Cygwin](https://cygwin.com/install.html), or [git-bash](https://gitforwindows.org/).

### Installing OpenSceneGraph for WebAssembly

These commands will download and unpack the compiled OpenSceneGraph for WebAssembly package and place it in the `dependencies` folder inside the repository:

```bash
cd dependencies
curl -LO https://github.com/MozillaReality/OpenSceneGraph/releases/download/OpenSceneGraph-3.7.0-wasm%2Bmozilla-gltf/openscenegraph-3.7.0-wasm+mozilla-gltf.zip
unzip openscenegraph-3.7.0-wasm+mozilla-gltf.zip
```

### Compiling AROSG.

A convenience script `build.sh` allows for easy one-line compilation of the C/C++ sources and linking with OSG to form the WebAssembly module and loader code.

`bash ./build.sh`

To see verbose buid output, add the parameter `--verbose`. To do a debug build (with extra console logging and function names in debug stack backtraces) add `--debug`. E.g.:

`bash ./build.sh --verbose --debug`

This will result in these files being created:

* `arosg.wasm` - The compiled WebAssembly module
* `arosg.js` - The script file loaded by the HTML page that is responsible for loading the WebAssembly module, as well as interop between Javascript and WebAssembly.
* `arosg.worker.js` - A script file loaded into worker threads in a multi-threaded WebAssembly environment.
* `arosg.data` - Contains the virtual filesystem for the WebAssembly.


## WebAssembly requirements

While WebAssembly itself is supported on all WebXR-capable browsers, OpenSceneGraph assumes availability of threading and so must (at present) be built with WebAssembly's threads support enabled. Unfortunately, WebAssembly threads depends in turn on Javascript's `SharedArrayBuffer` type, which was disabled by default in most browsers to mitigate the "Spectre" attacks. While `SharedArrayBuffer` is being gradually re-enabled by default, your browser might need some help.

* At the date of writing, **Firefox** requires a config flag to re-enable SharedArrayBuffer. In Firefox, type `about:config` in the URL bar, accept the warning, and then in the config search box type `javascript.options.shared_memory`. Click the ⇌ arrows symbol so that the value changes to `true` and close the config.
* **Firefox Reality** has SharedArrayBuffer enabled by default.
* **Chrome for Windows and macOS** has SharedArrayBuffer enabled by default, provided "cross origin isolation" is enabled for your site. (See below for details on how to enable "cross origin isolation".
* **Chrome for Android** requires a config flag to re-enable SharedArrayBuffer. In Chrome, type `chrome://flags` in the URL bar, and then in the flags search box type `WebAssembly threads`. Tap the pop-up and change the value from "Default" to "Enabled".
* **Magic Leap Helio** browser does not yet support multithreaded WebAssembly (as of Leap OS 0.98.10) although Magic Leap have tentatively committed to re-enabling support in a future release.

Unsupported browsers:

* **Safari for macOS/iOS** does not yet support SharedArrayBuffer. On iOS, you use [Mozilla's WebXR Viewer for iOS](https://apps.apple.com/app/webxr-viewer/id1295998056) (requires WebXR Viewer version 2.0 or later).
 

![1](doc/enable-js-sharedmem-ff.png)
![2](doc/enable-multithreaded-wasm-chrome-android.png)

### Enabling "cross origin isolation"

"Cross-origin isolation" refers to server-side config that enables protection features in the browser that make re-enablement of SharedArrayBuffer possible.

If your site is served by Apache, the simplest method is to create a `.htaccess` file in the top-level directory of your application with these lines included:

```
Header set Cross-Origin-Opener-Policy: same-origin
Header set Cross-Origin-Embedder-Policy: require-corp
```
To serve these, you will need to ensure that your apache config also loads the "headers" module. For Apache2, check the config file (`/etc/apache2/httpd.conf` or similar) has the option `LoadModule headers_module libexec/apache2/mod_headers.so` uncommented and enabled.

## Extensions and what contributions we'd encourage:

### Controller models
The WebXR input profiles repository includes modules to allow selection and display of the appropriate 3D model for the user
s controller(s). https://github.com/immersive-web/webxr-input-profiles/

