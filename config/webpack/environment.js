const { environment } = require('@rails/webpacker')

const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
  }))
module.exports = environment

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');
module.exports = environment
