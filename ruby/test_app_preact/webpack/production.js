const path = require('path');
const OwlResolver = require('opal-webpack-loader/resolver');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

const common_config = {
    context: path.resolve(__dirname, '../app'),
    mode: "production",
    optimization: {
        minimize: true
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 20000000
    },
    output: {
        filename: '[name]-[chunkhash].js', // include fingerprint in file name, so browsers get the latest
        path: path.resolve(__dirname, '../public/assets'),
        publicPath: '/assets/'
    },
    resolve: {
        plugins: [
            new OwlResolver('resolve', 'resolved') // resolve ruby files
        ],
        alias: { 
            "react": "preact/compat"
        }
    },
    module: {
        rules: [
            {
                test: /.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
                use: [ "file-loader" ]
            },
            {
                test: /.(rb|js.rb)$/,
                use: [
                    {
                        loader: 'opal-webpack-loader',
                        options: {
                            sourceMap: false,
                            hmr: false
                        }
                    }
                ]
            }
        ]
    }
};

const browser_config = {
    target: 'web',
    entry: {
        application: [path.resolve(__dirname, '../app/imports/application.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }), // generate manifest
        new BundleAnalyzerPlugin({ analyzerMode: 'static', openAnalyzer: false, reportsFilename: 'report.html' })
    ],
};

const ssr_config = {
    target: 'node',
    entry: {
        application_ssr: [path.resolve(__dirname, '../app/imports/application_ssr.js')]
    },
    plugins: [
        new WebpackAssetsManifest({ publicPath: true, merge: true }) // generate manifest
    ],
};

const browser = Object.assign({}, common_config, browser_config);
const ssr = Object.assign({}, common_config, ssr_config);

module.exports = [ browser, ssr ];
