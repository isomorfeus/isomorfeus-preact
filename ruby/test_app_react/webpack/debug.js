// require requirements used below
const path = require('path');
const webpack = require('webpack');
const OwlResolver = require('opal-webpack-loader/resolver'); // to resolve ruby files
const ExtraWatchWebpackPlugin = require('extra-watch-webpack-plugin'); // to watch for added ruby files

const common_config = {
    target: 'web',
    context: path.resolve(__dirname, '../app'),
    mode: "development",
    optimization: {
        removeAvailableModules: false,
        removeEmptyChunks: false,
        minimize: false // dont minimize for debugging
    },
    performance: {
        maxAssetSize: 20000000,
        maxEntrypointSize: 20000000
    },
    // use one of these below for source maps
    devtool: 'source-map', // this works well, good compromise between accuracy and performance
    // devtool: 'cheap-eval-source-map', // less accurate
    // devtool: 'inline-source-map', // slowest
    // devtool: 'inline-cheap-source-map',
    output: {
        // webpack-dev-server keeps the output in memory
        filename: '[name].js',
        path: path.resolve(__dirname, '../public/assets'),
        publicPath: 'http://localhost:3035/assets/'
    },
    resolve: {
        plugins: [new OwlResolver('resolve', 'resolved')], // this makes it possible for webpack to find ruby files
        alias: { 'react-native$': require.resolve('react-native-web') }
    },
    plugins: [
        // both for hot reloading
        new webpack.HotModuleReplacementPlugin(),
        // watch for added files in opal dir
        new ExtraWatchWebpackPlugin({ dirs: [path.resolve(__dirname, '../app')] }),
        new webpack.DefinePlugin({
            OPAL_DEVTOOLS_OBJECT_REGISTRY: true
        })
    ],
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: [/node_modules[/\\](?!react-native-vector-icons|react-native-safe-area-view)/, /.*\/opal\/corelib\/runtime.js$/],
                use: {
                    loader: 'babel-loader',
                    options: {
                        // Disable reading babel configuration
                        babelrc: false,
                        configFile: false,
                        // The configuration for compilation
                        presets: [
                            ['@babel/preset-env', { corejs: 3, useBuiltIns: 'usage' }],
                            '@babel/preset-react',
                            '@babel/preset-flow',
                            '@babel/preset-typescript'
                            ],
                        plugins: [
                            '@babel/plugin-proposal-class-properties',
                            '@babel/plugin-proposal-object-rest-spread'
                        ],
                    },
                },
            },
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
    entry: {
        application: [path.resolve(__dirname, '../app/imports/application.js')]
    }
};

const browser = Object.assign({}, common_config, browser_config);
// const ssr = Object.assign({}, common_config, ssr_config);

module.exports = [ browser ];
