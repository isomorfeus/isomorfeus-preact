import { h, Component, render } from 'preact';
import deepForceUpdate from 'src';

describe('deepForceUpdate', () => {
	let scratch = document.createElement('div');

	before( () => document.body.appendChild(scratch) );
	afterEach( () => scratch.innerHTML = '' );
	after( () => document.body.removeChild(scratch) );

	it('should force updates', () => {
		let renders = {
			outer: 0,
			inner: 0
		};

		class Outer extends Component {
			render() {
				renders.outer++;
				return <div><Inner /></div>;
			}
		}

		class Inner extends Component {
			render() {
				renders.inner++;
				let time = new Date().toTimeString();
				return <span>{time}</span>;
			}
		}

		let outer;
		let root = render(<Outer ref={c => outer=c } />, scratch);

		expect(renders).to.have.property('outer', 1);
		expect(renders).to.have.property('inner', 1);

		// force an update to the whole tree:
		deepForceUpdate(outer);

		expect(renders).to.have.property('outer', 2);
		expect(renders).to.have.property('inner', 3);

		// you can also pass an Element:
		deepForceUpdate(root);

		expect(renders).to.have.property('outer', 3);
		expect(renders).to.have.property('inner', 5);
	});
});
