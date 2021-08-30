/** Invoke `.forceUpdate()` on a component and all descendants. */
export default function deepForceUpdate(component) {
	if (component.forceUpdate) {
		component.forceUpdate();
	}

	// high-order child recursion
	if (component._component) {
		deepForceUpdate(component._component);
	}
	else if (component.base) {
		updateComponentsFromDom(component.base);
	}
}

function updateComponentsFromDom(node, fn) {
	let children = node.childNodes;
	for (let i=children && children.length; i--; ) {
		let child = children[i];
		if (child._component) {
			deepForceUpdate(child._component);
		}
		else {
			updateComponentsFromDom(child, fn);
		}
	}
}
