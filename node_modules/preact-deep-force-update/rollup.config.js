import fs from 'fs';
import babel from 'rollup-plugin-babel';

var babelRc = JSON.parse(fs.readFileSync('.babelrc','utf8')); // eslint-disable-line

export default {
	exports: 'default',
	useStrict: false,
	plugins: [
		babel({
			babelrc: false,
			presets: ['es2015-minimal-rollup'].concat(babelRc.presets.slice(1)),
			plugins: babelRc.plugins,
			exclude: 'node_modules/**'
		})
	]
};
