const path = require('path');
const webpack = require('webpack');
const OwlResolver = require('opal-webpack-loader/resolver'); // to resolve ruby files
const ExtraWatchWebpackPlugin = require('extra-watch-webpack-plugin'); // to watch for added ruby files

const common_config = {
    context: path.resolve(__dirname, '../app'),
    mode: "development",
    optimization: {
        removeAvailableModules: false,
        removeEmptyChunks: false,
        minimize: false // dont minimize for debugging
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 2000000
    },
    // use one of these below for source maps
    devtool: 'source-map', // this works well, good compromise between accuracy and performance
    // devtool: 'cheap-eval-source-map', // less accurate
    // devtool: 'inline-source-map', // slowest
    // devtool: 'inline-cheap-source-map',
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, '../public/assets'),
        publicPath: 'http://localhost:3035/assets/'
    },
    resolve: {
        plugins: [new OwlResolver('resolve', 'resolved')], // this makes it possible for webpack to find ruby files
        alias: {
            'react-dom': 'react-dom/profiling',
            'schedule/tracing': 'schedule/tracing-profiling',
        }
    },
    plugins: [
        // both for hot reloading
        new webpack.NamedModulesPlugin(),
        new webpack.HotModuleReplacementPlugin(),
        // watch for added files in opal dir
        new ExtraWatchWebpackPlugin({ dirs: [path.resolve(__dirname, '../app')] })
    ],
    module: {
        rules: [
            {
                test: /.scss$/,
                use: [ "style-loader",
                    {
                        loader: "css-loader",
                        options: { sourceMap: true }
                    },
                    {
                        loader: "sass-loader",
                        options: {
                            includePaths: [path.resolve(__dirname, '../app/styles')],
                            sourceMap: true // set to false to speed up hot reloads
                        }
                    }
                ]
            },
            {
                test: /.css$/,
                use: [ "style-loader",
                    {
                        loader: "css-loader",
                        options: { sourceMap: true }
                    }
                ]
            },
            {
                test: /.(png|svg|jpg|gif|woff|woff2|eot|ttf|otf)$/,
                use: [ "file-loader" ]
            },
            {
                test: /(\.js)?\.rb$/,
                use: [
                    {
                        loader: 'opal-webpack-loader', // opal-webpack-loader will compile and include ruby files in the pack
                        options: {
                            sourceMap: true,
                            hmr: true,
                            hmrHook: 'Opal.Isomorfeus.$force_render()'
                        }
                    }
                ]
            }
        ]
    },
    // configuration for webpack-dev-server
    devServer: {
        open: false,
        port: 3035,
        hot: true,
        // hotOnly: true,
        https: false,
        allowedHosts: 'all',
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, PATCH, OPTIONS",
            "Access-Control-Allow-Headers": "X-Requested-With, content-type, Authorization"
        },
        static: {
            directory: path.resolve(__dirname, 'public'),
            watch: {
            // in case of problems with hot reloading uncomment the following two lines:
            // aggregateTimeout: 250,
            // poll: 50,
            ignored: /\bnode_modules\b/
            }
        },
        host: 'localhost'
    }
};

const browser_config = {
    target: 'web',
    entry: { application: [path.resolve(__dirname, '../app/imports/web.js')] },
    externals: { crypto: 'Crypto' }
};

const browser = Object.assign({}, common_config, browser_config);

module.exports = [ browser ];
