const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.loaders.append('Fonts', {
  test: /\.(eot|svg|ttf|woff|woff2)$/,
  use: [{
    loader: 'file-loader',
    options: {
      name: '[path][name].[ext]',
      context: 'node_modules'
    }
  }]
})

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['@popperjs/core', 'default']
  })
)

module.exports = environment
