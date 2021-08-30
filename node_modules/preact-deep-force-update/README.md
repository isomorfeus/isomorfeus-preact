# preact-deep-force-update

[![NPM](http://img.shields.io/npm/v/preact-deep-force-update.svg)](https://www.npmjs.com/package/preact-deep-force-update)
[![travis-ci](https://travis-ci.org/developit/preact-deep-force-update.svg)](https://travis-ci.org/developit/preact-deep-force-update)

Recursively invoke forceUpdate() on a tree of components.

#### [JSFiddle Example](https://jsfiddle.net/developit/642ctu04/)


---


### Usage Example

```js
import { h, Component, render } from 'preact';
import deepForceUpdate from 'preact-deep-force-update';

class Main extends Component {
	render() {
		return <div><Inner /></div>;
	}
}

class Inner extends Component {
	render() {
		let time = new Date().toTimeString();
		return <span>{time}</span>;
	}
}

let main;
render(<Main ref={c => main=c } />, document.body);

// force an update to the whole tree:
deepForceUpdate(main);

// you can also pass an Element:
deepForceUpdate(document.body.firstChild);
```


---


### License

[MIT]


[Preact]: https://github.com/developit/preact
[MIT]: http://choosealicense.com/licenses/mit/
